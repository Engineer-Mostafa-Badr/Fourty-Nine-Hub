import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import 'chewie_controls.dart';

class VideoWidget extends StatefulWidget {
  final String url;

  const VideoWidget({super.key, required this.url});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVisible = false; // Track visibility state

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {}); // Ensure the first frame is shown after initialization
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.url), // Unique key for each video widget
      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;

        // Play video when more than 50% is visible
        if (visiblePercentage > 50 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
          videoPlayerController.play();
        } else if (visiblePercentage <= 50 && _isVisible) {
          setState(() {
            _isVisible = false;
          });
          videoPlayerController.pause();
        }
      },
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              height: double.infinity,
              color: Colors.black,
              child: Stack(
                children: [
                  Chewie(
                    key: PageStorageKey(widget.url),
                    controller: ChewieController(
                      videoPlayerController: videoPlayerController,
                      autoInitialize: true,
                      looping: true,
                      showOptions: false,
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
                      customControls: CustomChewieControls(
                        chewieController: ChewieController(
                          videoPlayerController: videoPlayerController,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CustomCircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
