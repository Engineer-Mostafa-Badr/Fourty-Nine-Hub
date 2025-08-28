import 'dart:async';
import 'dart:developer';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../service_locator/service_locator.dart';
import '../explore_reels_cubit/reel_cubit.dart';
import 'preload_state.dart';

class PreloadBloc extends Cubit<PreloadState> {
  PreloadBloc() : super(PreloadState.initial());

  StreamSubscription<ReelsState>? _reelsSubscription;

  bool _isShuttingDown = false; // << keeps us from playing while leaving
  bool get isShuttingDown => _isShuttingDown; // optional getter if you need it

  // ---------------- Public API ----------------

  void setLoading(bool isLoading) => emit(state.copyWith(isLoading: isLoading));

  /// Call this right before leaving the page (we use it from WillPopScope)
  void beginExit() {
    _isShuttingDown = true;
    pauseAll(); // pause/mute everything immediately
  }

  void resetFocusedIndex(int index) {
    emit(state.copyWith(focusedIndex: 0, reloadCounter: 0));
    _detachControllerAtIndex(index);
  }

  Future<void> shutdown() async {
    _isShuttingDown = true;

    await _reelsSubscription?.cancel();
    _reelsSubscription = null;

    // Don’t dispose (widgets own controllers). Just pause/mute.
    for (final c in state.controllers.values) {
      try {
        await c.pause();
      } catch (_) {}
      try {
        await c.setVolume(0.0);
      } catch (_) {}
    }

    emit(state.copyWith(controllers: {}, focusedIndex: 0, isLoading: false));
    _isShuttingDown = false;
  }

  void attachController(int index, BetterPlayerController controller) {
    if (_isShuttingDown) return; // don’t attach new ones while exiting
    state.controllers[index] = controller;
    emit(state.copyWith(
      controllers: Map<int, BetterPlayerController>.from(state.controllers),
    ));
  }

  void detachController(int index, BetterPlayerController controller) {
    final existing = state.controllers[index];
    if (existing == controller) {
      state.controllers.remove(index);
      emit(state.copyWith(
        controllers: Map<int, BetterPlayerController>.from(state.controllers),
      ));
    }
  }

  Future<void> getVideosFromApi() async {
    try {
      await _reelsSubscription?.cancel();
      _reelsSubscription = null;
      setLoading(true);

      final reelsCubit = serviceLocator<ReelsCubit>();

      Future<void> applyUrlsFromCubit() async {
        final urls =
            reelsCubit.state.globalReels.map((e) => e.videoMedia).toList();
        if (urls.isEmpty) {
          emit(state.copyWith(isLoading: false));
          return;
        }

        emit(state.copyWith(
          urls: urls,
          isLoading: false,
          reloadCounter: state.reloadCounter + 1,
          focusedIndex: 0,
        ));
      }

      if (reelsCubit.state.globalReels.isNotEmpty) {
        await applyUrlsFromCubit();
      }

      _reelsSubscription = reelsCubit.stream.listen((reelsState) async {
        if (!reelsState.isLoading && reelsState.globalReels.isNotEmpty) {
          final updated =
              reelsState.globalReels.map((e) => e.videoMedia).toList();
          if (updated.length != state.urls.length) {
            emit(state.copyWith(urls: updated));
          }
          setLoading(false);
        }
      });

      if (reelsCubit.state.globalReels.isEmpty) {
        reelsCubit.fetchReels();
      }
    } catch (e) {
      log('Error in getVideosFromApi: $e');
      setLoading(false);
    }
  }

  void handleScreenReturn() {
    emit(state.copyWith(controllers: {}, focusedIndex: 0, isLoading: true));
    Future.microtask(() async {
      if (state.urls.isNotEmpty) {
        emit(state.copyWith(isLoading: false));
      } else {
        getVideosFromApi();
      }
    });
  }

  void onVideoIndexChanged(int index) {
    if (_isShuttingDown) return; // << don’t react during exit

    // Pause/mute previous focused
    final oldIndex = state.focusedIndex;
    if (oldIndex != index) _pauseControllerAtIndex(oldIndex);

    // Pause/mute everyone else; play/unmute current
    for (final entry in state.controllers.entries) {
      final i = entry.key;
      final c = entry.value;
      if (i == index) {
        try {
          c.setVolume(1.0);
          c.play();
        } catch (_) {}
      } else {
        try {
          c.pause();
          c.setVolume(0.0);
        } catch (_) {}
      }
    }

    emit(state.copyWith(focusedIndex: index));
  }

  void _pauseControllerAtIndex(int index) {
    final c = state.controllers[index];
    if (c == null) return;
    try {
      c.pause();
    } catch (_) {}
    try {
      c.setVolume(0.0);
    } catch (_) {}
  }

  void pauseOthersExcept(int index) {
    if (_isShuttingDown) return; // << guard during exit
    for (final entry in state.controllers.entries) {
      final i = entry.key;
      final c = entry.value;
      if (i == index) continue;
      try {
        c.pause();
      } catch (_) {}
      try {
        c.setVolume(0.0);
      } catch (_) {}
    }
  }

  bool _detachControllerAtIndex(int index) {
    final c = state.controllers[index];
    if (c == null) return false;
    state.controllers.remove(index);
    emit(state.copyWith(
      controllers: Map<int, BetterPlayerController>.from(state.controllers),
    ));
    return true;
  }

  Future<void> preloadVideosAroundIndex(int index) async {}

  bool isVideoReady(int index) => state.controllers.containsKey(index);
  bool isVideoLoading(int index) => false;

  void pauseCurrent() => _pauseControllerAtIndex(state.focusedIndex);

  void pauseIndex(int index) => _pauseControllerAtIndex(index);

  void pauseAll() {
    for (final entry in state.controllers.entries) {
      try {
        entry.value.pause();
      } catch (_) {}
      try {
        entry.value.setVolume(0.0);
      } catch (_) {}
    }
  }
}
