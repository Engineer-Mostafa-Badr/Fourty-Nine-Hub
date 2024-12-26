import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomChewieControls extends StatefulWidget {
  final ChewieController chewieController;

  const CustomChewieControls({
    super.key,
    required this.chewieController,
  });

  @override
  State<CustomChewieControls> createState() => _CustomChewieControlsState();
}

class _CustomChewieControlsState extends State<CustomChewieControls> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: VideoProgressIndicator(
            widget.chewieController.videoPlayerController,
            allowScrubbing: true,
            padding: EdgeInsets.zero,
            colors: const VideoProgressColors(
              playedColor: Colors.black54,
              // backgroundColor: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }
}
