import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerControls extends StatefulWidget {
  final VideoPlayerController controller;
  final bool showControls;
  final VoidCallback? onTogglePlayPause;
  final VoidCallback? onToggleMute;
  final VoidCallback? onToggleFullscreen;
  final Function(double)? onSeek;
  final bool isPlaying;
  final bool isMuted;
  final bool isFullscreen;
  final bool isDragging;
  final Function(bool)? onDraggingChanged;

  const VideoPlayerControls({
    super.key,
    required this.controller,
    required this.showControls,
    this.onTogglePlayPause,
    this.onToggleMute,
    this.onToggleFullscreen,
    this.onSeek,
    required this.isPlaying,
    required this.isMuted,
    required this.isFullscreen,
    required this.isDragging,
    this.onDraggingChanged,
  });

  @override
  State<VideoPlayerControls> createState() => _VideoPlayerControlsState();
}

class _VideoPlayerControlsState extends State<VideoPlayerControls> {
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _resetHideTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _resetHideTimer() {
    _hideControlsTimer?.cancel();
    if (widget.showControls && widget.isPlaying) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        // You might need to pass this back to parent widget
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return "$hours:${twoDigits(minutes)}:${twoDigits(seconds)}";
    } else {
      return "${minutes}:${twoDigits(seconds)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showControls) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: widget.showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Top controls (back button, title, etc.)
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  if (!widget.isFullscreen)
                    IconButton(
                      icon: Icon(
                        widget.isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                      ),
                      onPressed: widget.onToggleMute,
                    ),
                  IconButton(
                    icon: Icon(
                      widget.isFullscreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      color: Colors.white,
                    ),
                    onPressed: widget.onToggleFullscreen,
                  ),
                ],
              ),
            ),

            // Center play button
            if (!widget.isPlaying)
              Center(
                child: GestureDetector(
                  onTap: widget.onTogglePlayPause,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),

            // Bottom controls
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  // Progress bar
                  Row(
                    children: [
                      ValueListenableBuilder<VideoPlayerValue>(
                        valueListenable: widget.controller,
                        builder: (context, value, child) {
                          return Text(
                            _formatDuration(value.position),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onPanStart: (details) {
                            widget.onDraggingChanged?.call(true);
                          },
                          onPanUpdate: (details) {
                            final RenderBox box = context.findRenderObject() as RenderBox;
                            final localPosition = box.globalToLocal(details.globalPosition);
                            final progress = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
                            final duration = widget.controller.value.duration;
                            final newPosition = duration * progress;
                            widget.onSeek?.call(newPosition.inMilliseconds.toDouble());
                          },
                          onPanEnd: (details) {
                            widget.onDraggingChanged?.call(false);
                          },
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                // Progress Bar Background
                                Container(
                                  height: 4,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                // Progress Bar Fill
                                ValueListenableBuilder<VideoPlayerValue>(
                                  valueListenable: widget.controller,
                                  builder: (context, value, child) {
                                    final progress = value.duration.inMilliseconds > 0
                                        ? value.position.inMilliseconds / value.duration.inMilliseconds
                                        : 0.0;
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: 4,
                                        width: MediaQuery.of(context).size.width * progress.clamp(0.0, 1.0),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Progress Indicator Circle
                                ValueListenableBuilder<VideoPlayerValue>(
                                  valueListenable: widget.controller,
                                  builder: (context, value, child) {
                                    final progress = value.duration.inMilliseconds > 0
                                        ? value.position.inMilliseconds / value.duration.inMilliseconds
                                        : 0.0;
                                    return Positioned(
                                      left: (MediaQuery.of(context).size.width - 32) * progress.clamp(0.0, 1.0) - 6,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<VideoPlayerValue>(
                        valueListenable: widget.controller,
                        builder: (context, value, child) {
                          return Text(
                            _formatDuration(value.duration),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white),
                        onPressed: () {
                          // Handle previous video
                        },
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: Icon(
                          widget.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: widget.onTogglePlayPause,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white),
                        onPressed: () {
                          // Handle next video
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}