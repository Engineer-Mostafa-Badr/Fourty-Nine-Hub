import 'package:flutter/material.dart';
import '../../../../../helpers/manage_vibration.dart';

/// Video player controls overlay
/// Handles play/pause, previous/next, and fullscreen controls
class VideoControlsOverlay extends StatelessWidget {
  final bool showControls;
  final bool isPlaying;
  final bool isFullscreen;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFullscreen;
  final VoidCallback onBack;

  const VideoControlsOverlay({
    super.key,
    required this.showControls,
    required this.isPlaying,
    required this.isFullscreen,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onFullscreen,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    if (!showControls) return const SizedBox.shrink();

    return Stack(
      children: [
        // Top bar with back button
        Positioned(
          top: isFullscreen ? 24 : 12,
          left: 12,
          right: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  if (isFullscreen) {
                    onFullscreen();
                  } else {
                    onBack();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFullscreen
                        ? Icons.fullscreen_exit
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Center play controls
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous button
              _buildControlButton(
                icon: Icons.skip_previous,
                onTap: onPrevious,
              ),
              const SizedBox(width: 20),

              // Play/Pause button
              _buildControlButton(
                icon: isPlaying ? Icons.pause : Icons.play_arrow,
                onTap: onPlayPause,
                size: 32,
                padding: 16,
              ),
              const SizedBox(width: 20),

              // Next button
              _buildControlButton(
                icon: Icons.skip_next,
                onTap: onNext,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 28,
    double padding = 12,
  }) {
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}
