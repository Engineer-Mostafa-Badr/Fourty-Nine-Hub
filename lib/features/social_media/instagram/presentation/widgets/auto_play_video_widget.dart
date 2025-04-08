import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/header_post_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_view_body.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ويدجيت لعرض الفيديو مع مراقبة الظهور وأزرار التحكم
class AutoplayVideoWidget extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  final bool showControls;
  final bool isReel;
  final InstagramPostEntity? instagramPostEntity;

  const AutoplayVideoWidget({
    super.key,
    required this.videoUrl,
    required this.videoId,
    required this.isReel,
    this.showControls = true,
    this.instagramPostEntity,
  });

  @override
  State<AutoplayVideoWidget> createState() => _AutoplayVideoWidgetState();
}

class _AutoplayVideoWidgetState extends State<AutoplayVideoWidget> {
  late VideoPlayerController _controller;
  final VideoControllerManager _manager = VideoControllerManager();
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _manager.registerController(widget.videoId, _controller);

    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });

    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _manager.unregisterController(widget.videoId);
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      _manager.setPausedManually(widget.videoId, true);
    } else {
      _controller.play();
      _manager.setPausedManually(widget.videoId, false);
    }
    setState(() {
      _isPlaying = _controller.value.isPlaying;
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1.0);
    });
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });

    // إخفاء أزرار التحكم بعد 3 ثوانٍ
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video-${widget.videoId}'),
      onVisibilityChanged: (visibilityInfo) {
        _manager.updateVisibility(
            widget.videoId, visibilityInfo.visibleFraction);
      },
      child: GestureDetector(
        onTap: () {
          if (widget.showControls) {
            _showControlsTemporarily();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 438,
              width: double.infinity,
              color: Colors.grey,
              child: _isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
            ),

            // عرض أزرار التحكم عند النقر
            if (widget.showControls && (_showControls || !_isInitialized))
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  height: 400,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // زر التشغيل/الإيقاف
                      IconButton(
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_filled_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                        onPressed: _isInitialized ? _togglePlay : null,
                      ),
                      // const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),

            // زر كتم الصوت
            if (_isInitialized)
              Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  icon: Icon(
                    _isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: _isInitialized ? _toggleMute : null,
                ),
              ),

            // مؤشر التقدم في أسفل الفيديو
            if (_isInitialized)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: widget.showControls,
                  colors: const VideoProgressColors(
                    playedColor: AppColors.SECONDARY_COLOR_DARK2,
                    bufferedColor: Colors.white70,
                    backgroundColor: Colors.grey,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                ),
              ),
            if (widget.isReel)
              Positioned(
                top: 20,
                right: 0,
                left: 0,
                child: HeaderPostInstagram(
                  imageUrl:
                      widget.instagramPostEntity?.profilePictureUrl ?? '****',
                  userName: widget.instagramPostEntity?.username ?? '****',
                  userTags: widget.instagramPostEntity?.userTags ?? [],
                  isReel: widget.isReel,
                  country: widget.instagramPostEntity?.locationName ?? '****',
                  userId: widget.instagramPostEntity!.userId,
                  // songName: songName,
                  // numberUserNamesMenchan: numberUserNamesMenchan,
                  // userNameMenchan: userNameMenchan,
                  // userImageMenchan: userImageMenchan,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
