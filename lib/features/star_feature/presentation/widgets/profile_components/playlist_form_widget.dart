import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/playlist_cubit/playlist_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'playlist_bottom_sheet_constants.dart';
import 'playlist_thumbnail_selector.dart';

class PlaylistFormWidget extends StatelessWidget {
  final String uniqueId;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final File? selectedThumbnail;
  final bool isUploadingThumbnail;
  final String? thumbnailMediaId;
  final Function(ImageSource) onPickImage;
  final VoidCallback onRemoveThumbnail;
  final VoidCallback onCancel;
  final VoidCallback onCreatePlaylist;
  final Function(BuildContext, PlaylistState) onPlaylistStateChanged;

  const PlaylistFormWidget({
    super.key,
    required this.uniqueId,
    required this.nameController,
    required this.descriptionController,
    required this.selectedThumbnail,
    required this.isUploadingThumbnail,
    required this.thumbnailMediaId,
    required this.onPickImage,
    required this.onRemoveThumbnail,
    required this.onCancel,
    required this.onCreatePlaylist,
    required this.onPlaylistStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('create_form_$uniqueId'),
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader(context),
          const SizedBox(height: 12),
          PlaylistThumbnailSelector(
            uniqueId: uniqueId,
            selectedThumbnail: selectedThumbnail,
            isUploading: isUploadingThumbnail,
            onPickImage: onPickImage,
            onRemove: onRemoveThumbnail,
          ),
          const SizedBox(height: 16),
          _buildNameField(context),
          const SizedBox(height: 12),
          _buildDescriptionField(context),
          const SizedBox(height: 12),
          _buildCreateButton(context),
        ],
      ),
    );
  }

  Widget _buildFormHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.isArabic ? 'قائمة تشغيل جديدة' : 'New Playlist',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: onCancel,
          child: Text(
            context.isArabic ? 'إلغاء' : 'Cancel',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextField(
      key: ValueKey('name_field_$uniqueId'),
      controller: nameController,
      decoration: _buildInputDecoration(
        labelText: context.isArabic ? 'اسم قائمة التشغيل *' : 'Playlist name *',
        hintText: context.isArabic ? 'اسم قائمة التشغيل' : 'Playlist name',
      ),
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return TextField(
      key: ValueKey('description_field_$uniqueId'),
      controller: descriptionController,
      maxLines: 3,
      decoration: _buildInputDecoration(
        labelText: context.isArabic ? 'الوصف *' : 'Description *',
        hintText: context.isArabic ? 'الوصف' : 'Description',
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return BlocConsumer<PlaylistCubit, PlaylistState>(
      listener: onPlaylistStateChanged,
      builder: (context, state) {
        return SizedBox(
          key: ValueKey('create_btn_$uniqueId'),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (state.isCreating || isUploadingThumbnail) ? null : onCreatePlaylist,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.PRIMARY_COLOR,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PlaylistBottomSheetConstants.borderRadius),
              ),
            ),
            child: (state.isCreating || isUploadingThumbnail)
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    context.isArabic ? 'إنشاء وإضافة' : 'Create & Add',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }

  InputDecoration _buildInputDecoration({required String labelText, required String hintText}) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[500]),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(PlaylistBottomSheetConstants.borderRadius),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(PlaylistBottomSheetConstants.borderRadius),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(PlaylistBottomSheetConstants.borderRadius),
        borderSide: const BorderSide(color: AppColors.PRIMARY_COLOR, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}