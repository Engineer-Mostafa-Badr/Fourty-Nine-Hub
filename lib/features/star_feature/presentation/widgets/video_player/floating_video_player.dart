import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../../main.dart';

class FloatingVideoPlayerService {
  static OverlayEntry? _overlayEntry;

  static void show({
    required VideoPlayerController controller,
    required String title,
    required String videoUrl,
    required bool isPlaying,
  }) {
    hide(); // Remove existing overlay if any

    _overlayEntry = OverlayEntry(
      builder: (context) => FloatingVideoPlayer(
        controller: controller,
        title: title,
        videoUrl: videoUrl,
        isPlaying: isPlaying,
      ),
    );

    Overlay.of(navigatorKey.currentContext!)?.insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static bool get isPlayerVisible => _overlayEntry != null;
}

class FloatingVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final String title;
  final String videoUrl;
  final bool isPlaying;

  const FloatingVideoPlayer({
    super.key,
    required this.controller,
    required this.title,
    required this.videoUrl,
    required this.isPlaying,
  });

  @override
  State<FloatingVideoPlayer> createState() => _FloatingVideoPlayerState();
}

class _FloatingVideoPlayerState extends State<FloatingVideoPlayer> {
  late bool _isPlaying;
  late VideoPlayerController _controller;
  late Offset _position;

  bool _showControls = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _isPlaying = widget.isPlaying;
    if (_isPlaying) {
      _controller.play();
    }
    _position = Offset(
      MediaQuery.of(context).size.width - _floatingSize.width - 16,
      MediaQuery.of(context).size.height - _floatingSize.height - 100,
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.play() : _controller.pause();
    });
  }

  void _expandPlayer() {
    // Close floating player and navigate to full screen
    FloatingVideoPlayerService.hide();
    // You can add navigation logic here to open full video player
  }

  void _closePlayer() {
    _controller.pause();
    FloatingVideoPlayerService.hide();
  }

  Size get _floatingSize {
    final screenWidth = MediaQuery.of(navigatorKey.currentContext!).size.width;
    final baseWidth = _showControls ? screenWidth * 0.9 : screenWidth * 0.6;

    if (!_controller.value.isInitialized) {
      return Size(baseWidth, baseWidth * 9 / 16);
    }

    final videoWidth = _controller.value.size.width;
    final videoHeight = _controller.value.size.height;

    if (videoWidth > videoHeight) {
      return Size(baseWidth, baseWidth * videoHeight / videoWidth);
    } else {
      return Size(baseWidth * videoWidth / videoHeight, baseWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              _isDragging = true;
              _showControls = true;
            });
          },
          onPanUpdate: (details) {
            setState(() {
              final newX = _position.dx + details.delta.dx;
              final newY = _position.dy + details.delta.dy;

              // Keep within screen bounds
              final screenSize = MediaQuery.of(context).size;
              final clampedX = newX.clamp(0.0, screenSize.width - _floatingSize.width);
              final clampedY = newY.clamp(0.0, screenSize.height - _floatingSize.height);

              _position = Offset(clampedX, clampedY);
            });
          },
          onPanEnd: (details) {
            setState(() => _isDragging = false);
            Future.delayed(const Duration(seconds: 2), () {
              if (!_isDragging && mounted) {
                setState(() => _showControls = false);
              }
            });
          },
          onTap: () {
            setState(() => _showControls = !_showControls);
            if (_showControls) {
              Future.delayed(const Duration(seconds: 3), () {
                if (!_isDragging && mounted) {
                  setState(() => _showControls = false);
                }
              });
            }
          },
          child: Container(
            width: _floatingSize.width,
            height: _floatingSize.height,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Video player
                  if (_controller.value.isInitialized)
                    Positioned.fill(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),

                  // Loading indicator
                  if (!_controller.value.isInitialized)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),

                  // Controls overlay
                  if (_showControls)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Top controls
                          Positioned(
                            top: 8,
                            left: 8,
                            right: 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Video title (truncated)
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Close button
                                GestureDetector(
                                  onTap: _closePlayer,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Center play/pause button
                          Center(
                            child: GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          // Bottom controls
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Row(
                              children: [
                                // Progress bar
                                Expanded(
                                  child: ValueListenableBuilder<VideoPlayerValue>(
                                    valueListenable: _controller,
                                    builder: (context, value, child) {
                                      final progress = value.duration.inMilliseconds > 0
                                          ? value.position.inMilliseconds / value.duration.inMilliseconds
                                          : 0.0;
                                      return LinearProgressIndicator(
                                        value: progress,
                                        backgroundColor: Colors.white.withOpacity(0.3),
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                                        minHeight: 2,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Expand button
                                GestureDetector(
                                  onTap: _expandPlayer,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.fullscreen,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Drag indicator (when dragging)
                  if (_isDragging)
                    Positioned(
                      top: 4,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 30,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}