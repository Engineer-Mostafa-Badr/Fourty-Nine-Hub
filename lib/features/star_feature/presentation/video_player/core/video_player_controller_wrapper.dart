import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_player_state.dart';

/// Safe wrapper around VideoPlayerController with lifecycle management
class VideoPlayerControllerWrapper {
  final VideoPlayerController _controller;
  final String videoId;
  bool _isDisposed = false;
  final StreamController<VideoPlayerState> _stateController =
      StreamController<VideoPlayerState>.broadcast();

  VideoPlayerState _currentState = const VideoPlayerState();

  VideoPlayerControllerWrapper({
    required VideoPlayerController controller,
    required this.videoId,
  }) : _controller = controller {
    _controller.addListener(_onControllerUpdate);
  }

  // Getters
  VideoPlayerController get controller => _controller;
  bool get isDisposed => _isDisposed;
  VideoPlayerState get state => _currentState;
  Stream<VideoPlayerState> get stateStream => _stateController.stream;
  bool get isInitialized => !_isDisposed && _controller.value.isInitialized;

  void _onControllerUpdate() {
    if (_isDisposed) return;

    try {
      final value = _controller.value;
      _currentState = _currentState.copyWith(
        isInitialized: value.isInitialized,
        isPlaying: value.isPlaying,
        isBuffering: value.isBuffering,
        hasError: value.hasError,
        errorMessage: value.errorDescription,
        position: value.position,
        duration: value.duration,
      );

      _stateController.add(_currentState);
    } catch (e) {
      debugPrint('Error in controller update: $e');
    }
  }

  // Playback controls
  Future<void> play() async {
    if (_isDisposed || !_controller.value.isInitialized) return;
    try {
      await _controller.play();
    } catch (e) {
      debugPrint('Error playing video: $e');
    }
  }

  Future<void> pause() async {
    if (_isDisposed || !_controller.value.isInitialized) return;
    try {
      await _controller.pause();
    } catch (e) {
      debugPrint('Error pausing video: $e');
    }
  }

  Future<void> seekTo(Duration position) async {
    if (_isDisposed || !_controller.value.isInitialized) return;
    try {
      await _controller.seekTo(position);
    } catch (e) {
      debugPrint('Error seeking video: $e');
    }
  }

  void setVolume(double volume) {
    if (_isDisposed || !_controller.value.isInitialized) return;
    try {
      _controller.setVolume(volume);
      _currentState = _currentState.copyWith(
        isMuted: volume == 0,
      );
      _stateController.add(_currentState);
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  void setLooping(bool looping) {
    if (_isDisposed || !_controller.value.isInitialized) return;
    try {
      _controller.setLooping(looping);
    } catch (e) {
      debugPrint('Error setting looping: $e');
    }
  }

  void updateVisibility(double fraction) {
    if (_isDisposed) return;
    _currentState = _currentState.copyWith(visibilityFraction: fraction);
    _stateController.add(_currentState);
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;

    try {
      _controller.removeListener(_onControllerUpdate);
      await _stateController.close();
    } catch (e) {
      debugPrint('Error disposing controller wrapper: $e');
    }
  }
}
