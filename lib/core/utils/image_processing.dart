import 'dart:typed_data';

import 'package:image/image.dart' as img;

const kMaxProductImageBytes = 5 * 1024 * 1024;
const kAllowedProductImageExtensions = {'jpg', 'jpeg', 'png', 'webp'};
const kMaxProductImages = 10;
const _kMaxDimension = 1600;
const _kJpegQuality = 85;

class ImageValidationException implements Exception {
  ImageValidationException(this.message);
  final String message;

  @override
  String toString() => message;
}

String extensionOf(String fileName) {
  final dot = fileName.lastIndexOf('.');
  if (dot == -1 || dot == fileName.length - 1) return '';
  return fileName.substring(dot + 1).toLowerCase();
}

/// Throws [ImageValidationException] if [fileName]/[bytes] don't meet the
/// product-image constraints (type, size).
void validateProductImage(String fileName, Uint8List bytes) {
  final ext = extensionOf(fileName);
  if (!kAllowedProductImageExtensions.contains(ext)) {
    throw ImageValidationException('$fileName: unsupported file type. Use JPG, PNG, or WEBP.');
  }
  if (bytes.lengthInBytes > kMaxProductImageBytes) {
    final mb = (bytes.lengthInBytes / (1024 * 1024)).toStringAsFixed(1);
    throw ImageValidationException('$fileName: $mb MB exceeds the 5 MB limit.');
  }
}

/// Downscales to a max dimension of 1600px and re-encodes as JPEG (quality
/// 85) to keep storage/bandwidth down. Runs synchronously — product photos
/// are small enough that this doesn't noticeably block the UI thread, and
/// `compute()`'s isolate dispatch isn't available on web anyway.
Uint8List compressProductImage(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return bytes;

  final needsResize = decoded.width > _kMaxDimension || decoded.height > _kMaxDimension;
  final resized = needsResize
      ? img.copyResize(
          decoded,
          width: decoded.width >= decoded.height ? _kMaxDimension : null,
          height: decoded.height > decoded.width ? _kMaxDimension : null,
        )
      : decoded;

  return Uint8List.fromList(img.encodeJpg(resized, quality: _kJpegQuality));
}
