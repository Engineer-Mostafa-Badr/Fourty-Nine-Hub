// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class ImagesPageViewParams {
  final MessageEntity messageEntity;
  final int index;
  ImagesPageViewParams({required this.messageEntity, required this.index});
}

class ImagesPageView extends StatefulWidget {
  const ImagesPageView({super.key, required this.params});
  final ImagesPageViewParams params;

  @override
  State<ImagesPageView> createState() => _ImagesPageViewState();
}

class _ImagesPageViewState extends State<ImagesPageView> {
  int _selectedIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    _selectedIndex = widget.params.index;
    _pageController = PageController(initialPage: _selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 26,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Positioned.fill(
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.params.messageEntity.media.length,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return widget.params.messageEntity.media[_selectedIndex].type ==
                    FileTypeEnum.video
                ? CustomVideoPlayerCard(
                    videoUrl:
                        widget.params.messageEntity.media[_selectedIndex].url,
                  )
                : CachedNetworkImage(
                    imageUrl:
                        widget.params.messageEntity.media[_selectedIndex].url,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => const SizedBox(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
          },
        ),
      ),
    );
  }
}

class CustomVideoPlayerCard extends StatefulWidget {
  const CustomVideoPlayerCard({
    super.key,
    required this.videoUrl,
  });
  final String videoUrl;

  @override
  State<CustomVideoPlayerCard> createState() => _CustomVideoPlayerCardState();
}

class _CustomVideoPlayerCardState extends State<CustomVideoPlayerCard> {
  late VideoPlayerController _controller;
  bool _showControls = true; // Control the visibility of the play/pause icons
  Timer? _hideControlTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });

    // Listen for video completion and pause when finished
    _controller.addListener(() {
      setState(() {});

      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          _controller.pause(); // Pause when video is completed
          _showControls = true; // Show controls when the video completes
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideControlTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showControls = true; // Always show controls when paused
      } else {
        _controller.play();
        _showControls = true; // Show controls when playing starts
        _hideControlAfterDelay(); // Hide after delay
      }
    });
  }

  void _hideControlAfterDelay() {
    _hideControlTimer?.cancel(); // Cancel any existing timer
    _hideControlTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showControls = false; // Hide controls after 2 seconds
      });
    });
  }

  void _onSliderChanged(double value) {
    final position = Duration(milliseconds: value.toInt());
    _controller.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? GestureDetector(
              onTap: () {
                _togglePlayPause();
              },
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),

                    // Show dark background when paused
                    if (!_controller.value.isPlaying)
                      Container(
                        color: Colors.black
                            .withOpacity(0.5), // Dark background with opacity
                      ),

                    // Show play/pause icons when _showControls is true
                    if (_showControls)
                      IconButton(
                        iconSize: 64,
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.white,
                        ),
                        onPressed: _togglePlayPause,
                      ),

                    // Video progress slider
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Slider(
                            value: _controller.value.position.inMilliseconds
                                .toDouble(),
                            min: 0.0,
                            activeColor: AppColors.PRIMARY_COLOR_DARK,
                            thumbColor: AppColors.PRIMARY_COLOR_DARK,
                            max: _controller.value.duration.inMilliseconds
                                .toDouble(),
                            onChanged: (value) {
                              _onSliderChanged(value);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_controller.value.position),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                _formatDuration(_controller.value.duration),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
