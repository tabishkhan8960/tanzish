import 'package:cached_network_image/cached_network_image.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/image_processing.dart';
import 'product_image_manager.dart';

/// Drag-and-drop / click-to-browse product image manager: preview grid,
/// drag-to-reorder, per-image upload progress + retry, primary badge on the
/// first image. Backed by a [ProductImageManager] the parent screen owns, so
/// it can call [ProductImageManager.uploadPendingAndGetOrderedUrls] at save
/// time.
class ProductImageUploadField extends StatefulWidget {
  const ProductImageUploadField({super.key, required this.manager});

  final ProductImageManager manager;

  @override
  State<ProductImageUploadField> createState() => _ProductImageUploadFieldState();
}

class _ProductImageUploadFieldState extends State<ProductImageUploadField> {
  bool _dragHovering = false;
  final _picker = ImagePicker();

  Future<void> _browse() async {
    final files = await _picker.pickMultiImage(limit: kMaxProductImages);
    if (files.isEmpty) return;
    await widget.manager.addFiles(files);
    _showErrorIfAny();
  }

  void _showErrorIfAny() {
    final error = widget.manager.lastError;
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.manager,
      builder: (context, _) {
        final entries = widget.manager.entries;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Images', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              'JPG, PNG, or WEBP — up to 5 MB, up to $kMaxProductImages images. First image is the primary/thumbnail.',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 10),
            DropTarget(
              onDragEntered: (_) => setState(() => _dragHovering = true),
              onDragExited: (_) => setState(() => _dragHovering = false),
              onDragDone: (details) async {
                setState(() => _dragHovering = false);
                await widget.manager.addFiles(details.files);
                _showErrorIfAny();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _dragHovering ? AppColors.primary.withValues(alpha: 0.06) : AppColors.background,
                  border: Border.all(color: _dragHovering ? AppColors.primary : AppColors.border, width: _dragHovering ? 2 : 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (entries.isNotEmpty)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (var i = 0; i < entries.length; i++) _buildTile(context, i, entries[i]),
                        ],
                      ),
                    if (entries.isNotEmpty) const SizedBox(height: 12),
                    Icon(Icons.cloud_upload_outlined, size: 28, color: _dragHovering ? AppColors.primary : AppColors.textSecondary),
                    const SizedBox(height: 6),
                    Text(
                      'Drag & drop images here',
                      style: TextStyle(color: _dragHovering ? AppColors.primary : AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: widget.manager.isFull ? null : _browse,
                      icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                      label: Text(widget.manager.isFull ? 'Limit reached' : 'Browse files'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTile(BuildContext context, int index, ProductImageEntry entry) {
    final tile = _ImageTile(
      entry: entry,
      isPrimary: index == 0,
      onDelete: () => widget.manager.removeAt(index),
      onRetry: () => widget.manager.retry(entry),
    );

    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => details.data != index,
      onAcceptWithDetails: (details) => widget.manager.reorder(details.data, index),
      builder: (context, candidateData, rejectedData) {
        final showDropHighlight = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: showDropHighlight ? Border.all(color: AppColors.primary, width: 2) : null,
          ),
          child: Draggable<int>(
            data: index,
            feedback: Opacity(opacity: 0.85, child: SizedBox(width: 96, height: 96, child: tile)),
            childWhenDragging: Opacity(opacity: 0.3, child: tile),
            child: tile,
          ),
        );
      },
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({required this.entry, required this.isPrimary, required this.onDelete, required this.onRetry});

  final ProductImageEntry entry;
  final bool isPrimary;
  final VoidCallback onDelete;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: entry.bytes != null
                ? Image.memory(entry.bytes!, fit: BoxFit.cover)
                : CachedNetworkImage(imageUrl: entry.remoteUrl!, fit: BoxFit.cover),
          ),
          if (isPrimary)
            Positioned(
              left: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                child: const Text('Primary', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
              ),
            ),
          if (entry.status == ImageEntryStatus.uploading)
            Container(
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(10)),
              child: const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))),
            ),
          if (entry.status == ImageEntryStatus.failed)
            Container(
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white, size: 18),
                    const SizedBox(height: 2),
                    InkWell(
                      onTap: onRetry,
                      child: const Text('Retry', style: TextStyle(color: Colors.white, fontSize: 11, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            right: 2,
            top: 2,
            child: InkWell(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
