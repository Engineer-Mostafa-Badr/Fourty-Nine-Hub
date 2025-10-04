import 'package:flutter/material.dart';

/// Video overlay controls (play/pause, mute, etc.)
class VideoOverlayControls extends StatelessWidget {
  final bool isPlaying;
  final bool isMuted;
  final bool showControls;
  final VoidCallback? onPlayPause;
  final VoidCallback? onMute;
  final VoidCallback? onFullscreen;
  final Widget? customCenterControl;
  final List<Widget>? topRightActions;
  final List<Widget>? bottomLeftActions;

  const VideoOverlayControls({
    super.key,
    required this.isPlaying,
    required this.isMuted,
    this.showControls = true,
    this.onPlayPause,
    this.onMute,
    this.onFullscreen,
    this.customCenterControl,
    this.topRightActions,
    this.bottomLeftActions,
  });

  @override
  Widget build(BuildContext context) {
    if (!showControls) return const SizedBox.shrink();

    return Container(
      color: Colors.black26,
      child: Stack(
        children: [
          // Center play/pause button
          if (customCenterControl != null)
            Center(child: customCenterControl!)
          else if (onPlayPause != null)
            Center(
              child: GestureDetector(
                onTap: onPlayPause,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),

          // Top right actions
          if (topRightActions != null)
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: topRightActions!,
              ),
            ),

          // Bottom left actions
          if (bottomLeftActions != null)
            Positioned(
              bottom: 8,
              left: 8,
              child: Row(
                children: bottomLeftActions!,
              ),
            ),

          // Mute button (bottom right)
          if (onMute != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                onPressed: onMute,
                icon: Icon(
                  isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                ),
              ),
            ),

          // Fullscreen button (if provided)
          if (onFullscreen != null)
            Positioned(
              bottom: 8,
              right: onMute != null ? 56 : 8,
              child: IconButton(
                onPressed: onFullscreen,
                icon: const Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Simple play button overlay
class PlayButtonOverlay extends StatelessWidget {
  final VoidCallback? onTap;

  const PlayButtonOverlay({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.black26,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}
