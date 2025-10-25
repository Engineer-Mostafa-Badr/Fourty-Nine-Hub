import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../cubit/tube_cubit.dart';
import '../screens/tube_video_player_screen.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../cubit/tube_cubit.dart';
import '../screens/tube_video_player_screen.dart';
import '../../../../service_locator/service_locator.dart'; // Import your service locator

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../cubit/tube_cubit.dart';
import '../screens/tube_video_player_screen.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  double _xPosition = 8;
  double _yPosition = 60;
  Timer? _positionUpdateTimer;
  Duration _currentPosition = Duration.zero;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _startPositionUpdates();
  }

  void _startPositionUpdates() {
    _positionUpdateTimer?.cancel();
    _positionUpdateTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && !_isClosing) {
        final cubit = context.read<TubeCubit>();
        final state = cubit.state;
        final controller = state.videoPlayerController;

        if (!state.isLoading &&
            controller != null &&
            controller.value.isInitialized) {
          setState(() {
            _currentPosition = controller.value.position;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _positionUpdateTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cubit = context.read<TubeCubit>();
    final state = cubit.state;

    // ✅ IMPROVED: Better visibility check - remove isMinimized condition
    if (state.currentVideo == null ||
        _isClosing ||
        state.isLoading ||
        state.videoPlayerController == null ||
        !state.videoPlayerController!.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: _xPosition,
      bottom: _yPosition,
      child: GestureDetector(
        onPanUpdate: _isClosing
            ? null
            : (details) {
          setState(() {
            _xPosition += details.delta.dx;
            _yPosition -= details.delta.dy;
            _xPosition = _xPosition.clamp(0, screenWidth - 180);
            _yPosition = _yPosition.clamp(0, screenHeight - 200);
          });
        },
        onPanEnd: _isClosing
            ? null
            : (details) {
          setState(() {
            _xPosition = _xPosition < screenWidth / 2 - 90 ? 8 : screenWidth - 188;
          });
        },
        onTap: () {
          if (!_isClosing && state.currentVideo != null && !state.isLoading) {
            cubit.maximizePlayer();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: cubit,
                  child: VideoPlayerPage(video: state.currentVideo!),
                ),
              ),
            );
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 300) {
            _handleClose(cubit);
          }
        },
        child: Container(
          width: 180,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: _buildPlayerContent(cubit, state),
        ),
      ),
    );
  }

  void _handleClose(TubeCubit cubit) {
    setState(() {
      _isClosing = true;
    });
    cubit.closePlayer();

    // Reset position after closing
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _xPosition = 8;
          _yPosition = 60;
        });
      }
    });
  }

  Widget _buildPlayerContent(TubeCubit cubit, TubeState state) {
    // ✅ FIXED: Use cubit passed from parent instead of serviceLocator
    // Hide mini player if loading, no video, or closing
    if (state.currentVideo == null ||
        _isClosing ||
        state.isLoading ||
        state.videoPlayerController == null) {
      return const SizedBox.shrink();
    }

    final controller = state.videoPlayerController!;
    final position = _currentPosition;
    final duration = controller.value.duration;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return Stack(
      children: [
        // Video Player or Thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 180,
            height: 100,
            child: controller.value.isInitialized
                ? VideoPlayer(controller)
                : Image.network(
              state.currentVideo!.thumbnail!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[800],
                child: const Center(
                  child: Icon(Icons.error, color: Colors.white),
                ),
              ),
            ),
          ),
        ),

        // Close Button - FIXED
        Positioned(
          top: 4,
          left: 4,
          child: GestureDetector(
            onTap: () => _handleClose(cubit),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),

        // Play/Pause Button - FIXED
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              if (!_isClosing && !state.isLoading) {
                // cubit.toggleVideoPlayPause();
                cubit.togglePlayPause();
                // Force UI update
                setState(() {});
              }
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                state.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),

        // Progress Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Progress Indicator
                Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),

                // Time Display
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Title (truncated)
        Positioned(
          bottom: 24,
          left: 4,
          right: 4,
          child: Text(
            state.currentVideo!.title ?? "N/a",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}