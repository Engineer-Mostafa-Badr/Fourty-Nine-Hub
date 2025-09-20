import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/comment_cubit/comment_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/star_cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/helper/youtube_style_video_player.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'playlist_playback_manager.dart';

class PlaylistVideoPlayerPage extends StatefulWidget {
  final PlaylistEntity playlist;
  final StarEntity initialVideo;
  final PlaylistPlaybackManager playbackManager;

  const PlaylistVideoPlayerPage({
    super.key,
    required this.playlist,
    required this.initialVideo,
    required this.playbackManager,
  });

  @override
  State<PlaylistVideoPlayerPage> createState() =>
      _PlaylistVideoPlayerPageState();
}

class _PlaylistVideoPlayerPageState extends State<PlaylistVideoPlayerPage> {
  late StarEntity currentVideo;
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentVideo = widget.initialVideo;

    // Find the index of the initial video
    _currentIndex = widget.playlist.videos.indexWhere(
      (video) => video.id == widget.initialVideo.id,
    );
    if (_currentIndex == -1) _currentIndex = 0;

    _pageController = PageController(initialPage: _currentIndex);

    // Update playback manager
    widget.playbackManager.playVideo(widget.initialVideo.id);

    // Listen to playback manager changes
    widget.playbackManager.addListener(_onPlaybackChanged);
  }

  @override
  void dispose() {
    widget.playbackManager.removeListener(_onPlaybackChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPlaybackChanged() {
    if (widget.playbackManager.currentVideo != null) {
      final newVideo = widget.playbackManager.currentVideo!;
      final newIndex = widget.playlist.videos.indexWhere(
        (video) => video.id == newVideo.id,
      );

      if (newIndex != -1 && newIndex != _currentIndex) {
        setState(() {
          currentVideo = newVideo;
          _currentIndex = newIndex;
        });

        // Animate to the new video page
        _pageController.animateToPage(
          newIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _onVideoComplete() {
    // Auto-play next video
    widget.playbackManager.playNext();
  }

  void _onPageChanged(int index) {
    if (index != _currentIndex) {
      final video = widget.playlist.videos[index];
      widget.playbackManager.playVideo(video.id);
    }
  }

  String _getVideoUrl(StarEntity video) {
    if (video.mediaUrl.isNotEmpty) {
      return video.mediaUrl.first.mediaKey;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.playlist.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              context.isArabic
                  ? '${_currentIndex + 1} من ${widget.playlist.videos.length}'
                  : '${_currentIndex + 1} of ${widget.playlist.videos.length}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: widget.playbackManager,
            builder: (context, child) {
              return PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                color: Colors.grey[900],
                onSelected: (value) {
                  switch (value) {
                    case 'shuffle':
                      widget.playbackManager.togglePlaybackMode();
                      break;
                    case 'playlist':
                      _showPlaylistDialog();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'shuffle',
                    child: Row(
                      children: [
                        Icon(
                          widget.playbackManager.playbackMode ==
                                  PlaybackMode.shuffle
                              ? Icons.shuffle
                              : Icons.repeat,
                          color: widget.playbackManager.playbackMode ==
                                  PlaybackMode.shuffle
                              ? Colors.blue
                              : Colors.white,
                        ),
                        SizedBox(width: 12),
                        Text(
                          widget.playbackManager.playbackMode ==
                                  PlaybackMode.shuffle
                              ? (context.isArabic
                                  ? 'تشغيل متسلسل'
                                  : 'Sequential')
                              : (context.isArabic ? 'تشغيل عشوائي' : 'Shuffle'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'playlist',
                    child: Row(
                      children: [
                        Icon(Icons.playlist_play, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          context.isArabic ? 'قائمة التشغيل' : 'Playlist',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Player
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.playlist.videos.length,
              itemBuilder: (context, index) {
                final video = widget.playlist.videos[index];

                // If video is not approved, show placeholder
                if (!video.isApproved) {
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.videocam_off,
                              size: 64,
                              color: Colors.orange[700],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.isArabic
                                  ? 'تم رفع الفيديو بنجاح!\n\nملاحظة: الفيديو غير متاح حالياً. البث المباشر أو ملف الفيديو غير جاهز بعد. يحتاج وقت ليصبح متاحاً للمستخدمين.'
                                  : 'Video uploaded successfully!\n\nNote: Video is not currently available. The live stream or video file are not yet ready. It takes time before it becomes available to users.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: 20,
                                    color: Colors.orange[700],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.isArabic
                                        ? 'يتم المعالجة...'
                                        : 'Processing...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return TalentVideoPlayer(
                  key: ValueKey(video.id),
                  videoUrl: _getVideoUrl(video),
                  talent: video,
                  onDurationLoaded: (duration) {
                    // Handle duration if needed
                  },
                );
              },
            ),
          ),

          // Playback Controls
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.black87,
            child: AnimatedBuilder(
              animation: widget.playbackManager,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Previous
                    IconButton(
                      onPressed: widget.playbackManager.hasPrevious()
                          ? () => widget.playbackManager.playPrevious()
                          : null,
                      icon: Icon(
                        Icons.skip_previous,
                        color: widget.playbackManager.hasPrevious()
                            ? Colors.white
                            : Colors.grey,
                        size: 32,
                      ),
                    ),

                    // Play mode indicator
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.playbackManager.playbackMode ==
                                PlaybackMode.shuffle
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: widget.playbackManager.playbackMode ==
                                  PlaybackMode.shuffle
                              ? Colors.orange
                              : Colors.blue,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.playbackManager.playbackMode ==
                                    PlaybackMode.shuffle
                                ? Icons.shuffle
                                : Icons.repeat,
                            color: widget.playbackManager.playbackMode ==
                                    PlaybackMode.shuffle
                                ? Colors.orange
                                : Colors.blue,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            widget.playbackManager.playbackMode ==
                                    PlaybackMode.shuffle
                                ? (context.isArabic ? 'عشوائي' : 'SHUFFLE')
                                : (context.isArabic ? 'متسلسل' : 'SEQUENTIAL'),
                            style: TextStyle(
                              color: widget.playbackManager.playbackMode ==
                                      PlaybackMode.shuffle
                                  ? Colors.orange
                                  : Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Next
                    IconButton(
                      onPressed: widget.playbackManager.hasNext()
                          ? () => widget.playbackManager.playNext()
                          : null,
                      icon: Icon(
                        Icons.skip_next,
                        color: widget.playbackManager.hasNext()
                            ? Colors.white
                            : Colors.grey,
                        size: 32,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPlaylistDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.playlist.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.playlist.videos.length,
                  itemBuilder: (context, index) {
                    final video = widget.playlist.videos[index];
                    final isCurrentVideo = video.id == currentVideo.id;

                    return ListTile(
                      leading: Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[800],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                _getVideoUrl(video),
                                width: 60,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[800],
                                    child: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (isCurrentVideo)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      title: Text(
                        video.title,
                        style: TextStyle(
                          color: isCurrentVideo ? Colors.blue : Colors.white,
                          fontWeight: isCurrentVideo
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "${video.user.firstName} ${video.user.lastName}",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: isCurrentVideo
                          ? Icon(Icons.volume_up, color: Colors.blue)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        widget.playbackManager.playVideo(video.id);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
