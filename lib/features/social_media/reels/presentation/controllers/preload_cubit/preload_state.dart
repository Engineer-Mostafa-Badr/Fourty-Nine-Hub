// preload_state.dart
import 'package:video_player/video_player.dart';

class PreloadState {
  final List<String> urls;
  final Map<int, VideoPlayerController> controllers;
  final int focusedIndex;
  final int reloadCounter;
  final bool isLoading;

  PreloadState({
    required this.urls,
    required this.controllers,
    required this.focusedIndex,
    required this.reloadCounter,
    required this.isLoading,
  });

  // Initial state
  factory PreloadState.initial() {
    return PreloadState(
      urls: [],
      controllers: {},
      focusedIndex: 0,
      reloadCounter: 0,
      isLoading: false,
    );
  }

  // Manual copyWith method
  PreloadState copyWith({
    List<String>? urls,
    Map<int, VideoPlayerController>? controllers,
    int? focusedIndex,
    int? reloadCounter,
    bool? isLoading,
  }) {
    return PreloadState(
      urls: urls ?? this.urls,
      controllers: controllers ?? this.controllers,
      focusedIndex: focusedIndex ?? this.focusedIndex,
      reloadCounter: reloadCounter ?? this.reloadCounter,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
