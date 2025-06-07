import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../main.dart';
import '../../../res/style/app_colors.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer(
      {super.key,
      required this.videoUrl,
      this.onDurationLoaded,
      required this.title});

  final String videoUrl;
  final String title;
  final Function(Duration)? onDurationLoaded;

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  // Floating player state
  bool _isFloating = false;
  Offset _floatingPosition = const Offset(100, 100);
  bool _isPlaying = true;
  bool _showFloatingControls = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        widget.onDurationLoaded?.call(_controller.value.duration);
        _controller.play();
      });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    // Only dispose controller if it's not being used by floating player
    if (!FloatingVideoManager.isPlayerVisible) {
      _controller.dispose();
    }
    // _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  String formatDuration(Duration duration) {
    if (duration == Duration.zero) return '00:00';

    final minutes = duration.inMinutes.remainder(60).toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      return '$hours:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }

  void _toggleFullScreen(String title) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      showDialog(
        context: context,
        builder: (context) => _buildFullScreenVideo(),
      ).then((value) {
        _toggleFullScreen('_toggleFullScreen');
      });
      print(
          '_toggleFullScreen ${MediaQuery.of(context).orientation} from $title');
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      print(
          '_toggleFullScreen ${MediaQuery.of(context).orientation} from $title');
      // context.pop();
    }
  }

  void _toggleFloatingMode() {
    setState(() {
      _isFloating = !_isFloating;
      if (_isFloating) {
        // Save current position when entering floating mode
        _floatingPosition = Offset(
          MediaQuery.of(context).size.width - 320,
          MediaQuery.of(context).size.height * 0.3,
        );
      }
    });
  }

  Widget _buildFullScreenVideo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
        ),
        SizedBox(
          height: double.infinity,
          // width: double.infinity,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        Positioned.fill(child: _buildVideoControls(isFullScreen: true)),
      ],
    );
  }

  Widget _buildVideoPlayer({bool isFloating = false}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.black,
        ),
        SizedBox(
          height: 200,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        if (!isFloating || _showFloatingControls)
          Positioned.fill(child: _buildVideoControls(isFloating: isFloating)),
      ],
    );
  }

  Widget _buildVideoControls({
    bool isFullScreen = false,
    bool isFloating = false,
  }) {
    // Add state variables for seeking
    bool isSeeking = false;
    double seekPosition = 0.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        /*       // Background progress track
        Positioned(
          bottom: 4,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            color: Colors.grey[300],
          ),
        ),

        // Progress indicator
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (!value.isInitialized || value.duration == Duration.zero) {
                return const SizedBox();
              }

              final progressFraction =
                  value.position.inMilliseconds / value.duration.inMilliseconds;
              final safeFraction = progressFraction.clamp(0.0, 1.0);
              final screenWidth = MediaQuery.of(context).size.width;

              return SizedBox(
                height: 10,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 4,
                      child: Container(
                        height: 2,
                        width: screenWidth * safeFraction,
                        color: AppColors.SECONDARY_COLOR,
                      ),
                    ),
                    Positioned(
                      left: screenWidth * safeFraction - 5,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),*/

        // Progress indicator with interactive slider
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (!value.isInitialized || value.duration == Duration.zero) {
                return const SizedBox();
              }

              final progressFraction = isSeeking
                  ? seekPosition
                  : value.position.inMilliseconds /
                      value.duration.inMilliseconds;
              final safeFraction = progressFraction.clamp(0.0, 1.0);

              return GestureDetector(
                onTapDown: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final x = details.localPosition.dx;
                  final newPosition = (x / box.size.width).clamp(0.0, 1.0);
                  _controller.seekTo(value.duration * newPosition);
                },
                onHorizontalDragStart: (details) {
                  setState(() => isSeeking = true);
                },
                onHorizontalDragUpdate: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final x = details.localPosition.dx;
                  final newPosition = (x / box.size.width).clamp(0.0, 1.0);
                  setState(() => seekPosition = newPosition);
                },
                onHorizontalDragEnd: (details) {
                  setState(() => isSeeking = false);
                  _controller.seekTo(value.duration * seekPosition);
                },
                child: Container(
                  height: 30, // Increased height for better touch area
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      // Background track
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 14, // Centered vertically
                        child: Container(
                          height: 2,
                          color: Colors.grey[300],
                        ),
                      ),

                      // Progress bar
                      Positioned(
                        left: 0,
                        bottom: 14, // Centered vertically
                        child: Container(
                          height: 2,
                          width:
                              MediaQuery.of(context).size.width * safeFraction,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),

                      // Thumb
                      Positioned(
                        left: MediaQuery.of(context).size.width * safeFraction -
                            10,
                        bottom: 10, // Aligned with progress bar
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.SECONDARY_COLOR,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Play/Pause button
        ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: _controller,
          builder: (context, value, child) {
            return AnimatedOpacity(
              opacity: (value.isPlaying && !isFloating) ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                icon: Icon(
                  value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 50,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                onPressed: _togglePlayPause,
              ),
            );
          },
        ),

        // Time display
        if (!isFloating)
          Positioned(
            bottom: 20,
            left: 10,
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: _controller,
              builder: (context, value, child) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${formatDuration(value.position)} / ${formatDuration(value.duration)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),

        // Full-screen button
        if (!isFloating)
          Positioned(
            bottom: 20,
            right: 10,
            child: GestureDetector(
              onTap: () {
                _toggleFullScreen('Full-screen button');
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? Icons.fullscreen
                      : Icons.fullscreen_exit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

        // Floating mode button
        if (!isFullScreen)
          Positioned(
            top: 10,
            right: 50,
            child: GestureDetector(
              onTap: () {
                FloatingVideoManager.showFloatingPlayer(
                  context: context,
                  videoUrl: widget.videoUrl,
                  title: widget.title,
                  controller: _controller,
                  isPlaying: _isPlaying,
                );
                Navigator.pop(context); // Go back to previous screen
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.picture_in_picture,
                    color: Colors.white, size: 20),
              ),
            ),
          ),
      ],
    );
  }

/*  Widget _buildVideoControls({
    bool isFullScreen = false,
    bool isFloating = false,
  }) {
    // Add state variables for seeking
    bool isSeeking = false;
    double seekPosition = 0.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background progress track - Removed from here and moved into Slider

        // Progress indicator with interactive slider
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (!value.isInitialized || value.duration == Duration.zero) {
                return const SizedBox();
              }

              final progressFraction = isSeeking
                  ? seekPosition
                  : value.position.inMilliseconds / value.duration.inMilliseconds;
              final safeFraction = progressFraction.clamp(0.0, 1.0);

              return GestureDetector(
                onTapDown: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final x = details.localPosition.dx;
                  final newPosition = (x / box.size.width).clamp(0.0, 1.0);
                  _controller.seekTo(value.duration * newPosition);
                },
                onHorizontalDragStart: (details) {
                  setState(() => isSeeking = true);
                },
                onHorizontalDragUpdate: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final x = details.localPosition.dx;
                  final newPosition = (x / box.size.width).clamp(0.0, 1.0);
                  setState(() => seekPosition = newPosition);
                },
                onHorizontalDragEnd: (details) {
                  setState(() => isSeeking = false);
                  _controller.seekTo(value.duration * seekPosition);
                },
                child: Container(
                  height: 30,  // Increased height for better touch area
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      // Background track
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 14,  // Centered vertically
                        child: Container(
                          height: 2,
                          color: Colors.grey[300],
                        ),
                      ),

                      // Progress bar
                      Positioned(
                        left: 0,
                        bottom: 14,  // Centered vertically
                        child: Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width * safeFraction,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),

                      // Thumb
                      Positioned(
                        left: MediaQuery.of(context).size.width * safeFraction - 10,
                        bottom: 10,  // Aligned with progress bar
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.SECONDARY_COLOR,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Play/Pause button - Remains the same
        ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: _controller,
          builder: (context, value, child) {
            return AnimatedOpacity(
              opacity: (value.isPlaying && !isFloating) ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                icon: Icon(
                  value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 50,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                onPressed: _togglePlayPause,
              ),
            );
          },
        ),


        // Time display - Adjusted position
        if (!isFloating)
          if (!isFloating)
            Positioned(
              bottom: 15,
              left: 10,
              child: ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: _controller,
                builder: (context, value, child) {
                  return Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${formatDuration(value.position)} / ${formatDuration(value.duration)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),

        // Full-screen button - Adjusted position
        if (!isFloating)
          Positioned(
            bottom: 30,  // Moved up above progress bar
            right: 10,
            child: GestureDetector(
              // ... existing fullscreen code ...
            ),
          ),

        // Floating mode button - Position adjusted for visibility
        if (!isFullScreen)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,  // Below status bar
            right: 10,
            child: GestureDetector(
              // ... existing floating button code ...
            ),
          ),

        // Full-screen button
        if (!isFloating)
          Positioned(
            bottom: 15,
            right: 10,
            child: GestureDetector(
              onTap: () {
                _toggleFullScreen('Full-screen button');
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? Icons.fullscreen
                      : Icons.fullscreen_exit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

        // Floating mode button
        if (!isFullScreen)
          Positioned(
            top: 10,
            right: 50,
            child: GestureDetector(
              onTap: () {
                FloatingVideoManager.showFloatingPlayer(
                  context: context,
                  videoUrl: widget.videoUrl,
                  title: widget.title,
                  controller: _controller,
                  isPlaying: _isPlaying,
                );
                Navigator.pop(context); // Go back to previous screen
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.picture_in_picture,
                    color: Colors.white, size: 20),
              ),
            ),
          ),
      ],
    );
  }*/

  Widget _buildFloatingPlayer() {
    return Positioned(
      left: _floatingPosition.dx,
      top: _floatingPosition.dy,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            _isDragging = true;
            _showFloatingControls = true;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            _floatingPosition = Offset(
              _floatingPosition.dx + details.delta.dx,
              _floatingPosition.dy + details.delta.dy,
            );
          });
        },
        onPanEnd: (details) {
          setState(() {
            _isDragging = false;
          });
          // Hide controls after a delay
          Future.delayed(const Duration(seconds: 2), () {
            if (!_isDragging) {
              setState(() {
                _showFloatingControls = false;
              });
            }
          });
        },
        onTap: () {
          setState(() {
            _showFloatingControls = !_showFloatingControls;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _showFloatingControls ? 300 : 160,
          height: _showFloatingControls ? 200 : 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                _buildVideoPlayer(isFloating: true),

                // Floating player controls
                if (_showFloatingControls)
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
                            Colors.black.withValues(alpha: 0.7),
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
                            onPressed: _toggleFloatingMode,
                          ),
                        ],
                      ),
                    ),
                  ),

                if (_showFloatingControls)
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
                            Colors.black.withValues(alpha: 0.7),
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
                            icon: const Icon(Icons.fullscreen,
                                color: Colors.white, size: 20),
                            onPressed: () {
                              _toggleFullScreen('showFloatingControls');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                // Small play/pause button when controls are hidden
                if (!_showFloatingControls)
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return PopScope(
      canPop: isPortrait && !_isFloating,
      onPopInvoked: (didPop) {
        if (!didPop && !isPortrait) {
          _toggleFullScreen('pop');
        } else if (_isFloating) {
          setState(() => _isFloating = false);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            if (isPortrait && !_isFloating)
              SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: _isInitialized
                        ? _buildVideoPlayer()
                        : const AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Center(
                              child: CustomCircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            // Floating player overlay
            if (_isFloating) _buildFloatingPlayer(),
          ],
        ),
      ),
    );
  }
}

class FloatingVideoManager {
  static OverlayEntry? _overlayEntry;

  static void showFloatingPlayer({
    required BuildContext context,
    required String videoUrl,
    required String title,
    required VideoPlayerController controller,
    required bool isPlaying,
  }) {
    // Close existing player if any
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

  // Calculate floating player dimensions based on video orientation
  Size get _floatingSize {
    var width = MediaQuery.of(navigatorKey.currentContext!).size.width;
    final baseWidth = _showControls ? width * .9 : width * .6;

    if (!_controller.value.isInitialized) {
      return Size(baseWidth, baseWidth * 16 / 9); // Default landscape
    }

    // Use the video's actual dimensions
    final videoWidth = _controller.value.size.width;
    final videoHeight = _controller.value.size.height;

    if (videoWidth > videoHeight) {
      // Landscape video
      return Size(baseWidth, baseWidth * videoHeight / videoWidth);
    } else {
      // Portrait video
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
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Video player with rotation support
                  if (_controller.value.isInitialized)
                    Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  else
                    const Center(child: CircularProgressIndicator()),

                  // Floating player controls
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
                              Colors.black.withValues(alpha: 0.7),
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
                              Colors.black.withValues(alpha: 0.7),
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
                                FloatingVideoManager.closeFloatingPlayer();
                                //TODO : Navigate to Original Screen

                                // navigatorKey.currentState!.push(
                                //   MaterialPageRoute(
                                //     builder: (context) => TalentVideoPlayer(
                                //       videoUrl: widget.videoUrl,
                                //       talent: widget.talent,
                                //     ),
                                //   ),
                                // );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Small play/pause button when controls are hidden
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
