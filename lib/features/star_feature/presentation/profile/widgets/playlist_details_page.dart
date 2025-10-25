import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../data/model/tube_video_models.dart';
import '../../presentation_exports.dart';
import 'play_next_queue_manager.dart';

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

  @override
  void initState() {
    super.initState();
    _playlistCubit = context.read<PlaylistCubit>();
    _loadPlaylistDetails();
  }

  void _loadPlaylistDetails() {
    print('🎵 Loading playlist details for: ${widget.playlist.id}');
    // Use the NEW method to get playlist with videos
    _playlistCubit.getPlaylistWithVideos(widget.playlist.id);
  }

  void _onVideoTap(StarEntity video) {
    // Navigate to video player page
    _navigateToVideoPlayer(video);
  }

  void _navigateToVideoPlayer(StarEntity video) {
    final starCubit = context.read<StarCubit>();
    final mediaUrl = _getVideoUrl(video);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<StarCubit>.value(
              value: starCubit,
            ),
            BlocProvider<CommentCubit>(
              create: (context) => serviceLocator<CommentCubit>(),
            ),
          ],
          child: TalentVideoPlayer(
            videoUrl: mediaUrl,
            talent: video,
          ),
        ),
      ),
    );
  }

  String _getVideoUrl(StarEntity video) {
    // Handle TubeVideoModel
    if (video is TubeVideoModel) {
      return video.videoUrl ?? '';
    }
    // Handle StarEntity with mediaUrl
    if (video.mediaUrl.isNotEmpty) {
      return video.mediaUrl.first.mediaKey;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      // backgroundColor: Colors.white,
      body: BlocBuilder<PlaylistCubit, PlaylistState>(
        builder: (context, state) {
          if (state.isLoading && state.selectedPlaylist == null) {
            return Center(
              child: StarLoadingIndicator(),
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
          final realVideos =
              playlist.videos; // These are now REAL videos from API

          print('🎵 Displaying playlist: ${playlist.name}');
          print('📹 Real videos count: ${realVideos.length}');

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
                child: _buildControlButtons(playlist, realVideos),
              ),

              // Videos List
              _buildVideosList(playlist, realVideos),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(PlaylistEntity playlist) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      elevation: 0,
      backgroundColor: AppColors.PRIMARY_COLOR,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          ManageVibration.vibrate();
          Navigator.pop(context);
        },
      ),
      title: Text(
        playlist.name,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        // if (widget.isCurrentUser)
        //   BlocProvider(
        //     create: (context) => serviceLocator<PlaylistCubit>(),
        //     child: PopupMenuButton<String>(
        //       onSelected: (value) => _handleMenuAction(value, playlist),
        //       itemBuilder: (context) => [
        //         PopupMenuItem(
        //           value: 'edit',
        //           child: Row(
        //             children: [
        //               Icon(Icons.edit, size: 20, color: Colors.grey[700]),
        //               SizedBox(width: 12),
        //               Text(context.isArabic ? 'تعديل' : 'Edit'),
        //             ],
        //           ),
        //         ),
        //         PopupMenuItem(
        //           value: 'delete',
        //           child: Row(
        //             children: [
        //               Icon(Icons.delete, size: 20, color: Colors.red),
        //               SizedBox(width: 12),
        //               Text(
        //                 context.isArabic ? 'حذف' : 'Delete',
        //                 style: TextStyle(color: Colors.red),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildPlaylistHeader(PlaylistEntity playlist) {
    // أضف دي عشان تشوف إيه اللي بيحصل
    print('🖼️ Playlist thumbnail URL: "${playlist.thumbnail}"');
    print('🖼️ Thumbnail isEmpty: ${playlist.thumbnail.isEmpty}');

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
                    child: _buildThumbnailImage(playlist),
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

                  // Video count badge - USE REAL COUNT
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
                        playlist.videos.length
                            .toString()
                            .toArabicNumbers(context), // REAL count
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
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),

                Text(
                  context.isArabic
                      ? '${playlist.videos.length.toString().toArabicNumbers(context)} فيديو • ${timeago.format(playlist.createdAt, locale: 'ar').toArabicNumbers(context)}'
                      : '${playlist.videos.length} videos • ${timeago.format(playlist.createdAt, locale: 'en')}',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.isDarkMode ? Colors.white : Colors.grey[600],
                  ),
                ),

                if (playlist.description.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Text(
                    playlist.description,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          context.isDarkMode ? Colors.white : Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                SizedBox(height: 16),

                // Privacy/Visibility indicator
                // Row(
                //   children: [
                //     Icon(
                //       Icons.lock_outline,
                //       size: 16,
                //       color: Colors.grey[600],
                //     ),
                //     SizedBox(width: 4),
                //     Text(
                //       context.isArabic ? 'خاصة' : 'Private',
                //       style: TextStyle(
                //         fontSize: 12,
                //         color: Colors.grey[600],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// أضف الدالة دي لمعالجة الـ thumbnail بشكل أفضل
  Widget _buildThumbnailImage(PlaylistEntity playlist) {
    // لو الـ thumbnail فاضي، استخدم صورة من أول فيديو
    if (playlist.thumbnail.isEmpty || playlist.thumbnail.trim().isEmpty) {
      print('🖼️ Playlist thumbnail is empty, trying first video thumbnail');

      // جرب تجيب thumbnail من أول فيديو
      if (playlist.videos.isNotEmpty) {
        final firstVideo = playlist.videos.first;
        String? videoThumbnail;

        if (firstVideo is TubeVideoModel) {
          videoThumbnail = firstVideo.thumbnail;
        } else if (firstVideo.mediaUrl.isNotEmpty) {
          videoThumbnail = firstVideo.mediaUrl.first.mediaKey;
        }

        if (videoThumbnail != null && videoThumbnail.isNotEmpty) {
          print('🖼️ Using first video thumbnail: $videoThumbnail');
          return Image.network(
            videoThumbnail,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print('🖼️ Error loading video thumbnail: $error');
              return _buildDefaultPlaylistCover();
            },
          );
        }
      }

      // لو مفيش فيديوهات أو مفيش thumbnails، استخدم الdefault
      print('🖼️ No videos or thumbnails found, using default cover');
      return _buildDefaultPlaylistCover();
    }

    // لو الـ thumbnail موجود، جرب تحمله
    print('🖼️ Loading playlist thumbnail: ${playlist.thumbnail}');
    return Image.network(
      playlist.thumbnail,
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('🖼️ Error loading playlist thumbnail: $error');
        print('🖼️ Falling back to first video thumbnail');

        // لو فشل تحميل الـ playlist thumbnail، جرب أول فيديو
        if (playlist.videos.isNotEmpty) {
          final firstVideo = playlist.videos.first;
          String? videoThumbnail;

          if (firstVideo is TubeVideoModel) {
            videoThumbnail = firstVideo.thumbnail;
          } else if (firstVideo.mediaUrl.isNotEmpty) {
            videoThumbnail = firstVideo.mediaUrl.first.mediaKey;
          }

          if (videoThumbnail != null && videoThumbnail.isNotEmpty) {
            return Image.network(
              videoThumbnail,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('🖼️ Video thumbnail also failed, using default');
                return _buildDefaultPlaylistCover();
              },
            );
          }
        }

        return _buildDefaultPlaylistCover();
      },
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

  Widget _buildControlButtons(
      PlaylistEntity playlist, List<StarEntity> videos) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Play All button
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  videos.isNotEmpty ? () => _playAllVideos(playlist) : null,
              icon: Icon(Icons.play_arrow, size: 20),
              label: Text(
                context.isArabic ? 'تشغيل الكل' : 'Play All',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    !videos.isNotEmpty ? Colors.black : Colors.grey,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideosList(
      PlaylistEntity playlist, List<StarEntity> realVideos) {
    if (realVideos.isEmpty) {
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
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadPlaylistDetails,
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                label: Text(
                  context.isArabic ? 'تحديث' : 'Refresh',
                  style: TextStyle(color: Colors.white),
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
          final video = realVideos[index];
          return _buildVideoItem(video, index, playlist);
        },
        childCount: realVideos.length,
      ),
    );
  }

  Widget _buildVideoItem(StarEntity video, int index, PlaylistEntity playlist) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _onVideoTap(video),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // Video thumbnail
                ThumbnailWidget(
                  imageUrl: _getVideoThumbnail(video),
                  width: 120,
                  height: 68,
                  duration: _formatDuration(video),
                  showVolumeIcon: false,
                ),

                SizedBox(width: 12),

                // Video info - REAL DATA
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: context.isDarkMode
                              ? Colors.white
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
                          color: context.isDarkMode
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "${_formatNumber(video.totalViews)} views • ${_formatTimeAgo(video.createdAt ?? DateTime.now())}",
                        style: TextStyle(
                          fontSize: 12,
                          color: context.isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[500],
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
                    color: context.isDarkMode ? Colors.white : Colors.grey[600],
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
  String? _getVideoThumbnail(StarEntity video) {
    if (video is TubeVideoModel) {
      return video.thumbnail;
    }
    if (video.mediaUrl.isNotEmpty) {
      return video.mediaUrl.first.mediaKey;
    }
    return null;
  }

  String _formatDuration(StarEntity video) {
    Duration duration;

    if (video is TubeVideoModel) {
      duration = Duration(seconds: video.duration);
    } else if (video.mediaUrl.isNotEmpty) {
      duration = video.mediaUrl.first.duration ?? Duration.zero;
    } else {
      duration = Duration.zero;
    }

    if (duration == Duration.zero) return '0:00';

    final minutes = duration.inMinutes.remainder(60).toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      return '$hours:${minutes.padLeft(2, '0')}:$seconds';
    }
    return '$minutes:$seconds';
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
    if (playlist.videos.isEmpty) return;

    // Play the first video
    _navigateToVideoPlayer(playlist.videos.first);
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
            _onVideoTap(video);
          },
        ),
        OptionItem(
          icon: Icons.playlist_play,
          title: context.isArabic ? 'تشغيل التالي' : 'Play next',
          onTap: () {
            Navigator.pop(context);
            PlayNextQueueManager().addToPlayNext(video);
            showSuccessMessage(
              context,
              context.isArabic
                  ? 'تمت إضافة الفيديو لقائمة التشغيل التالي'
                  : 'Video added to play next queue',
            );
          },
        ),
        // OptionItem(
        //   icon: Icons.share,
        //   title: context.isArabic ? 'مشاركة' : 'Share',
        //   onTap: () {
        //     Navigator.pop(context);
        //     // Implement share logic
        //   },
        // ),
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
      builder: (context) => BlocProvider(
        create: (context) => serviceLocator<PlaylistCubit>(),
        child: AlertDialog(
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
            BlocConsumer<PlaylistCubit, PlaylistState>(
              listener: (context, state) {
                if (state.isSuccess) {
                  Navigator.pop(context);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       context.isArabic
                  //           ? 'تم إزالة الفيديو من قائمة التشغيل'
                  //           : 'Video removed from playlist',
                  //     ),
                  //     backgroundColor: Colors.green,
                  //   ),
                  // );
                  showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم إزالة الفيديو من قائمة التشغيل'
                        : 'Video removed from playlist',
                  );
                  // Refresh the main playlist
                  _loadPlaylistDetails();
                } else if (state.isError) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       state.failure?.toString() ??
                  //           (context.isArabic
                  //               ? 'فشل في إزالة الفيديو'
                  //               : 'Failed to remove video'),
                  //     ),
                  //     backgroundColor: Colors.red,
                  //   ),
                  // );
                  showErrorMessage(
                      context,
                      state.failure?.toString() ??
                          (context.isArabic
                              ? 'فشل في إزالة الفيديو'
                              : 'Failed to remove video'));
                }
              },
              builder: (context, state) {
                return TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          await context
                              .read<PlaylistCubit>()
                              .removeVideoFromPlaylist(
                                playlist.id,
                                video.id,
                              );
                        },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: state.isLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        )
                      : Text(context.isArabic ? 'إزالة' : 'Remove'),
                );
              },
            ),
          ],
        ),
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
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text(
                //       context.isArabic
                //           ? 'تم تحديث قائمة التشغيل بنجاح'
                //           : 'Playlist updated successfully',
                //     ),
                //     backgroundColor: Colors.green,
                //   ),
                // );
                showSuccessMessage(
                  context,
                  context.isArabic
                      ? 'تم تحديث قائمة التشغيل بنجاح'
                      : 'Playlist updated successfully',
                );
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
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text(
                //       context.isArabic
                //           ? 'تم حذف قائمة التشغيل بنجاح'
                //           : 'Playlist deleted successfully',
                //     ),
                //     backgroundColor: Colors.red,
                //   ),
                // );
                showSuccessMessage(
                  context,
                  context.isArabic
                      ? 'تم حذف قائمة التشغيل بنجاح'
                      : 'Playlist deleted successfully',
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

  @override
  void dispose() {
    // Don't dispose the playback manager as it's per playlist and may be used elsewhere
    super.dispose();
  }
}
