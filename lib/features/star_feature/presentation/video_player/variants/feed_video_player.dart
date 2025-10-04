import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../domain/entity/star_entity.dart';
import '../../controller/star_cubit/star_cubit.dart';
import '../core/video_player_controller_wrapper.dart';
import '../core/video_player_manager.dart';
import '../controls/video_thumbnail.dart';

/// Feed video player variant - optimized for feed scrolling
/// Replaces TalentVideoPlayerWidget with cleaner architecture
class FeedVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final bool autoPlay;
  final bool startMuted;
  final VoidCallback? onTap;
  final VoidCallback? onVideoStarted;
  final StarEntity? talent;
  final StarCubit? cubit;
  final double heightFraction;

  const FeedVideoPlayer({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.autoPlay = false,
    this.startMuted = true,
    this.onTap,
    this.onVideoStarted,
    this.talent,
    this.cubit,
    this.heightFraction = 0.3,
  });

  @override
  State<FeedVideoPlayer> createState() => _FeedVideoPlayerState();
}

class _FeedVideoPlayerState extends State<FeedVideoPlayer> {
  VideoPlayerControllerWrapper? _wrapper;
  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _showControls = true;
  double _visibilityFraction = 0;
  bool _hasTrackedView = false;
  bool _isDisposed = false;
  bool _hasCompletedOnce = false; // Track if video completed once

  Timer? _playDelayTimer;
  Timer? _initTimer;
  Timer? _controlsTimer;
  StreamSubscription? _stateSubscription;

  String get videoId => '${widget.talent?.id ?? widget.videoUrl.hashCode}';

  @override
  void initState() {
    super.initState();
    _isMuted = widget.startMuted;
  }

  Future<void> _initializeVideo() async {
    if (_isInitializing || _isDisposed || _wrapper != null) return;

    if (mounted && !_isDisposed) {
      setState(() => _isInitializing = true);
    }

    try {
      final wrapper = await VideoPlayerManager.instance.getController(
        widget.videoUrl,
        videoId,
      );

      if (wrapper != null && mounted && !_isDisposed) {
        _wrapper = wrapper;
        _wrapper!.setVolume(_isMuted ? 0 : 1);
        _wrapper!.setLooping(false);

        // Listen to state changes
        _stateSubscription = _wrapper!.stateStream.listen((state) {
          if (!mounted || _isDisposed) return;

          setState(() {
            _isPlaying = state.isPlaying;
            _isInitialized = state.isInitialized;
          });

          if (state.isPlaying && !_hasTrackedView) {
            _trackVideoStart();
          }

          // Handle video end
          if (state.isAtEnd) {
            _handleVideoEnd();
          }
        });

        if (mounted && !_isDisposed) {
          setState(() {
            _isInitialized = true;
            _isInitializing = false;
          });
        }

        // Auto-play if configured
        if (widget.autoPlay && _visibilityFraction > 0.3) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (mounted && !_isDisposed && _wrapper != null) {
            await _wrapper!.play();
            _trackVideoStart();
          }
        }
      }
    } catch (error) {
      debugPrint('Video initialization error: $error');
      if (mounted && !_isDisposed) {
        setState(() {
          _isInitialized = false;
          _isInitializing = false;
        });
      }
    }
  }

  void _trackVideoStart() {
    if (!_hasTrackedView) {
      _hasTrackedView = true;
      widget.onVideoStarted?.call();
    }
  }

  void _handleVideoEnd() {
    if (_wrapper == null || !_wrapper!.isInitialized || _isDisposed) return;

    _hasCompletedOnce = true;

    // CRITICAL FIX: Don't seekTo(Duration.zero) - this causes MediaCodec FLUSH
    // Instead, just pause at the end to avoid flush/resume cycles
    if (mounted && !_isDisposed) {
      _wrapper!.pause();
      VideoPlayerManager.instance.markInactive(videoId);

      // Show thumbnail overlay when ended
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _togglePlayPause() {
    if (_wrapper == null || !_isInitialized || _isDisposed || !mounted) return;

    try {
      if (_isPlaying) {
        _wrapper!.pause();
        VideoPlayerManager.instance.markInactive(videoId);
      } else {
        // If video ended, seek to start (only when user explicitly restarts)
        if (_hasCompletedOnce && _wrapper!.controller.value.position >= _wrapper!.controller.value.duration) {
          _wrapper!.seekTo(Duration.zero);
        }
        _wrapper!.play();
        VideoPlayerManager.instance.markActive(videoId);
        _trackVideoStart();
      }
    } catch (e) {
      debugPrint('⚠️ Error toggling play/pause: $e');
    }
  }

  void _toggleMute() {
    if (mounted && !_isDisposed && _wrapper != null) {
      setState(() {
        _isMuted = !_isMuted;
        _wrapper?.setVolume(_isMuted ? 0 : 1);
      });
    }
  }

  void _toggleFavorite() {
    if (widget.talent != null && widget.cubit != null) {
      widget.cubit!.toggleFavorite(widget.talent!.id);
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (_isDisposed) return;

    _visibilityFraction = info.visibleFraction;

    // Cancel pending timers
    _playDelayTimer?.cancel();
    _initTimer?.cancel();

    if (info.visibleFraction > 0.5) {
      // Highly visible - initialize if needed
      if (!_isInitialized && !_isInitializing) {
        _initTimer = Timer(const Duration(milliseconds: 300), () {
          if (mounted && !_isDisposed && _visibilityFraction > 0.5) {
            _initializeVideo();
          }
        });
      } else if (_isInitialized && widget.autoPlay && !_isPlaying && !_hasCompletedOnce) {
        // Auto-play with delay (only if video hasn't completed yet)
        _playDelayTimer = Timer(const Duration(milliseconds: 400), () {
          if (mounted && !_isDisposed && _wrapper != null && !_isPlaying) {
            _wrapper!.play();
            VideoPlayerManager.instance.markActive(videoId);
            _trackVideoStart();
          }
        });
      }
    } else if (info.visibleFraction < 0.3) {
      // Less visible - pause to save resources
      if (_wrapper != null && _isPlaying) {
        _wrapper!.pause();
        VideoPlayerManager.instance.markInactive(videoId);
      }

      // Dispose if mostly out of view (changed from == 0 to < 0.1)
      if (info.visibleFraction < 0.1) {
        // Delay disposal to avoid rapid dispose/recreate during fast scrolling
        _playDelayTimer = Timer(const Duration(milliseconds: 500), () {
          if (mounted && !_isDisposed && _visibilityFraction < 0.1) {
            _disposeController();
          }
        });
      }
    }
  }

  Future<void> _disposeController() async {
    if (_wrapper != null) {
      await _stateSubscription?.cancel();
      _stateSubscription = null;
      _wrapper = null;

      if (mounted && !_isDisposed) {
        setState(() {
          _isInitialized = false;
          _isPlaying = false;
          _isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = widget.talent != null && widget.cubit != null
        ? widget.cubit!.isFavorite(widget.talent!.id)
        : false;

    return RepaintBoundary(
      child: VisibilityDetector(
        key: Key('feed-video-$videoId'),
        onVisibilityChanged: _handleVisibilityChanged,
        child: GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
          if (_isInitialized) {
            // Auto-hide controls after 3 seconds
            _controlsTimer?.cancel();
            setState(() => _showControls = true);
            _controlsTimer = Timer(const Duration(seconds: 3), () {
              if (mounted && _isPlaying) {
                setState(() => _showControls = false);
              }
            });
          }
          widget.onTap?.call();
        },
        child: Container(
          height: MediaQuery.of(context).size.height * widget.heightFraction,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Thumbnail (when not playing)
              if (!_isPlaying)
                Positioned.fill(
                  child: VideoThumbnail(
                    thumbnailUrl: widget.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),

              // Video Player (when initialized)
              if (_isInitialized &&
                  _wrapper != null &&
                  !_isDisposed &&
                  mounted &&
                  _wrapper!.isInitialized)
                Opacity(
                  opacity: _isPlaying ? 1.0 : 0.0,
                  child: AspectRatio(
                    aspectRatio: _wrapper!.controller.value.aspectRatio,
                    child: VideoPlayer(_wrapper!.controller),
                  ),
                ),

              // Loading indicator
              if (_isInitializing)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),

              // Favorite button (top left)
              if (widget.talent != null && widget.cubit != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xffFF0000),
                        size: 20,
                      ),
                      onPressed: _toggleFavorite,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),

              // Mute button (top right, when playing)
              if (_isInitialized && _isPlaying)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _toggleMute,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
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
  void dispose() {
    _isDisposed = true;

    // Cancel all timers to prevent memory leaks
    _playDelayTimer?.cancel();
    _playDelayTimer = null;
    _initTimer?.cancel();
    _initTimer = null;
    _controlsTimer?.cancel();
    _controlsTimer = null;

    // Cancel subscription
    _stateSubscription?.cancel();
    _stateSubscription = null;

    // Mark as inactive before disposing
    if (_wrapper != null) {
      VideoPlayerManager.instance.markInactive(videoId);
    }
    _wrapper = null;

    super.dispose();
  }
}
