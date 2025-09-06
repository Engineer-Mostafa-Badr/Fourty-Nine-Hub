import 'package:better_player_plus/better_player_plus.dart';

class PreloadState {
  /// Video URLs (filled by your ReelsCubit / API).
  final List<String> urls;

  /// Controllers are OWNED by widgets. We only keep references for pause APIs.
  final Map<int, BetterPlayerController> controllers;

  final bool isLoading;
  final int focusedIndex;
  final int reloadCounter;

  PreloadState({
    required this.urls,
    required this.controllers,
    required this.isLoading,
    required this.focusedIndex,
    required this.reloadCounter,
  });

  factory PreloadState.initial() => PreloadState(
        urls: const [],
        controllers: <int, BetterPlayerController>{},
        isLoading: false,
        focusedIndex: 0,
        reloadCounter: 0,
      );

  PreloadState copyWith({
    List<String>? urls,
    Map<int, BetterPlayerController>? controllers,
    bool? isLoading,
    int? focusedIndex,
    int? reloadCounter,
  }) {
    return PreloadState(
      urls: urls ?? this.urls,
      controllers: controllers ?? this.controllers,
      isLoading: isLoading ?? this.isLoading,
      focusedIndex: focusedIndex ?? this.focusedIndex,
      reloadCounter: reloadCounter ?? this.reloadCounter,
    );
  }
}
