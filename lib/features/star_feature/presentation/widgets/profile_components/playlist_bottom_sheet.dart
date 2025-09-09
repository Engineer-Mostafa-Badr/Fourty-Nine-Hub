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
import '../../../../../res/style/app_colors.dart';
import 'playlist_details_page.dart';

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

  // Generate unique identifier for this instance
  late final String _uniqueId;

  @override
  void initState() {
    super.initState();
    _uniqueId = 'playlist_${DateTime.now().millisecondsSinceEpoch}_${widget.video.id}';
    // Load user's playlists when sheet opens
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
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    ManageVibration.vibrate();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, size: 24),
                  padding: EdgeInsets.zero,
                ),
                Expanded(
                  child: Text(
                    context.isArabic
                        ? 'إضافة إلى قائمة تشغيل'
                        : 'Add to Playlist',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[200]),

          // Video info section
          _buildVideoInfoSection(),

          // Create new playlist section
          _buildCreateNewPlaylistSection(),

          Divider(height: 1, color: Colors.grey[200]),

          // Existing playlists
          Expanded(
            child: _buildPlaylistsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoInfoSection() {
    return Container(
      key: ValueKey('video_info_$_uniqueId'),
      padding: EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Row(
        children: [
          // Video thumbnail
          Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[300],
              image: DecorationImage(
                image: AssetImage('assets/images/testforvideo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12),

          // Video info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  "${widget.video.user.firstName} ${widget.video.user.lastName}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              decoration: BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                context.isArabic
                    ? 'إنشاء قائمة تشغيل جديدة'
                    : 'Create new playlist',
                style: TextStyle(
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
    return Container(
      key: ValueKey('create_form_$_uniqueId'),
      padding: EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.isArabic ? 'قائمة تشغيل جديدة' : 'New Playlist',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isCreatingPlaylist = false;
                    _newPlaylistController.clear();
                    _descriptionController.clear();
                    _selectedThumbnail = null;
                    _thumbnailMediaId = null;
                  });
                },
                child: Text(
                  context.isArabic ? 'إلغاء' : 'Cancel',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Thumbnail selection section
          _buildThumbnailSection(),
          SizedBox(height: 16),

          // Playlist name field
          TextField(
            key: ValueKey('name_field_$_uniqueId'),
            controller: _newPlaylistController,
            decoration: InputDecoration(
              labelText: context.isArabic ? 'اسم قائمة التشغيل *' : 'Playlist name *',
              hintText: context.isArabic ? 'اسم قائمة التشغيل' : 'Playlist name',
              hintStyle: TextStyle(color: Colors.grey[500]),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.PRIMARY_COLOR, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          SizedBox(height: 12),

          // Description field
          TextField(
            key: ValueKey('description_field_$_uniqueId'),
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: context.isArabic ? 'الوصف *' : 'Description *',
              hintText: context.isArabic ? 'الوصف' : 'Description',
              hintStyle: TextStyle(color: Colors.grey[500]),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.PRIMARY_COLOR, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          SizedBox(height: 12),

          // Create button
          BlocConsumer<PlaylistCubit, PlaylistState>(
            listener: (context, state) {
              if (state.isSuccess && !state.isCreating) {
                // Playlist created successfully, add video to it
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.isArabic
                          ? 'تم إنشاء قائمة التشغيل وإضافة الفيديو'
                          : 'Playlist created and video added',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state.isError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.failure?.toString() ??
                          (context.isArabic
                              ? 'خطأ في إنشاء القائمة'
                              : 'Failed to create playlist'),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return SizedBox(
                key: ValueKey('create_btn_$_uniqueId'),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (state.isCreating || _isUploadingThumbnail) 
                      ? null 
                      : _createPlaylistAndAddVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: (state.isCreating || _isUploadingThumbnail)
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          context.isArabic ? 'إنشاء وإضافة' : 'Create & Add',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailSection() {
    return Column(
      key: ValueKey('thumbnail_section_$_uniqueId'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.isArabic ? 'صورة قائمة التشغيل' : 'Playlist Thumbnail',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        
        Row(
          children: [
            // Thumbnail preview
            Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _selectedThumbnail != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedThumbnail!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.image_outlined,
                      size: 32,
                      color: Colors.grey[400],
                    ),
            ),
            SizedBox(width: 12),
            
            // Upload buttons
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isUploadingThumbnail ? null : () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library, size: 18),
                      label: Text(
                        context.isArabic ? 'من المعرض' : 'From Gallery',
                        style: TextStyle(fontSize: 14),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isUploadingThumbnail ? null : () => _pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt, size: 18),
                      label: Text(
                        context.isArabic ? 'من الكاميرا' : 'From Camera',
                        style: TextStyle(fontSize: 14),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        if (_selectedThumbnail != null) ...[
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 16),
              SizedBox(width: 4),
              Text(
                context.isArabic ? 'تم اختيار الصورة' : 'Image selected',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedThumbnail = null;
                    _thumbnailMediaId = null;
                  });
                },
                child: Text(
                  context.isArabic ? 'إزالة' : 'Remove',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
        
        SizedBox(height: 4),
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

  Widget _buildPlaylistsList() {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (context, state) {
        if (state.isLoading && !state.hasPlaylists) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!state.hasPlaylists) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.playlist_play,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  context.isArabic
                      ? 'لا توجد قوائم تشغيل بعد'
                      : 'No playlists yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
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

        return ListView.builder(
          key: ValueKey('playlists_list_$_uniqueId'),
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: state.playlists.length,
          itemBuilder: (context, index) {
            final playlist = state.playlists[index];
            return _buildPlaylistItem(playlist, index);
          },
        );
      },
    );
  }

  Widget _buildPlaylistItem(PlaylistEntity playlist, int index) {
    return Container(
      key: ValueKey('playlist_item_${playlist.id}_$_uniqueId'),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _addVideoToPlaylist(playlist),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                // Playlist thumbnail
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey[300],
                  ),
                  child: Stack(
                    children: [
                      // Background
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.grey[300],
                          image: playlist.thumbnail.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(playlist.thumbnail),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: playlist.thumbnail.isEmpty
                            ? Icon(Icons.playlist_play, color: Colors.grey[600])
                            : null,
                      ),

                      // Video count overlay
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '${playlist.videosCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),

                // Playlist info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.isArabic
                            ? '${playlist.videosCount} فيديو'
                            : '${playlist.videosCount} videos',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (playlist.description.isNotEmpty) ...[
                        SizedBox(height: 2),
                        Text(
                          playlist.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Add button
                Icon(
                  Icons.add_circle_outline,
                  color: AppColors.PRIMARY_COLOR,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedThumbnail = File(pickedFile.path);
          _isUploadingThumbnail = true;
        });

        // Upload image and get media ID
        await _uploadThumbnail();
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.isArabic
                ? 'خطأ في اختيار الصورة'
                : 'Error picking image',
          ),
          backgroundColor: Colors.red,
        ),
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
        subCategoryId: Constants.tubeSubCategory, // You might need to get this from your app's context
        context: context,
        file: _selectedThumbnail!,
        onUploaded: (uploadEntity) {
          uploadSuccess = true;
          mediaId = uploadEntity.mediaId;
        },
      );

      if (uploadSuccess && mediaId != null) {
        setState(() {
          _thumbnailMediaId = mediaId;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.isArabic
                  ? 'تم رفع الصورة بنجاح'
                  : 'Image uploaded successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      print('Error uploading thumbnail: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.isArabic
                ? 'خطأ في رفع الصورة'
                : 'Error uploading image',
          ),
          backgroundColor: Colors.red,
        ),
      );
      
      // Reset thumbnail selection on upload failure
      setState(() {
        _selectedThumbnail = null;
        _thumbnailMediaId = null;
      });
    }
  }

  Future<void> _createPlaylistAndAddVideo() async {
    // Validation
    if (_newPlaylistController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.isArabic
                ? 'يرجى إدخال اسم قائمة التشغيل'
                : 'Please enter playlist name',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.isArabic
                ? 'يرجى إدخال وصف قائمة التشغيل'
                : 'Please enter playlist description',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_thumbnailMediaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.isArabic
                ? 'يرجى اختيار صورة مصغرة لقائمة التشغيل'
                : 'Please select a thumbnail for the playlist',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = await context.read<PlaylistCubit>().createPlaylist(
      name: _newPlaylistController.text.trim(),
      description: _descriptionController.text.trim(),
      thumbnailMediaId: _thumbnailMediaId!,
    );

    if (success) {
      // Refresh playlists to get the new one
      await context.read<PlaylistCubit>().getMyPlaylists(refresh: true);

      // Find the newly created playlist (should be first in the list)
      final playlists = context.read<PlaylistCubit>().state.playlists;
      if (playlists.isNotEmpty) {
        final newPlaylist = playlists.first;
        await _addVideoToPlaylist(newPlaylist, showSuccessMessage: false);
      }
    }
  }

  Future<void> _addVideoToPlaylist(PlaylistEntity playlist,
      {bool showSuccessMessage = true}) async {
    ManageVibration.vibrate();

    final success = await context.read<PlaylistCubit>().addVideoToPlaylist(
          playlist.id,
          widget.video.id,
        );

    if (success) {
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.isArabic
                ? 'فشل في إضافة الفيديو'
                : 'Failed to add video to playlist',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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