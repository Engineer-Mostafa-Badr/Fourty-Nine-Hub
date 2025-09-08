import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/playlist_cubit/playlist_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../res/style/app_colors.dart';

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
  bool _isCreatingPlaylist = false;

  @override
  void initState() {
    super.initState();
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
                color: AppColors.PRIMARY_COLOR,
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
      padding: EdgeInsets.all(16),
      color: AppColors.PRIMARY_COLOR,
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

          // Playlist name field
          TextField(
            controller: _newPlaylistController,
            decoration: InputDecoration(
              hintText:
                  context.isArabic ? 'اسم قائمة التشغيل' : 'Playlist name',
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
                borderSide:
                    BorderSide(color: AppColors.PRIMARY_COLOR, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          SizedBox(height: 8),

          // Description field
          TextField(
            controller: _descriptionController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: context.isArabic
                  ? 'الوصف (اختياري)'
                  : 'Description (optional)',
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
                borderSide:
                    BorderSide(color: AppColors.PRIMARY_COLOR, width: 2),
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
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      state.isCreating ? null : _createPlaylistAndAddVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: state.isCreating
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
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: state.playlists.length,
          itemBuilder: (context, index) {
            final playlist = state.playlists[index];
            return _buildPlaylistItem(playlist);
          },
        );
      },
    );
  }

  Widget _buildPlaylistItem(PlaylistEntity playlist) {
    return Container(
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                        playlist.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
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

  Future<void> _createPlaylistAndAddVideo() async {
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

    final success = await context.read<PlaylistCubit>().createPlaylist(
          name: _newPlaylistController.text.trim(),
          description: _descriptionController.text.trim(),
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
    Navigator.pushNamed(
      context,
      '/playlist-details',
      arguments: playlist,
    );
  }
}
