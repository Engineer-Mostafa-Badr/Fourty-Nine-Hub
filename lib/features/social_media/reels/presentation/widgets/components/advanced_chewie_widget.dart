import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'custom_progress_bar.dart';

class AdvancedChewieWithProgressBar extends StatefulWidget {
  final String videoUrl;

  const AdvancedChewieWithProgressBar({super.key, required this.videoUrl});

  @override
  _AdvancedChewieWithProgressBarState createState() =>
      _AdvancedChewieWithProgressBarState();
}

class _AdvancedChewieWithProgressBarState
    extends State<AdvancedChewieWithProgressBar> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      looping: true,
      showControls: false,
      // Hide default Chewie controls
      allowFullScreen: false,
      aspectRatio: 2 / 4,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Chewie(
          key: PageStorageKey(widget.videoUrl),
          controller: _chewieController,
        ),
        // Advanced Custom Progress Bar
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: CustomProgressBar(
            videoPlayerController: _videoPlayerController,
          ),
        ),
      ],
    );
  }
}
