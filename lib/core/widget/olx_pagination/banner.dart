import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BannerAdsModel {
  final String? imageUrl;
  final String? videoUrl;

  BannerAdsModel({this.imageUrl, this.videoUrl});
}

class BannerAdsWidget extends StatefulWidget {
  final BannerAdsModel banner;

  const BannerAdsWidget({super.key, required this.banner});

  @override
  State<BannerAdsWidget> createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  VideoPlayerController? _controller;
  bool _isInitializing = false;
  bool _isDisposed = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Don't initialize immediately, wait for visibility
  }

  Future<void> _initializeVideo() async {
    if (_isInitializing || _isDisposed || _controller != null) return;
    if (widget.banner.videoUrl == null) return;

    setState(() {
      _isInitializing = true;
    });

    try {
      _controller = VideoPlayerController.network(widget.banner.videoUrl!);
      await _controller!.initialize();

      if (mounted && !_isDisposed) {
        _controller!.setLooping(true);
        _controller!.setVolume(0.0);
        setState(() {
          _isInitializing = false;
        });

        // Play if still visible
        if (_isVisible) {
          _controller!.play();
        }
      }
    } catch (e) {
      print('Banner video initialization error: $e');
      if (mounted && !_isDisposed) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _disposeVideo() async {
    if (_controller != null) {
      await _controller!.pause();
      await _controller!.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _disposeVideo();
    super.dispose();
  }

  Widget _buildContent() {
    // Image fallback
    final image = widget.banner.imageUrl != null
        ? Image.network(
            widget.banner.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported,
                    size: 48, color: Colors.grey[600]),
              );
            },
          )
        : Container(
            color: Colors.grey[300],
            child: Icon(Icons.image, size: 48, color: Colors.grey[600]),
          );

    // Video widget (only if initialized)
    final video = (_controller != null && _controller!.value.isInitialized)
        ? Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          )
        : null;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Always show image as background
        image,

        // Show video on top if available
        if (video != null) video,

        // Overlay
        Container(color: Colors.black.withOpacity(0.3)),

        // Loading indicator for video
        if (_isInitializing)
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // If no video URL, just show content
    if (widget.banner.videoUrl == null) {
      return _buildContent();
    }

    return VisibilityDetector(
      key: Key(
          'banner-${widget.banner.videoUrl ?? widget.banner.imageUrl ?? UniqueKey().toString()}'),
      onVisibilityChanged: (info) {
        final wasVisible = _isVisible;
        _isVisible = info.visibleFraction > 0.5;

        if (_isVisible && !wasVisible) {
          // Became visible
          if (_controller == null && !_isInitializing) {
            _initializeVideo();
          } else if (_controller != null && !_controller!.value.isPlaying) {
            _controller!.play();
          }
        } else if (!_isVisible && wasVisible) {
          // Became invisible
          if (_controller != null && _controller!.value.isPlaying) {
            _controller!.pause();
          }

          // Dispose if completely out of view
          if (info.visibleFraction == 0) {
            _disposeVideo();
          }
        }
      },
      child: _buildContent(),
    );
  }
}

// Updated banner list with proper URLs
List<BannerAdsModel> bannersList = [
  BannerAdsModel(imageUrl: 'https://i.imgur.com/QCNbOAo.png'),
  BannerAdsModel(
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ),
  BannerAdsModel(
    imageUrl: 'https://i.imgur.com/QCNbOAo.png',
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ),
];
