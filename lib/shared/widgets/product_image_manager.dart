import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/supabase_tables.dart';
import '../../core/utils/image_processing.dart';

enum ImageEntryStatus { existing, pending, uploading, uploaded, failed }

class ProductImageEntry {
  ProductImageEntry.existing(String url)
      : localId = url,
        bytes = null,
        fileName = null,
        remoteUrl = url,
        status = ImageEntryStatus.existing,
        errorMessage = null;

  ProductImageEntry.local({required this.bytes, required this.fileName})
      : localId = const Uuid().v4(),
        remoteUrl = null,
        status = ImageEntryStatus.pending,
        errorMessage = null;

  final String localId;
  final Uint8List? bytes;
  final String? fileName;
  String? remoteUrl;
  ImageEntryStatus status;
  String? errorMessage;

  bool get isUploaded => status == ImageEntryStatus.existing || status == ImageEntryStatus.uploaded;
}

/// Owns the working set of a product's images across the add/edit form:
/// existing (already-uploaded) images loaded from `product_images`, plus any
/// newly picked local files pending compression/upload. Compression and
/// validation happen as soon as a file is picked (so a bad file surfaces
/// immediately); the actual Storage upload happens on demand, via
/// [uploadPendingAndGetOrderedUrls], so nothing hits Storage for a product
/// the admin never saves.
class ProductImageManager extends ChangeNotifier {
  final List<ProductImageEntry> entries = [];
  final List<String> _removedExistingUrls = [];
  String? lastError;

  bool get isFull => entries.length >= kMaxProductImages;
  bool get isBusy => entries.any((e) => e.status == ImageEntryStatus.uploading);
  bool get hasFailed => entries.any((e) => e.status == ImageEntryStatus.failed);

  void loadExisting(List<String> urls) {
    entries.addAll(urls.map(ProductImageEntry.existing));
    notifyListeners();
  }

  Future<void> addFiles(List<XFile> files) async {
    lastError = null;
    final errors = <String>[];
    for (final file in files) {
      if (isFull) {
        errors.add('Only up to $kMaxProductImages images are allowed per product.');
        break;
      }
      try {
        final bytes = await file.readAsBytes();
        validateProductImage(file.name, bytes);
        final compressed = compressProductImage(bytes);
        entries.add(ProductImageEntry.local(bytes: compressed, fileName: file.name));
      } on ImageValidationException catch (e) {
        errors.add(e.message);
      } catch (e) {
        errors.add('${file.name}: could not read file ($e).');
      }
    }
    if (errors.isNotEmpty) lastError = errors.join('\n');
    notifyListeners();
  }

  void removeAt(int index) {
    final entry = entries[index];
    // Only entries uploaded to Storage *this session* (not yet attached to
    // the product via `replaceImages`) are safe to delete immediately —
    // pre-existing images stay until save, in case the admin cancels.
    if (entry.status == ImageEntryStatus.uploaded && entry.remoteUrl != null) {
      unawaited(_deleteFromStorage([entry.remoteUrl!]));
    }
    if (entry.status == ImageEntryStatus.existing && entry.remoteUrl != null) {
      _removedExistingUrls.add(entry.remoteUrl!);
    }
    entries.removeAt(index);
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    final entry = entries.removeAt(oldIndex);
    entries.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, entry);
    notifyListeners();
  }

  Future<void> retry(ProductImageEntry entry) => _uploadEntry(entry);

  Future<void> _uploadEntry(ProductImageEntry entry) async {
    entry.status = ImageEntryStatus.uploading;
    entry.errorMessage = null;
    notifyListeners();
    try {
      final storage = SupabaseConfig.client.storage.from(SupabaseBuckets.productImages);
      final path = '${const Uuid().v4()}.jpg';
      await storage.uploadBinary(path, entry.bytes!, fileOptions: const FileOptions(contentType: 'image/jpeg'));
      entry.remoteUrl = storage.getPublicUrl(path);
      entry.status = ImageEntryStatus.uploaded;
    } catch (e) {
      entry.status = ImageEntryStatus.failed;
      entry.errorMessage = 'Upload failed';
    }
    notifyListeners();
  }

  /// Uploads every not-yet-uploaded entry (in current order) and returns the
  /// final ordered URL list. Throws if any upload is still in a failed state
  /// afterward, so the caller can keep the admin on the form instead of
  /// silently saving a product with missing images.
  Future<List<String>> uploadPendingAndGetOrderedUrls() async {
    for (final entry in entries) {
      if (entry.status == ImageEntryStatus.pending || entry.status == ImageEntryStatus.failed) {
        await _uploadEntry(entry);
      }
    }
    if (entries.any((e) => e.status == ImageEntryStatus.failed)) {
      throw StateError('Some images failed to upload. Retry or remove them before saving.');
    }
    return entries.map((e) => e.remoteUrl!).toList();
  }

  /// Storage objects for images that were on the product before this edit
  /// and got removed during it — deleted once the product is actually saved.
  List<String> get removedExistingUrls => List.unmodifiable(_removedExistingUrls);

  Future<void> _deleteFromStorage(List<String> urls) async {
    if (urls.isEmpty) return;
    final paths = urls.map(_pathFromPublicUrl).whereType<String>().toList();
    if (paths.isEmpty) return;
    try {
      await SupabaseConfig.client.storage.from(SupabaseBuckets.productImages).remove(paths);
    } catch (_) {
      // Best-effort cleanup — an orphaned Storage object is a cost we accept
      // over blocking the admin's save/delete action on a cleanup failure.
    }
  }

  static String? _pathFromPublicUrl(String url) {
    final marker = '/object/public/${SupabaseBuckets.productImages}/';
    final i = url.indexOf(marker);
    if (i == -1) return null;
    return url.substring(i + marker.length);
  }
}

