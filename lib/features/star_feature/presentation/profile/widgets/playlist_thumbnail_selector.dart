import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'playlist_bottom_sheet_constants.dart';

class PlaylistThumbnailSelector extends StatelessWidget {
  final String uniqueId;
  final File? selectedThumbnail;
  final bool isUploading;
  final Function(ImageSource) onPickImage;
  final VoidCallback onRemove;

  const PlaylistThumbnailSelector({
    super.key,
    required this.uniqueId,
    required this.selectedThumbnail,
    required this.isUploading,
    required this.onPickImage,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('thumbnail_section_$uniqueId'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.isArabic ? 'صورة قائمة التشغيل' : 'Playlist Thumbnail',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildThumbnailPreview(),
            const SizedBox(width: 12),
            _buildUploadButtons(context),
          ],
        ),
        if (selectedThumbnail != null) _buildSelectedThumbnailInfo(context),
        const SizedBox(height: 4),
        Text(
          context.isArabic
              ? 'يرجى اختيار صورة مصغرة لقائمة التشغيل'
              : 'Please select a thumbnail for the playlist',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailPreview() {
    return Container(
      width: PlaylistBottomSheetConstants.thumbnailWidth,
      height: PlaylistBottomSheetConstants.thumbnailHeight,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius:
            BorderRadius.circular(PlaylistBottomSheetConstants.borderRadius),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: selectedThumbnail != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(
                  PlaylistBottomSheetConstants.borderRadius),
              child: Image.file(
                selectedThumbnail!,
                fit: BoxFit.cover,
              ),
            )
          : Icon(
              Icons.image_outlined,
              size: 32,
              color: Colors.grey[400],
            ),
    );
  }

  Widget _buildUploadButtons(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _buildImageSourceButton(
            context: context,
            icon: Icons.photo_library,
            label: context.isArabic ? 'من المعرض' : 'From Gallery',
            source: ImageSource.gallery,
          ),
          const SizedBox(height: 8),
          _buildImageSourceButton(
            context: context,
            icon: Icons.camera_alt,
            label: context.isArabic ? 'من الكاميرا' : 'From Camera',
            source: ImageSource.camera,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSourceButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isUploading ? null : () => onPickImage(source),
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                PlaylistBottomSheetConstants.smallBorderRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedThumbnailInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 4),
          Text(
            context.isArabic ? 'تم اختيار الصورة' : 'Image selected',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onRemove,
            child: Text(
              context.isArabic ? 'إزالة' : 'Remove',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
