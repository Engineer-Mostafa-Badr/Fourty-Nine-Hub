import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../../../service_locator/service_locator.dart';
import '../explore_reels_cubit/reel_cubit.dart';
import 'preload_state.dart';

void _unawaited(Future<void> f) {}

class PreloadBloc extends Cubit<PreloadState> {
  PreloadBloc() : super(PreloadState.initial());

  StreamSubscription<ReelsState>? _reelsSubscription;
  int _focusEpoch = 0;
  bool _isShuttingDown = false;

  // ---------------- Public API ----------------

  void setLoading(bool isLoading) => emit(state.copyWith(isLoading: isLoading));

  void resetFocusedIndex(int index) {
    emit(state.copyWith(focusedIndex: 0, reloadCounter: 0));
    // we don't dispose here anymore; widget will own disposal
    _detachControllerAtIndex(index);
  }

  Future<void> shutdown() async {
    _isShuttingDown = true;

    await _reelsSubscription?.cancel();
    _reelsSubscription = null;

    // DO NOT dispose here (widgets own them). Just pause/mute & clear refs.
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

  /// Widgets call this when they create/destroy controllers
  void attachController(int index, BetterPlayerController controller) {
    if (_isShuttingDown) return;
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

        // just update urls; controllers are owned by widgets now
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
          // Update URL list if length changes (new reels)
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
    // Clear all refs; widgets on screen will re-attach themselves.
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
    _focusEpoch++;

    // Pause/mute previous focused
    final oldIndex = state.focusedIndex;
    if (oldIndex != index) _pauseControllerAtIndex(oldIndex);

    // Pause/mute everyone else; play/unmute current (if attached)
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
      c.setVolume(0.0);
    } catch (_) {}
  }

  void pauseOthersExcept(int index) {
    for (final entry in state.controllers.entries) {
      final i = entry.key;
      final c = entry.value;
      if (i == index) continue;
      try {
        c.pause();
        c.setVolume(0.0);
      } catch (_) {}
    }
  }

  // ---------------- NO-OPs kept for compatibility ----------------
  // These existed before and might be referenced elsewhere.
  // They are intentionally no-ops now because controllers are widget-owned.

  Future<void> prioritizedFocusInit(int index, {required int epoch}) async {
    // no-op; widget initializes/attaches controller
  }

  Future<void> initializeControllerAtIndex(
    int index, {
    int? epoch,
  }) async {
    // no-op
  }

  Future<String> _pickLowestVariantIfHls(String url) async {
    // You can keep this helper if you still want to down-select variants
    // for other callers; not used by bloc anymore.
    if (!url.toLowerCase().endsWith('.m3u8')) return url;
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) return url;

      final lines = const LineSplitter().convert(res.body);
      if (!lines.any((l) => l.startsWith('#EXT-X-STREAM-INF'))) {
        return url;
      }

      final variants = <Map<String, dynamic>>[];
      for (int i = 0; i < lines.length; i++) {
        final l = lines[i].trim();
        if (l.startsWith('#EXT-X-STREAM-INF:')) {
          final bw = _parseBandwidth(l);
          final nextLine = (i + 1 < lines.length) ? lines[i + 1].trim() : '';
          if (bw != null && nextLine.isNotEmpty && !nextLine.startsWith('#')) {
            final resolved = Uri.parse(url).resolve(nextLine).toString();
            variants.add({'bw': bw, 'uri': resolved});
          }
        }
      }
      if (variants.isEmpty) return url;
      variants.sort((a, b) => (a['bw'] as int).compareTo(b['bw'] as int));
      return variants.first['uri'];
    } catch (_) {
      return url;
    }
  }

  int? _parseBandwidth(String line) {
    final reg = RegExp(r'BANDWIDTH=(\d+)');
    final match = reg.firstMatch(line);
    return match != null ? int.tryParse(match.group(1)!) : null;
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

  void _disposeAllControllers() {
    // widgets own disposal; just clear references
    emit(state.copyWith(controllers: {}));
  }

  Future<void> preloadVideosAroundIndex(int index) async {
    // no-op (preload removed by request)
  }

  void _enforceMaxControllers() {
    // no-op (keep-alive window removed by request)
  }

  // ---------------- Extra APIs for UI ----------------

  bool isVideoReady(int index) {
    // We can't know; controller is widget-owned. Assume true if attached.
    return state.controllers.containsKey(index);
  }

  bool isVideoLoading(int index) {
    // Without pre-init we don't track; keep compatibility behavior (false).
    return false;
  }

  void pauseCurrent() => _pauseControllerAtIndex(state.focusedIndex);

  void pauseIndex(int index) => _pauseControllerAtIndex(index);

  void pauseAll() {
    for (final entry in state.controllers.entries) {
      try {
        entry.value.pause();
        entry.value.setVolume(0.0);
      } catch (_) {}
    }
  }
}
