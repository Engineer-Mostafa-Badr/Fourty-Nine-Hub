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

  @override
  void initState() {
    super.initState();
    if (widget.banner.videoUrl != null) {
      _controller = VideoPlayerController.network(widget.banner.videoUrl!)
        ..setLooping(true)
        ..setVolume(0.0)
        ..initialize().then((_) {
          if (mounted) setState(() {});
          _controller!.play();
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildContent() {
    final image = widget.banner.imageUrl != null
        ? Image.network(widget.banner.imageUrl!, fit: BoxFit.cover)
        : null;

    final video = (_controller != null && _controller!.value.isInitialized)
        ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          )
        : null;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (image != null) image,
        if (video != null) video,
        Container(color: Colors.black.withOpacity(0.3)),
        if (_controller != null && !_controller!.value.isInitialized)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      // Only image
      return _buildContent();
    }

    return VisibilityDetector(
      key: widget.key!,
      onVisibilityChanged: (info) {
        final visible = info.visibleFraction > 0.5;
        if (visible) {
          _controller?.play();
        } else {
          _controller?.pause();
        }
      },
      child: _buildContent(),
    );
  }
}

List<BannerAdsModel> bannersList = [
  BannerAdsModel(imageUrl: 'https://i.imgur.com/QCNbOAo.png'),
  BannerAdsModel(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
  BannerAdsModel(
    imageUrl: 'https://i.imgur.com/QCNbOAo.png',
    videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ),
];
