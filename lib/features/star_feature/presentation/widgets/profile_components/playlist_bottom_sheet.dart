import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/playlist_cubit/playlist_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/helper/bunny_video_uploader.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/style/app_colors.dart';
import 'playlist_details_page.dart';
import 'playlist_bottom_sheet_constants.dart';
import 'playlist_video_info_widget.dart';
import 'playlist_form_widget.dart';
import 'playlist_item_widget.dart';

class PlaylistBottomSheet extends StatefulWidget {
  final StarEntity video;

  const PlaylistBottomSheet({
    super.key,
    required this.video,
  });

  @override
  State<PlaylistBottomSheet> createState() => _PlaylistBottomSheetState();
}

class _PlaylistBottomSheetState extends State<PlaylistBottomSheet> {
  final TextEditingController _newPlaylistController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isCreatingPlaylist = false;
  File? _selectedThumbnail;
  bool _isUploadingThumbnail = false;
  String? _thumbnailMediaId;

  late final String _uniqueId;

  @override
  void initState() {
    super.initState();
    _uniqueId =
        'playlist_${DateTime.now().millisecondsSinceEpoch}_${widget.video.id}';
    context.read<PlaylistCubit>().getMyPlaylists(refresh: true);
  }

  @override
  void dispose() {
    _newPlaylistController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('playlist_bottom_sheet_$_uniqueId'),
      height: MediaQuery.of(context).size.height *
          PlaylistBottomSheetConstants.sheetHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHandleBar(),
          _buildHeader(),
          Divider(height: 1, color: Colors.grey[200]),
          _buildVideoInfoSection(),
          _buildCreateNewPlaylistSection(),
          Divider(height: 1, color: Colors.grey[200]),
          Expanded(child: _buildPlaylistsList()),
        ],
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      width: PlaylistBottomSheetConstants.handleWidth,
      height: PlaylistBottomSheetConstants.handleHeight,
      margin: const EdgeInsets.only(top: 12, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              ManageVibration.vibrate();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close,
                size: PlaylistBottomSheetConstants.iconSize),
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: Text(
              context.isArabic ? 'إضافة إلى قائمة تشغيل' : 'Add to Playlist',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildVideoInfoSection() {
    return PlaylistVideoInfoWidget(
      video: widget.video,
      uniqueId: _uniqueId,
    );
  }

  Widget _buildCreateNewPlaylistSection() {
    return _isCreatingPlaylist
        ? _buildCreatePlaylistForm()
        : _buildCreatePlaylistButton();
  }

  Widget _buildCreatePlaylistButton() {
    return Container(
      key: ValueKey('create_button_$_uniqueId'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
          setState(() {
            _isCreatingPlaylist = true;
          });
        },
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: PlaylistBottomSheetConstants.iconSize,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                context.isArabic
                    ? 'إنشاء قائمة تشغيل جديدة'
                    : 'Create new playlist',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.PRIMARY_COLOR,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatePlaylistForm() {
    return PlaylistFormWidget(
      uniqueId: _uniqueId,
      nameController: _newPlaylistController,
      descriptionController: _descriptionController,
      selectedThumbnail: _selectedThumbnail,
      isUploadingThumbnail: _isUploadingThumbnail,
      thumbnailMediaId: _thumbnailMediaId,
      onPickImage: _pickImage,
      onRemoveThumbnail: () {
        setState(() {
          _selectedThumbnail = null;
          _thumbnailMediaId = null;
        });
      },
      onCancel: _resetForm,
      onCreatePlaylist: _createPlaylistAndAddVideo,
      onPlaylistStateChanged: _handlePlaylistCreation,
    );
  }

  void _resetForm() {
    setState(() {
      _isCreatingPlaylist = false;
      _newPlaylistController.clear();
      _descriptionController.clear();
      _selectedThumbnail = null;
      _thumbnailMediaId = null;
    });
  }

  void _handlePlaylistCreation(BuildContext context, PlaylistState state) {
    if (state.isSuccess && !state.isCreating) {
      Navigator.pop(context);
      showSuccessMessage(
        context,
        context.isArabic
            ? 'تم إنشاء قائمة التشغيل وإضافة الفيديو'
            : 'Playlist created and video added',
        // Colors.green,
      );
    } else if (state.isError) {
      showErrorMessage(
        context,
        state.failure?.toString() ??
            (context.isArabic
                ? 'خطأ في إنشاء القائمة'
                : 'Failed to create playlist'),
      );
    }
  }

  Widget _buildPlaylistsList() {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (context, state) {
        if (state.isLoading && !state.hasPlaylists) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!state.hasPlaylists) {
          return _buildEmptyPlaylistsState();
        }

        return ListView.builder(
          key: ValueKey('playlists_list_$_uniqueId'),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.playlists.length,
          itemBuilder: (context, index) => PlaylistItemWidget(
            playlist: state.playlists[index],
            uniqueId: _uniqueId,
            onTap: () => _addVideoToPlaylist(state.playlists[index]),
          ),
        );
      },
    );
  }

  Widget _buildEmptyPlaylistsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.playlist_play,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            context.isArabic ? 'لا توجد قوائم تشغيل بعد' : 'No playlists yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.isArabic
                ? 'أنشئ قائمة تشغيل جديدة أعلاه'
                : 'Create a new playlist above',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: PlaylistBottomSheetConstants.maxImageWidth,
        maxHeight: PlaylistBottomSheetConstants.maxImageHeight,
        imageQuality: PlaylistBottomSheetConstants.imageQuality,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedThumbnail = File(pickedFile.path);
          _isUploadingThumbnail = true;
        });

        await _uploadThumbnail();
      }
    } catch (e) {
      _handleError(
        'Error picking image: $e',
        context.isArabic ? 'خطأ في اختيار الصورة' : 'Error picking image',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingThumbnail = false;
        });
      }
    }
  }

  Future<void> _uploadThumbnail() async {
    if (_selectedThumbnail == null) return;

    try {
      final uploadFile = UploadFile();
      bool uploadSuccess = false;
      String? mediaId;

      await uploadFile.uploadImageSilent(
        subCategoryId: Constants.tubeSubCategory,
        context: context,
        file: _selectedThumbnail!,
        onUploaded: (uploadEntity) {
          uploadSuccess = true;
          mediaId = uploadEntity.mediaId;
        },
      );

      if (uploadSuccess && mediaId != null) {
        if (mounted) {
          setState(() {
            _thumbnailMediaId = mediaId;
          });

          _showSnackBar(
            context.isArabic
                ? 'تم رفع الصورة بنجاح'
                : 'Image uploaded successfully',
            Colors.green,
          );
        }
      } else {
        throw Exception('Upload failed: No media ID received');
      }
    } catch (e) {
      _handleError(
        'Error uploading thumbnail: $e',
        context.isArabic ? 'خطأ في رفع الصورة' : 'Error uploading image',
      );

      if (mounted) {
        setState(() {
          _selectedThumbnail = null;
          _thumbnailMediaId = null;
        });
      }
    }
  }

  Future<void> _createPlaylistAndAddVideo() async {
    final validationError = _validatePlaylistForm();
    if (validationError != null) {
      _showSnackBar(validationError, Colors.orange);
      return;
    }

    try {
      final success = await context.read<PlaylistCubit>().createPlaylist(
            name: _newPlaylistController.text.trim(),
            description: _descriptionController.text.trim(),
            thumbnailMediaId: _thumbnailMediaId!,
          );

      if (success) {
        await context.read<PlaylistCubit>().getMyPlaylists(refresh: true);
        final playlists = context.read<PlaylistCubit>().state.playlists;
        if (playlists.isNotEmpty) {
          final newPlaylist = playlists.first;
          await _addVideoToPlaylist(newPlaylist, showSuccessMessage: false);
        }
      }
    } catch (e) {
      _handleError(
        'Error creating playlist: $e',
        context.isArabic
            ? 'فشل في إنشاء قائمة التشغيل'
            : 'Failed to create playlist',
      );
    }
  }

  String? _validatePlaylistForm() {
    if (_newPlaylistController.text.trim().isEmpty) {
      return context.isArabic
          ? 'يرجى إدخال اسم قائمة التشغيل'
          : 'Please enter playlist name';
    }

    if (_descriptionController.text.trim().isEmpty) {
      return context.isArabic
          ? 'يرجى إدخال وصف قائمة التشغيل'
          : 'Please enter playlist description';
    }

    if (_thumbnailMediaId == null) {
      return context.isArabic
          ? 'يرجى اختيار صورة مصغرة لقائمة التشغيل'
          : 'Please select a thumbnail for the playlist';
    }

    return null;
  }

  Future<void> _addVideoToPlaylist(PlaylistEntity playlist,
      {bool showSuccessMessage = true}) async {
    ManageVibration.vibrate();

    try {
      final success = await context.read<PlaylistCubit>().addVideoToPlaylist(
            playlist.id,
            widget.video.id,
          );

      if (success) {
        if (mounted) {
          Navigator.pop(context);
          if (showSuccessMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.isArabic
                      ? 'تم إضافة الفيديو إلى "${playlist.name}"'
                      : 'Added to "${playlist.name}"',
                ),
                backgroundColor: Colors.green,
                action: SnackBarAction(
                  label: context.isArabic ? 'عرض' : 'View',
                  textColor: Colors.white,
                  onPressed: () => _navigateToPlaylist(playlist),
                ),
              ),
            );
          }
        }
      } else {
        _showSnackBar(
          context.isArabic
              ? 'فشل في إضافة الفيديو'
              : 'Failed to add video to playlist',
          Colors.red,
        );
      }
    } catch (e) {
      _handleError(
        'Error adding video to playlist: $e',
        context.isArabic
            ? 'فشل في إضافة الفيديو'
            : 'Failed to add video to playlist',
      );
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
      );
    }
  }

  void _handleError(String debugMessage, String userMessage) {
    print(debugMessage);
    _showSnackBar(userMessage, Colors.red);
  }

  void _navigateToPlaylist(PlaylistEntity playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistDetailsPage(playlist: playlist),
      ),
    );
  }
}
