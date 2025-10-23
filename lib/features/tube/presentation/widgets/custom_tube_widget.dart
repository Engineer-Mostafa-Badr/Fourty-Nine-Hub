import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/tube/presentation/cubit/tube_cubit.dart';
import 'package:video_player/video_player.dart';

class CustomVideoControls extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onDoubleTapLeft;
  final VoidCallback onDoubleTapRight;
  final bool Function() hasPrevious;
  final bool Function() hasNext;
  final String videoUrl;

  const CustomVideoControls({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.onDoubleTapLeft,
    required this.onDoubleTapRight,
    required this.hasPrevious,
    required this.hasNext,
    required this.videoUrl,
  });

  @override
  State<CustomVideoControls> createState() => _CustomVideoControlsState();
}

class _CustomVideoControlsState extends State<CustomVideoControls>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _previewController;
  bool _isPreviewReady = false;
  bool _isDragging = false;
  double _dragValue = 0.0;
  Offset? _dragPosition;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Timer? _hideTimer;
  bool _showControls = true;
  double _currentPlaybackSpeed = 1.0;
  Timer? _positionUpdateTimer;
  Duration _currentPosition = Duration.zero;
  int _currentQuality = 720;
  String? _currentVideoUrl; // Track the current video URL to detect changes

  @override
  void initState() {
    super.initState();
    _initializePreviewController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializePreviewController() async {
    if (_currentVideoUrl != widget.videoUrl) {
      // Dispose of the old preview controller if the video URL changes
      await _previewController?.pause();
      await _previewController?.dispose();
      _previewController = null;
      _isPreviewReady = false;
      _currentVideoUrl = widget.videoUrl;

      _previewController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );
      try {
        await _previewController?.initialize();
        await _previewController?.setVolume(0);
        if (mounted) {
          setState(() {
            _isPreviewReady = true;
          });
        }
      } catch (e) {
        debugPrint('Error initializing preview controller: $e');
        if (mounted) {
          setState(() {
            _isPreviewReady = false;
          });
        }
      }
    }
  }

  void _startPositionUpdates(VideoPlayerController? playerController) {
    _positionUpdateTimer?.cancel();
    if (playerController == null || !playerController.value.isInitialized) return;
    _positionUpdateTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && !_isDragging && playerController.value.isInitialized) {
        setState(() {
          _currentPosition = playerController.value.position;
        });
      }
    });
  }

  @override
  void didUpdateWidget(CustomVideoControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initializePreviewController();
    }
  }

  @override
  void dispose() {
    _previewController?.pause();
    _previewController?.dispose();
    _animationController?.dispose();
    _hideTimer?.cancel();
    _positionUpdateTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer(VideoPlayerController? playerController) {
    _hideTimer?.cancel();
    if (playerController != null && playerController.value.isPlaying && !_isDragging) {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !_isDragging) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${minutes}:${twoDigits(seconds)}';
  }
  String getBaseUrl(String url) {
    if (url.contains('/playlist.m3u8')) {
      return url.replaceAll('/playlist.m3u8', '');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TubeCubit, TubeState>(
      builder: (context, state) {
        final chewieController = state.chewieController;
        final playerController = state.videoPlayerController;

        // Return a loading indicator if controllers are not ready
        if (chewieController == null || playerController == null || !playerController.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        _startPositionUpdates(playerController);
        final position = _isDragging ? Duration(milliseconds: _dragValue.toInt()) : _currentPosition;
        final duration = playerController.value.duration;
        final currentValue = _isDragging ? _dragValue : _currentPosition.inMilliseconds.toDouble();

        if (playerController.value.isPlaying && _showControls && !_isDragging) {
          _startHideTimer(playerController);
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _showControls = !_showControls;
            });
            if (_showControls && playerController.value.isPlaying && !_isDragging) {
              _startHideTimer(playerController);
            }
          },
          onDoubleTapDown: _showControls
              ? (details) {
            final tapPosition = details.localPosition.dx;
            final screenWidth = MediaQuery.of(context).size.width;
            if (tapPosition < screenWidth / 2) {
              _animationController?.forward().then((_) => _animationController?.reverse());
              widget.onDoubleTapLeft();
            } else {
              _animationController?.forward().then((_) => _animationController?.reverse());
              widget.onDoubleTapRight();
            }
          }
              : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(playerController),
              if (state.showForwardIndicator)
                PositionedDirectional(
                  start: 20,
                  child: FadeTransition(
                    opacity: _fadeAnimation!,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.fast_forward, color: Colors.white, size: 24),
                          const SizedBox(width: 8),
                           Text(
                               context.isArabic ? 'تقديم 20 ثانية' : 'Fast Forward 20s',
                               style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (state.showBackwardIndicator)
                PositionedDirectional(
                  end: 20,
                  child: FadeTransition(
                    opacity: _fadeAnimation!,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.fast_rewind, color: Colors.white, size: 24),
                          const SizedBox(width: 8),
                           Text(
                          context.isArabic ? 'رجوع 20 ثانية' : 'Rewind 20s',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_showControls)
                AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child:  SizedBox.expand(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(0.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     children: [
                          //       PopupMenuButton<double>(
                          //         icon: Row(
                          //           children: [
                          //             const Icon(Icons.speed, color: Colors.white),
                          //             const SizedBox(width: 4),
                          //             Text(
                          //               '${_currentPlaybackSpeed}x',
                          //               style: const TextStyle(color: Colors.white),
                          //             ),
                          //           ],
                          //         ),
                          //         onSelected: (value) {
                          //           setState(() {
                          //             _currentPlaybackSpeed = value;
                          //           });
                          //           playerController.setPlaybackSpeed(value);
                          //         },
                          //         itemBuilder: (context) => [
                          //           const PopupMenuItem(value: 0.5, child: Text('0.5x')),
                          //           const PopupMenuItem(value: 1.0, child: Text('1.0x')),
                          //           const PopupMenuItem(value: 1.5, child: Text('1.5x')),
                          //           const PopupMenuItem(value: 2.0, child: Text('2.0x')),
                          //         ],
                          //       ),
                          //       // PopupMenuButton<int>(
                          //       //   icon: Row(
                          //       //     children: [
                          //       //       const Icon(Icons.high_quality, color: Colors.white),
                          //       //       const SizedBox(width: 4),
                          //       //       Text(
                          //       //         '${_currentQuality}p',
                          //       //         style: const TextStyle(color: Colors.white),
                          //       //       ),
                          //       //     ],
                          //       //   ),
                          //       //   onSelected: (value) async {
                          //       //     setState(() {
                          //       //       _currentQuality = value;
                          //       //     });
                          //       //
                          //       //     final baseUrl = getBaseUrl(widget.videoUrl);
                          //       //
                          //       //     // 🧩 Bunny quality pattern
                          //       //     final Map<int, String> qualityUrls = {
                          //       //       360: '$baseUrl/play_360p.mp4',
                          //       //       480: '$baseUrl/play_480p.mp4',
                          //       //       720: '$baseUrl/play_720p.mp4',
                          //       //     };
                          //       //
                          //       //     final newUrl = qualityUrls[value];
                          //       //     if (newUrl == null) return;
                          //       //
                          //       //     final tubeCubit = context.read<TubeCubit>();
                          //       //     final oldController = tubeCubit.state.videoPlayerController;
                          //       //     if (oldController == null) return;
                          //       //
                          //       //     // Save position
                          //       //     final currentPosition = await oldController.position ?? Duration.zero;
                          //       //
                          //       //     // Stop old
                          //       //     await oldController.pause();
                          //       //     await oldController.dispose();
                          //       //
                          //       //     // Create new
                          //       //     final newController = VideoPlayerController.networkUrl(Uri.parse(newUrl));
                          //       //     await newController.initialize();
                          //       //     await newController.seekTo(currentPosition);
                          //       //     await newController.setPlaybackSpeed(_currentPlaybackSpeed);
                          //       //
                          //       //     // Update TubeCubit
                          //       //     tubeCubit.updateVideoController(newController);
                          //       //
                          //       //     await newController.play();
                          //       //
                          //       //     debugPrint('✅ Switched to quality: $value ($newUrl)');
                          //       //   },
                          //       //   itemBuilder: (context) => const [
                          //       //     PopupMenuItem(value: 720, child: Text('720p')),
                          //       //     PopupMenuItem(value: 480, child: Text('480p')),
                          //       //     PopupMenuItem(value: 360, child: Text('360p')),
                          //       //   ],
                          //       // ),
                          //
                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // ✅ Background playback toggle button
                                // BlocBuilder<TubeCubit, TubeState>(
                                //   builder: (context, state) {
                                //     final cubit = context.read<TubeCubit>();
                                //     final currentUrl = state.currentVideo?.videoUrl ?? '';
                                //
                                //     return IconButton(
                                //       tooltip: state.isBackgroundMode
                                //           ? "Disable background playback"
                                //           : "Enable background playback",
                                //       icon: Icon(
                                //         state.isBackgroundMode
                                //             ? Icons.notifications_active
                                //             : Icons.notifications_off,
                                //         color: state.isBackgroundMode ? Colors.redAccent : Colors.white,
                                //       ),
                                //       onPressed: () {
                                //         if (currentUrl.isEmpty) {
                                //           ScaffoldMessenger.of(context).showSnackBar(
                                //             const SnackBar(
                                //               content: Text("No video loaded for background playback."),
                                //               duration: Duration(seconds: 2),
                                //             ),
                                //           );
                                //           return;
                                //         }
                                //
                                //         cubit.toggleBackgroundMode(
                                //           !state.isBackgroundMode, // ✅ first argument: toggle flag
                                //           currentUrl,              // ✅ second argument: video URL
                                //         );
                                //
                                //         ScaffoldMessenger.of(context).showSnackBar(
                                //           SnackBar(
                                //             content: Text(
                                //               !state.isBackgroundMode
                                //                   ? 'Background playback enabled'
                                //                   : 'Background playback disabled',
                                //             ),
                                //             duration: const Duration(seconds: 2),
                                //           ),
                                //         );
                                //       },
                                //     );
                                //   },
                                // ),


                                // ⚙️ Existing playback speed popup
                                PopupMenuButton<double>(
                                  icon: Row(
                                    children: [
                                      const Icon(Icons.speed, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_currentPlaybackSpeed}x',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  onSelected: (value) {
                                    setState(() {
                                      _currentPlaybackSpeed = value;
                                    });
                                    playerController.setPlaybackSpeed(value);
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(value: 0.5, child: Text('0.5x')),
                                    const PopupMenuItem(value: 1.0, child: Text('1.0x')),
                                    const PopupMenuItem(value: 1.5, child: Text('1.5x')),
                                    const PopupMenuItem(value: 2.0, child: Text('2.0x')),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // السابق / التالي يتبدلون حسب اللغة
                              IconButton(
                                iconSize: 40,
                                icon: Icon(
                                  context.isArabic ? Icons.skip_next : Icons.skip_previous, // ← هنا التبديل
                                  color: widget.hasPrevious() ? Colors.white : Colors.grey.withOpacity(0.5),
                                ),
                                onPressed: widget.hasPrevious() ? widget.onPrevious : null,
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                iconSize: 64,
                                icon: Icon(
                                  playerController.value.isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  chewieController.togglePause();
                                  setState(() {
                                    _showControls = true;
                                    if (!playerController.value.isPlaying) {
                                      _hideTimer?.cancel();
                                    }
                                  });
                                  if (playerController.value.isPlaying && !_isDragging) {
                                    _startHideTimer(playerController);
                                  }
                                },
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                iconSize: 40,
                                icon: Icon(
                                  context.isArabic ? Icons.skip_previous : Icons.skip_next, // ← هنا التبديل العكسي
                                  color: widget.hasNext() ? Colors.white : Colors.grey.withOpacity(0.5),
                                ),
                                onPressed: widget.hasNext() ? widget.onNext : null,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: Colors.red,
                                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                                        thumbColor: Colors.red,
                                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                        overlayColor: Colors.red.withOpacity(0.2),
                                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                                        trackHeight: 3,
                                      ),
                                      child: Slider(
                                        value: currentValue,
                                        min: 0.0,
                                        max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
                                        onChangeStart: (value) async {
                                          setState(() {
                                            _isDragging = true;
                                            _dragValue = value;
                                            _showControls = true;
                                            _hideTimer?.cancel();
                                          });
                                          await playerController.seekTo(Duration(milliseconds: value.toInt()));
                                          if (_previewController != null && _isPreviewReady) {
                                            await _previewController!.seekTo(Duration(milliseconds: value.toInt()));
                                          }
                                        },
                                        onChanged: (value) async {
                                          setState(() {
                                            _dragValue = value;
                                            _currentPosition = Duration(milliseconds: value.toInt());
                                            final box = context.findRenderObject() as RenderBox?;
                                            if (box != null) {
                                              final width = box.size.width;
                                              final percentage = value / duration.inMilliseconds.toDouble();
                                              _dragPosition = Offset(width * percentage, 0);
                                            }
                                          });
                                          await playerController.seekTo(Duration(milliseconds: value.toInt()));
                                          if (_previewController != null && _isPreviewReady) {
                                            await _previewController!.seekTo(Duration(milliseconds: value.toInt()));
                                          }
                                        },
                                        onChangeEnd: (value) async {
                                          await playerController.seekTo(Duration(milliseconds: value.toInt()));
                                          setState(() {
                                            _isDragging = false;
                                            _dragPosition = null;
                                            _currentPosition = Duration(milliseconds: value.toInt());
                                          });
                                          if (playerController.value.isPlaying && !_isDragging) {
                                            _startHideTimer(playerController);
                                          }
                                        },
                                      ),
                                    ),
                                    if (_isDragging && _dragPosition != null && _isPreviewReady)
                                      Positioned(
                                        left: (_dragPosition!.dx - 60).clamp(0, MediaQuery.of(context).size.width - 120),
                                        bottom: 30,
                                        child: Container(
                                          width: 120,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: _previewController != null
                                                ? VideoPlayer(_previewController!)
                                                : const Center(child: CircularProgressIndicator()),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _formatDuration(position),
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        const Text(
                                          ' / ',
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        Text(
                                          _formatDuration(duration),
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            playerController.value.volume > 0 ? Icons.volume_up : Icons.volume_off,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          onPressed: () {
                                            playerController.setVolume(playerController.value.volume > 0 ? 0.0 : 1.0);
                                            setState(() {});
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            chewieController.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          onPressed: () {
                                            chewieController.toggleFullScreen();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}