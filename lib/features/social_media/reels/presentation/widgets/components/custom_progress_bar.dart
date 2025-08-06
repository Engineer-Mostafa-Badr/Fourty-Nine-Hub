import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class CustomProgressBar extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const CustomProgressBar({super.key, required this.videoPlayerController});

  @override
  _CustomProgressBarState createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  bool _isDragging = false;
  bool _wasPlaying = false;
  double _dragValue = 0.0;

  VideoPlayerController get controller => widget.videoPlayerController;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        if (!value.isInitialized) {
          return Container(); // Handle uninitialized controller
        }

        final duration = value.duration;
        final position = _isDragging
            ? Duration(milliseconds: _dragValue.toInt())
            : value.position;
        final bufferedEnd = value.buffered.isNotEmpty
            ? value.buffered.last.end.inMilliseconds
            : 0;
        final durationInMs = duration.inMilliseconds > 0
            ? duration.inMilliseconds
            : 1; // Prevent division by zero

        final playedPart = (_isDragging
                ? _dragValue / durationInMs
                : position.inMilliseconds / durationInMs)
            .clamp(0.0, 1.0);
        final bufferedPart = bufferedEnd / durationInMs;

        return Column(
          children: [
            // Time labels
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         _formatDuration(position),
            //         style: const TextStyle(color: Colors.white, fontSize: 12),
            //       ),
            //       Text(
            //         _formatDuration(duration),
            //         style: const TextStyle(color: Colors.white, fontSize: 12),
            //       ),
            //     ],
            //   ),
            // ),
            // Progress bar
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (details) {
                setState(() {
                  _isDragging = true;
                  _wasPlaying = controller.value.isPlaying;
                  if (_wasPlaying) {
                    controller.pause();
                  }
                });
                HapticFeedback.lightImpact();
              },
              onHorizontalDragUpdate: (details) {
                final box = context.findRenderObject() as RenderBox;
                final tapPos = box.globalToLocal(details.globalPosition);
                final relative = tapPos.dx / box.size.width;
                final position = relative * durationInMs;
                setState(() {
                  _dragValue = position.clamp(0.0, durationInMs.toDouble());
                });
              },
              onHorizontalDragEnd: (details) {
                controller
                    .seekTo(Duration(milliseconds: _dragValue.toInt()))
                    .then((_) {
                  if (_wasPlaying) {
                    controller.play();
                  }
                });
                setState(() {
                  _isDragging = false;
                });
              },
              onTapDown: (details) {
                final box = context.findRenderObject() as RenderBox;
                final tapPos = box.globalToLocal(details.globalPosition);
                final relative = tapPos.dx / box.size.width;
                final position = relative * durationInMs;
                controller.seekTo(Duration(milliseconds: position.toInt()));
                HapticFeedback.lightImpact();
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth - 26; // Adjust for padding
                  final thumbSize = _isDragging ? 8.0 : 5.0;
                  final thumbPos = (playedPart * width) -
                      (thumbSize / 2) +
                      2; // Adjust for margin

                  return Container(
                    height: 10,
                    // margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        // Background
                        Container(
                          height: 1.2,
                          decoration: BoxDecoration(
                            color: Colors.grey[800]?.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: playedPart,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.white70.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Thumb
                        Positioned(
                          left: thumbPos.clamp(0.0, width),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: thumbSize,
                            height: thumbSize,
                            decoration:  BoxDecoration(
                              color: Colors.white70,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
