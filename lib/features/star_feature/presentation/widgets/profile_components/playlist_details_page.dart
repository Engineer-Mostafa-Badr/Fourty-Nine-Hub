import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/playlist_cubit/playlist_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/star_cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/common/loading_indicator.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/common/error_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/common/thumbnail_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/common/options_bottom_sheet.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../domain/entity/user_star_entity.dart';

class PlaylistDetailsPage extends StatefulWidget {
  final PlaylistEntity playlist;
  final bool isCurrentUser;

  const PlaylistDetailsPage({
    super.key,
    required this.playlist,
    this.isCurrentUser = true,
  });

  @override
  State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
  late PlaylistCubit _playlistCubit;
  int _currentVideoIndex = 0;
  bool _isShuffleEnabled = false;
  bool _isRepeatEnabled = false;

  @override
  void initState() {
    super.initState();
    _playlistCubit = context.read<PlaylistCubit>();
    _loadPlaylistDetails();
  }

  void _loadPlaylistDetails() {
    _playlistCubit.getPlaylistDetails(widget.playlist.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<PlaylistCubit, PlaylistState>(
          builder: (context, state) {
            if (state.isLoading && state.selectedPlaylist == null) {
              return Center(
                child: StarLoadingIndicator(
                  message: context.isArabic
                      ? 'جاري تحميل قائمة التشغيل...'
                      : 'Loading playlist...',
                ),
              );
            }

            if (state.isError && state.selectedPlaylist == null) {
              return Center(
                child: StarErrorWidget(
                  message: state.failure?.toString() ??
                      (context.isArabic
                          ? 'خطأ في تحميل قائمة التشغيل'
                          : 'Failed to load playlist'),
                  onRetry: _loadPlaylistDetails,
                ),
              );
            }

            final playlist = state.selectedPlaylist ?? widget.playlist;

            return CustomScrollView(
              slivers: [
                // App Bar
                _buildSliverAppBar(playlist),

                // Playlist Header
                SliverToBoxAdapter(
                  child: _buildPlaylistHeader(playlist),
                ),

                // Control Buttons
                SliverToBoxAdapter(
                  child: _buildControlButtons(playlist),
                ),

                // Videos List
                _buildVideosList(playlist),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(PlaylistEntity playlist) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          ManageVibration.vibrate();
          Navigator.pop(context);
        },
      ),
      title: Text(
        playlist.name,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        if (widget.isCurrentUser)
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, playlist),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20, color: Colors.grey[700]),
                    SizedBox(width: 12),
                    Text(context.isArabic ? 'تعديل' : 'Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text(
                      context.isArabic ? 'حذف' : 'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPlaylistHeader(PlaylistEntity playlist) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist cover/thumbnail
          GestureDetector(
            onTap: () => _playAllVideos(playlist),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: playlist.thumbnail.isNotEmpty
                        ? Image.network(
                            playlist.thumbnail,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultPlaylistCover(),
                          )
                        : _buildDefaultPlaylistCover(),
                  ),

                  // Play overlay
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  // Video count badge
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${playlist.videosCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 16),

          // Playlist info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlist.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),

                Text(
                  context.isArabic
                      ? '${playlist.videosCount} فيديو • ${timeago.format(playlist.createdAt, locale: context.locale.languageCode)}'
                      : '${playlist.videosCount} videos • ${timeago.format(playlist.createdAt, locale: context.locale.languageCode)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),

                if (playlist.description.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Text(
                    playlist.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                SizedBox(height: 16),

                // Privacy/Visibility indicator
                Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      context.isArabic ? 'خاصة' : 'Private',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultPlaylistCover() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[400]!,
            Colors.purple[600]!,
          ],
        ),
      ),
      child: Icon(
        Icons.playlist_play,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _buildControlButtons(PlaylistEntity playlist) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Play All button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _playAllVideos(playlist),
              icon: Icon(Icons.play_arrow, size: 20),
              label: Text(
                context.isArabic ? 'تشغيل الكل' : 'Play All',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),

          SizedBox(width: 12),

          // Shuffle button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: IconButton(
              onPressed: _toggleShuffle,
              icon: Icon(
                Icons.shuffle,
                color: _isShuffleEnabled ? Colors.blue[600] : Colors.grey[600],
              ),
              tooltip: context.isArabic ? 'خلط' : 'Shuffle',
            ),
          ),

          SizedBox(width: 8),

          // Repeat button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: IconButton(
              onPressed: _toggleRepeat,
              icon: Icon(
                Icons.repeat,
                color: _isRepeatEnabled ? Colors.blue[600] : Colors.grey[600],
              ),
              tooltip: context.isArabic ? 'تكرار' : 'Repeat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideosList(PlaylistEntity playlist) {
    // Mock videos data for now - replace with actual playlist videos
    final mockVideos = _generateMockVideos(playlist.videosCount);

    if (mockVideos.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.playlist_add,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                context.isArabic
                    ? 'قائمة التشغيل فارغة'
                    : 'This playlist is empty',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                context.isArabic
                    ? 'ابحث عن فيديوهات لإضافتها'
                    : 'Find videos to add to this playlist',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final video = mockVideos[index];
          return _buildVideoItem(video, index, playlist);
        },
        childCount: mockVideos.length,
      ),
    );
  }

  Widget _buildVideoItem(StarEntity video, int index, PlaylistEntity playlist) {
    final isCurrentVideo = index == _currentVideoIndex;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrentVideo ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _playVideoAt(index, video, playlist),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // Video thumbnail
                Stack(
                  children: [
                    ThumbnailWidget(
                      width: 120,
                      height: 68,
                      duration: '7:54',
                      showVolumeIcon: false,
                      showPlayIcon: !isCurrentVideo,
                    ),
                    if (isCurrentVideo)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.equalizer,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(width: 12),

                // Video info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isCurrentVideo
                              ? Colors.blue[600]
                              : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${video.user.firstName} ${video.user.lastName}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "${_formatNumber(video.totalViews)} views • ${_formatTimeAgo(video.createdAt ?? DateTime.now())}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                // More options
                IconButton(
                  onPressed: () => _showVideoOptions(video, index, playlist),
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods
  List<StarEntity> _generateMockVideos(int count) {
    return List.generate(count, (index) {
      return StarEntity(
        id: 'playlist_video_$index',
        title: 'Playlist Video ${index + 1}',
        description: 'Description for video ${index + 1}',
        user: UserStarEntity(
          id: 'user_$index',
          firstName: 'Artist',
          lastName: '${index + 1}',
          email: 'artist$index@example.com',
          image: '',
          viewNumber: (index + 1) * 1000,
          averageRating: 4.0 + (index % 5) * 0.2,
        ),
        mediaUrl: [
          MediaUrlEntity(
            id: 'media_$index',
            mediaKey: 'video_$index.mp4',
            duration: Duration(minutes: 3 + (index % 5), seconds: 30),
            mediaType: 'video/mp4',
          ),
        ],
        totalViews: (index + 1) * 1500,
        averageRating: 4,
        isApproved: true,
        haveStories: false,
        storyCount: 0,
        createdAt: DateTime.now().subtract(Duration(days: index * 7)),
      );
    });
  }

  String _formatNumber(num number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(0)}K";
    }
    return number.toString();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()} months ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} days ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours ago";
    }
    return 'Just now';
  }

  // Action methods
  void _handleMenuAction(String action, PlaylistEntity playlist) {
    switch (action) {
      case 'edit':
        _showEditPlaylistDialog(playlist);
        break;
      case 'delete':
        _showDeleteConfirmation(playlist);
        break;
    }
  }

  void _playAllVideos(PlaylistEntity playlist) {
    ManageVibration.vibrate();
    setState(() {
      _currentVideoIndex = 0;
    });
    // Start playing from first video
    final videos = _generateMockVideos(playlist.videosCount);
    if (videos.isNotEmpty) {
      _playVideoAt(0, videos.first, playlist);
    }
  }

  void _playVideoAt(int index, StarEntity video, PlaylistEntity playlist) {
    ManageVibration.vibrate();
    setState(() {
      _currentVideoIndex = index;
    });

    // Navigate to video player with playlist context
    Navigator.pushNamed(
      context,
      '/video-player',
      arguments: {
        'video': video,
        'mediaUrl':
            video.mediaUrl.isNotEmpty ? video.mediaUrl.first.mediaKey : '',
        'playlist': playlist,
        'currentIndex': index,
        'isShuffleEnabled': _isShuffleEnabled,
        'isRepeatEnabled': _isRepeatEnabled,
      },
    );
  }

  void _toggleShuffle() {
    ManageVibration.vibrate();
    setState(() {
      _isShuffleEnabled = !_isShuffleEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isShuffleEnabled
              ? (context.isArabic ? 'تم تفعيل الخلط' : 'Shuffle enabled')
              : (context.isArabic ? 'تم إيقاف الخلط' : 'Shuffle disabled'),
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _toggleRepeat() {
    ManageVibration.vibrate();
    setState(() {
      _isRepeatEnabled = !_isRepeatEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isRepeatEnabled
              ? (context.isArabic ? 'تم تفعيل التكرار' : 'Repeat enabled')
              : (context.isArabic ? 'تم إيقاف التكرار' : 'Repeat disabled'),
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showVideoOptions(StarEntity video, int index, PlaylistEntity playlist) {
    OptionsBottomSheet.showOptions(
      context: context,
      options: [
        OptionItem(
          icon: Icons.play_arrow,
          title: context.isArabic ? 'تشغيل الآن' : 'Play now',
          onTap: () {
            Navigator.pop(context);
            _playVideoAt(index, video, playlist);
          },
        ),
        OptionItem(
          icon: Icons.playlist_play,
          title: context.isArabic ? 'تشغيل التالي' : 'Play next',
          onTap: () {
            Navigator.pop(context);
            // Implement play next logic
          },
        ),
        OptionItem(
          icon: Icons.share,
          title: context.isArabic ? 'مشاركة' : 'Share',
          onTap: () {
            Navigator.pop(context);
            // Implement share logic
          },
        ),
        if (widget.isCurrentUser)
          OptionItem(
            icon: Icons.remove_circle_outline,
            title:
                context.isArabic ? 'إزالة من القائمة' : 'Remove from playlist',
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              _removeVideoFromPlaylist(video, playlist);
            },
          ),
      ],
    );
  }

  void _removeVideoFromPlaylist(StarEntity video, PlaylistEntity playlist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'إزالة الفيديو' : 'Remove Video',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          context.isArabic
              ? 'هل تريد إزالة هذا الفيديو من قائمة التشغيل؟'
              : 'Remove this video from the playlist?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final success = await _playlistCubit.removeVideoFromPlaylist(
                playlist.id,
                video.id,
              );

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.isArabic
                          ? 'تم إزالة الفيديو من قائمة التشغيل'
                          : 'Video removed from playlist',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadPlaylistDetails(); // Refresh playlist
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(context.isArabic ? 'إزالة' : 'Remove'),
          ),
        ],
      ),
    );
  }

  void _showEditPlaylistDialog(PlaylistEntity playlist) {
    final nameController = TextEditingController(text: playlist.name);
    final descriptionController =
        TextEditingController(text: playlist.description);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          context.isArabic ? 'تعديل قائمة التشغيل' : 'Edit Playlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: context.isArabic ? 'اسم القائمة' : 'Playlist Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: context.isArabic ? 'الوصف' : 'Description',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          BlocConsumer<PlaylistCubit, PlaylistState>(
            listener: (context, state) {
              if (state.isSuccess && !state.isUpdating) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.isArabic
                          ? 'تم تحديث قائمة التشغيل بنجاح'
                          : 'Playlist updated successfully',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadPlaylistDetails();
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.isUpdating
                    ? null
                    : () async {
                        await _playlistCubit.updatePlaylist(
                          playlistId: playlist.id,
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                        );
                      },
                child: state.isUpdating
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.isArabic ? 'حفظ' : 'Save'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(PlaylistEntity playlist) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          context.isArabic ? 'حذف قائمة التشغيل' : 'Delete Playlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          context.isArabic
              ? 'هل أنت متأكد من حذف قائمة التشغيل "${playlist.name}"؟ لا يمكن التراجع عن هذا الإجراء.'
              : 'Are you sure you want to delete playlist "${playlist.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          BlocConsumer<PlaylistCubit, PlaylistState>(
            listener: (context, state) {
              if (state.isSuccess && !state.isDeleting) {
                Navigator.pop(dialogContext); // Close dialog
                Navigator.pop(context); // Close page
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.isArabic
                          ? 'تم حذف قائمة التشغيل بنجاح'
                          : 'Playlist deleted successfully',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.isDeleting
                    ? null
                    : () async {
                        await _playlistCubit.deletePlaylist(playlist.id);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: state.isDeleting
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.isArabic ? 'حذف' : 'Delete'),
              );
            },
          ),
        ],
      ),
    );
  }
}
