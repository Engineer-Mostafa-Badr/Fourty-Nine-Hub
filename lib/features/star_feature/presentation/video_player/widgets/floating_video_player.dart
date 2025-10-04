import 'package:flutter/material.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/main.dart';
import 'package:video_player/video_player.dart';

// Keep the existing FloatingVideoManager classes as they are
class FloatingVideoManager {
  static OverlayEntry? _overlayEntry;

  static void showFloatingPlayer({
    required BuildContext context,
    required String videoUrl,
    required String title,
    required VideoPlayerController controller,
    required bool isPlaying,
  }) {
    closeFloatingPlayer();

    _overlayEntry = OverlayEntry(
      builder: (context) => FloatingVideoPlayer(
        controller: controller,
        title: title,
        videoUrl: videoUrl,
        isPlaying: isPlaying,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void closeFloatingPlayer() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
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
      MediaQuery.of(navigatorKey.currentContext!).size.width -
          _floatingSize.width -
          4,
      MediaQuery.of(navigatorKey.currentContext!).size.height -
          _floatingSize.height -
          4,
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.play() : _controller.pause();
    });
  }

  Size get _floatingSize {
    var width = MediaQuery.of(navigatorKey.currentContext!).size.width;
    final baseWidth = _showControls ? width * .9 : width * .6;

    if (!_controller.value.isInitialized) {
      return Size(baseWidth, baseWidth * 16 / 9);
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
              _position = Offset(
                _position.dx + details.delta.dx,
                _position.dy + details.delta.dy,
              );
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
          onTap: () => setState(() => _showControls = !_showControls),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _floatingSize.width,
            height: _floatingSize.height,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  if (_controller.value.isInitialized)
                    Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  else
                    const Center(child: CircularProgressIndicator()),
                  if (_showControls)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white, size: 20),
                              onPressed:
                                  FloatingVideoManager.closeFloatingPlayer,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_showControls)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                            IconButton(
                              icon: const Icon(Icons.open_in_full,
                                  color: Colors.white, size: 20),
                              onPressed: () {
                                ManageVibration.vibrate();
                                FloatingVideoManager.closeFloatingPlayer();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!_showControls)
                    Center(
                      child: IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _togglePlayPause,
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
}
