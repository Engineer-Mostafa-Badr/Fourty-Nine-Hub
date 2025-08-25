import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/isolates/video_cache_isolate.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../shared/constants.dart';
import '../explore_reels_cubit/reel_cubit.dart';
import 'preload_state.dart';

// Optional helper to silence unawaited-futures lint
void _unawaited(Future<void> f) {}

class PreloadBloc extends Cubit<PreloadState> {
  PreloadBloc() : super(PreloadState.initial());

  StreamSubscription<ReelsState>? _reelsSubscription;

  /// Serialize all controller initializations to avoid MediaCodec contention
  Future<void> _initSerial = Future.value();

  // -------------------- Public API --------------------

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void resetFocusedIndex(int index) {
    emit(state.copyWith(focusedIndex: 0, reloadCounter: 0));
    _disposeControllerAtIndex(index);
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

        // 🔄 Reset serialized init queue so old timeouts don’t block first video
        _initSerial = Future.value();

        // Dispose any previous controllers
        for (var c in state.controllers.values) {
          try {
            c.dispose();
          } catch (_) {}
        }

        emit(state.copyWith(
          urls: urls,
          controllers: {},
          isLoading: true,
          reloadCounter: state.reloadCounter + 1,
          focusedIndex: 0, // ✅ ensure first reel is focused
        ));

        // Warm cache for index 0 ± 1 (async, won’t block UI)
        _unawaited(_ensureTripleBufferCached(0));

        // Try to init index 0 directly from network (non-fatal if timeout)
        await initializeControllerAtIndex(0, preferNetwork: true);

        // Also init index 1 in background (non-fatal, no autoplay)
        if (urls.length > 1) {
          _unawaited(initializeControllerAtIndex(1, preferNetwork: true));
        }

        // ✅ Mark ready — widget handles autoplay
        emit(state.copyWith(isLoading: false));
      }

      if (reelsCubit.state.globalReels.isNotEmpty) {
        await applyUrlsFromCubit();
      }

      _reelsSubscription = reelsCubit.stream.listen((reelsState) async {
        if (!reelsState.isLoading && reelsState.globalReels.isNotEmpty) {
          final updated =
              reelsState.globalReels.map((e) => e.videoMedia).toList();

          if (updated.length != state.urls.length) {
            _initSerial = Future.value();
            emit(state.copyWith(urls: updated));
            // Continue background caching/init for neighbors
            _ensureTripleBufferCached(state.focusedIndex);
            initializeControllerAtIndex(state.focusedIndex + 1);
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
      rethrow;
    }
  }

  /// Called when returning to the screen
  void handleScreenReturn() {
    _disposeAllControllers();
    _initSerial = Future.value();

    emit(state.copyWith(controllers: {}, focusedIndex: 0, isLoading: true));
    Future.microtask(() async {
      if (state.urls.isNotEmpty) {
        _unawaited(_ensureTripleBufferCached(0));
        await initializeControllerAtIndex(0, preferNetwork: true);
        if (state.urls.length > 1) {
          _unawaited(initializeControllerAtIndex(1, preferNetwork: true));
        }
        emit(state.copyWith(isLoading: false));
      } else {
        getVideosFromApi();
      }
    });
  }

  /// Caller should pause neighbors first (use [forcePauseAround]) then call this.
  void onVideoIndexChanged(int index) {
    final reelsCubit = serviceLocator<ReelsCubit>();
    final shouldFetch = index + kPreloadLimit >= state.urls.length;
    if (shouldFetch) {
      reelsCubit.fetchReels();
    }

    _ensureTripleBufferCached(index);

    if (index > state.focusedIndex) {
      _playNext(index);
    } else {
      _playPrevious(index);
    }

    preloadVideosAroundIndex(index);
    emit(state.copyWith(focusedIndex: index));
  }

  /// Pause focused and neighbors to free codec resources before init
  void forcePauseAround(int index) {
    _stopControllerAtIndex(state.focusedIndex);
    _stopControllerAtIndex(index - 1);
    _stopControllerAtIndex(index + 1);
  }

  /// Pause the currently focused reel (safe: checks bounds/initialized).
  void pauseCurrent() {
    final i = state.focusedIndex;
    if (i < 0 || i >= state.urls.length) return;
    final c = state.controllers[i];
    if (c == null) return;
    try {
      if (c.value.isInitialized && c.value.isPlaying) {
        c.pause();
        log('⏸️ pauseCurrent: $i');
      }
    } catch (e) {
      log('⚠️ pauseCurrent error: $e');
    }
  }

  void pauseIndex(int index) {
    if (index < 0 || index >= state.urls.length) return;
    final c = state.controllers[index];
    if (c == null) return;
    try {
      if (c.value.isInitialized && c.value.isPlaying) {
        c.pause();
        log('⏸️ pauseIndex: $index');
      }
    } catch (e) {
      log('⚠️ pauseIndex error: $e');
    }
  }

  void pauseAll() {
    for (final entry in state.controllers.entries) {
      final i = entry.key;
      final c = entry.value;
      try {
        if (c.value.isInitialized && c.value.isPlaying) {
          c.pause();
          log('⏸️ pauseAll: $i');
        }
      } catch (e) {
        log('⚠️ pauseAll error at $i: $e');
      }
    }
  }

  Future<void> retryVideoLoad(int index) async {
    if (index < 0 || index >= state.urls.length) return;

    log('🔄 Retrying video load for index $index');

    if (state.controllers.containsKey(index)) {
      state.controllers.remove(index);
      emit(state.copyWith(
          controllers:
              Map<int, VideoPlayerController>.from(state.controllers)));
    }

    try {
      await initializeControllerAtIndex(index, preferNetwork: true);
      log('✅ Video retry successful for index $index');
    } catch (e) {
      log('❌ Video retry failed for index $index: $e');
      await _handleVideoLoadError(index, 'Retry failed: $e');
    }
  }

  // -------------------- Caching --------------------

  Future<void> _ensureTripleBufferCached(int index) async {
    final List<String> toPrefetch = [];
    for (final i in [index - 1, index, index + 1]) {
      if (i < 0 || i >= state.urls.length) continue;
      final url = state.urls[i];
      if (!state.cachedPaths.containsKey(url)) {
        toPrefetch.add(url);
      }
    }
    if (toPrefetch.isEmpty) return;

    try {
      final result = await cacheVideosInIsolate(toPrefetch);
      final newMap = Map<String, String>.from(state.cachedPaths)
        ..addAll(result.urlToPath);
      emit(state.copyWith(cachedPaths: newMap));
    } catch (e) {
      log('Cache isolate error: $e');
    }
  }

  String _effectivePathForUrl(String url) {
    return state.cachedPaths[url] ?? url;
  }

  // -------------------- Navigation helpers --------------------

  void _playNext(int index) {
    if (index < 0 || index >= state.urls.length) return;

    _stopControllerAtIndex(index - 1);
    _unawaited(initializeControllerAtIndex(index));
    _disposeControllerAtIndex(index - 2);
  }

  void _playPrevious(int index) {
    if (index < 0 || index >= state.urls.length) return;

    _stopControllerAtIndex(index + 1);
    _unawaited(initializeControllerAtIndex(index));
    _disposeControllerAtIndex(index + 2);
  }

  // -------------------- Initialization (serialized) --------------------

  Future<void> initializeControllerAtIndex(
    int index, {
    bool preferNetwork = false,
  }) {
    _initSerial = _initSerial.then(
      (_) =>
          _doInitializeControllerAtIndex(index, preferNetwork: preferNetwork),
    );
    return _initSerial;
  }

  Future<void> _doInitializeControllerAtIndex(
    int index, {
    bool preferNetwork = false,
  }) async {
    if (index < 0 || index >= state.urls.length) return;

    final existing = state.controllers[index];
    if (existing != null) {
      if (existing.value.isInitialized) {
        return; // already ready
      } else {
        try {
          existing.dispose();
        } catch (_) {}
        state.controllers.remove(index);
        emit(state.copyWith(
            controllers:
                Map<int, VideoPlayerController>.from(state.controllers)));
      }
    }

    try {
      final String url = state.urls[index];
      final String pathOrUrl = preferNetwork ? url : _effectivePathForUrl(url);

      final Uri sourceUri =
          pathOrUrl.startsWith('http') ? pathOrUrl.toUri : Uri.file(pathOrUrl);

      final controller = pathOrUrl.startsWith('http')
          ? VideoPlayerController.networkUrl(sourceUri)
          : VideoPlayerController.file(File(pathOrUrl));

      // ⬇️ add first, then emit so UI can build ReelsWidget immediately
      state.controllers[index] = controller;
      emit(state.copyWith(
          controllers:
              Map<int, VideoPlayerController>.from(state.controllers)));

      await controller.initialize().timeout(const Duration(seconds: 15));

      controller.setLooping(true);
      await controller.seekTo(Duration.zero); // prime first frame

      log('🚀 INITIALIZED (primed) $index [preferNetwork=$preferNetwork]');
    } on TimeoutException catch (e) {
      log('⏳ Init timeout at index $index: $e');
      if (state.controllers.containsKey(index)) {
        state.controllers.remove(index);
        emit(state.copyWith(
            controllers:
                Map<int, VideoPlayerController>.from(state.controllers)));
      }
      return;
    } on PlatformException catch (e) {
      log('❌ PlatformException at index $index: $e');
      if (state.controllers.containsKey(index)) {
        state.controllers.remove(index);
        emit(state.copyWith(
            controllers:
                Map<int, VideoPlayerController>.from(state.controllers)));
      }

      final msg = e.toString();
      if (msg.contains('MediaCodecVideoRenderer')) {
        log('🧯 Codec resources likely exhausted; will retry when focused.');
        return;
      }
      return;
    } catch (e) {
      log('❌ Unexpected init error at index $index: $e');
      if (state.controllers.containsKey(index)) {
        state.controllers.remove(index);
        emit(state.copyWith(
            controllers:
                Map<int, VideoPlayerController>.from(state.controllers)));
      }
      return;
    }
  }

  // -------------------- Pause / Dispose / Error handling --------------------

  void _stopControllerAtIndex(int index) {
    if (index < 0 || index >= state.urls.length) return;
    final controller = state.controllers[index];
    if (controller == null) return;
    try {
      if (controller.value.isInitialized && controller.value.isPlaying) {
        controller.pause();
        log('⏸️ STOPPED $index');
      }
    } catch (e) {
      log('⚠️ STOP error at index $index: $e');
    }
  }

  bool _disposeControllerAtIndex(int index, {bool force = false}) {
    if (index < 0 || index >= state.urls.length) return false;
    if (!force && index == state.focusedIndex) return false;

    final controller = state.controllers[index];
    if (controller == null) return false;

    try {
      if (controller.value.isInitialized && controller.value.isPlaying) {
        controller.pause();
      }
    } catch (_) {}

    try {
      state.controllers.remove(index);
      emit(state.copyWith(
          controllers:
              Map<int, VideoPlayerController>.from(state.controllers)));
      controller.dispose();
      log('🗑️ DISPOSED $index');
      return true;
    } catch (e) {
      log('❌ DISPOSE failed at $index: $e');
      return false;
    }
  }

  void _disposeAllControllers() {
    if (state.controllers.isEmpty) return;
    final map = Map<int, VideoPlayerController>.from(state.controllers);
    state.controllers.clear();
    emit(state.copyWith(controllers: {}));
    for (var controller in map.values) {
      try {
        controller.dispose();
      } catch (_) {}
    }
  }

  Future<void> _handleVideoLoadError(int index, String error) async {
    log('❌ Video load error at $index: $error');
    if (state.controllers.containsKey(index)) {
      state.controllers.remove(index);
      emit(state.copyWith(
          controllers:
              Map<int, VideoPlayerController>.from(state.controllers)));
    }

    if (index == state.focusedIndex) {
      if (index + 1 < state.urls.length) {
        emit(state.copyWith(focusedIndex: index + 1));
        try {
          await initializeControllerAtIndex(index + 1, preferNetwork: true);
        } catch (e) {
          log('❌ Failed to initialize next after error: $e');
        }
      } else if (index > 0) {
        emit(state.copyWith(focusedIndex: index - 1));
        try {
          await initializeControllerAtIndex(index - 1, preferNetwork: true);
        } catch (e) {
          log('❌ Failed to initialize prev after error: $e');
        }
      }
    }
  }

  bool isVideoReady(int index) {
    final controller = state.controllers[index];
    return controller != null && controller.value.isInitialized;
  }

  bool isVideoLoading(int index) {
    return !isVideoReady(index) &&
        state.urls.isNotEmpty &&
        index < state.urls.length;
  }

  // -------------------- Preloading (sequential) --------------------

  Future<void> preloadVideosAroundIndex(int index) async {
    if (state.urls.isEmpty) return;

    final List<int> indicesToPreload = [];
    for (int i = index - 1; i <= index + 1; i++) {
      if (i >= 0 && i < state.urls.length && !isVideoReady(i)) {
        indicesToPreload.add(i);
      }
    }

    for (final i in indicesToPreload) {
      try {
        await initializeControllerAtIndex(i); // serialized under _initSerial
      } catch (e) {
        log('❌ Preload failed at $i: $e');
      }
    }
  }

  // -------------------- Cleanup --------------------

  void dispose() {
    _reelsSubscription?.cancel();
    _disposeAllControllers();
    super.close();
  }
}
