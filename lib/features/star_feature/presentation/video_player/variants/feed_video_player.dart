import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Timer? _playDelayTimer;
  Timer? _initTimer;
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

        // Auto-play if configured - use centralized control
        // Using 50% threshold (industry standard - MRC/Active View)
        if (widget.autoPlay && _visibilityFraction > 0.5) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (mounted && !_isDisposed && _wrapper != null) {
            final success =
                await VideoPlayerManager.instance.requestPlay(videoId);
            if (success) {
              _trackVideoStart();
            }
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
    if (_wrapper != null && _wrapper!.isInitialized) {
      _wrapper!.seekTo(Duration.zero);
      _wrapper!.pause();
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

  // Build favorite button with BlocBuilder to prevent excessive rebuilds
  Widget _buildFavoriteButton() {
    if (widget.talent == null || widget.cubit == null) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<StarCubit, StarState>(
      bloc: widget.cubit,
      buildWhen: (previous, current) {
        // Only rebuild when favorites actually change
        return previous.favoriteTalents != current.favoriteTalents;
      },
      builder: (context, state) {
        final isFavorite = state.favoriteTalents.any(
          (fav) => fav.id == widget.talent!.id,
        );

        return Container(
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
        );
      },
    );
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (_isDisposed) return;

    _visibilityFraction = info.visibleFraction;

    // Cancel pending timers
    _playDelayTimer?.cancel();
    _initTimer?.cancel();

    if (info.visibleFraction > 0.5) {
      // Visible (>50%) - initialize if needed
      if (!_isInitialized && !_isInitializing) {
        _initTimer = Timer(const Duration(milliseconds: 200), () {
          if (mounted && !_isDisposed && _visibilityFraction > 0.5) {
            _initializeVideo();
          }
        });
      } else if (_isInitialized && widget.autoPlay && !_isPlaying) {
        // Auto-play with delay - use centralized control
        _playDelayTimer = Timer(const Duration(milliseconds: 300), () async {
          if (mounted && !_isDisposed && _wrapper != null && !_isPlaying) {
            final success =
                await VideoPlayerManager.instance.requestPlay(videoId);
            if (success) {
              _trackVideoStart();
            }
          }
        });
      }
    } else if (info.visibleFraction < 0.25) {
      // Not visible - pause using centralized control
      if (_wrapper != null && _isPlaying) {
        VideoPlayerManager.instance.pauseVideo(videoId);
      }

      // Dispose if completely out of view
      if (info.visibleFraction == 0) {
        _disposeController();
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
    return RepaintBoundary(
      child: VisibilityDetector(
        key: Key('feed-video-$videoId'),
        onVisibilityChanged: _handleVisibilityChanged,
        child: GestureDetector(
          onTap: () {
            ManageVibration.vibrate();
            if (_isInitialized) {
              setState(() => _showControls = !_showControls);
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

                // Favorite button (top left) - Only rebuild when favorites change
                if (widget.talent != null && widget.cubit != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildFavoriteButton(),
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

    _playDelayTimer?.cancel();
    _playDelayTimer = null;
    _initTimer?.cancel();
    _initTimer = null;

    _stateSubscription?.cancel();
    _stateSubscription = null;

    _wrapper = null;

    super.dispose();
  }
}
