import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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

  /// Serialize controller initializations to avoid MediaCodec contention
  Future<void> _initSerial = Future.value();

  /// Bumps every time focused index changes; used to ignore stale inits.
  int _focusEpoch = 0;

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

        // reset serialized queue so old timeouts don’t block
        _initSerial = Future.value();

        // dispose previous controllers (keep cached files/map)
        if (state.controllers.isNotEmpty) {
          final old = Map<int, VideoPlayerController>.from(state.controllers);
          state.controllers.clear();
          emit(state.copyWith(controllers: {}));
          for (final c in old.values) {
            try {
              c.dispose();
            } catch (_) {}
          }
        }

        emit(state.copyWith(
          urls: urls,
          isLoading: true,
          reloadCounter: state.reloadCounter + 1,
          focusedIndex: 0,
        ));

        // ✅ Hydrate cache map from disk for first few URLs (instant file usage)
        await _hydrateCacheFromDisk(urls.take(5).toList());

        // Pre-cache first 3 without blocking UI
        _unawaited(_ensureRangeCached(0, 4));

        // Initialize first controller USING FILE if present
        await initializeControllerAtIndex(0,
            preferNetwork: false, epoch: _focusEpoch);

        // Initialize second after a short cache wait (still file-first)
        if (urls.length > 1) {
          await _ensureCachedFor(1, timeout: const Duration(milliseconds: 900));
          _unawaited(initializeControllerAtIndex(1,
              preferNetwork: false, epoch: _focusEpoch));
        }

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

            // as new items appear, keep caching ahead of the feed
            final i = state.focusedIndex;
            _unawaited(_ensureRangeCached(i, i + 4)); // small runway
            initializeControllerAtIndex(i + 1, epoch: _focusEpoch);
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
        // ✅ Hydrate from disk for FIRST 5 items
        await _hydrateCacheFromDisk(state.urls.take(5).toList());

        // Pre-cache 0..4 in background
        _unawaited(_ensureRangeCached(0, 4)); // keep

        // file-first init
        await initializeControllerAtIndex(0,
            preferNetwork: false, epoch: _focusEpoch);

        if (state.urls.length > 1) {
          await _ensureCachedFor(1, timeout: const Duration(milliseconds: 900));
          _unawaited(initializeControllerAtIndex(1,
              preferNetwork: false, epoch: _focusEpoch));
        }
        emit(state.copyWith(isLoading: false));
      } else {
        getVideosFromApi();
      }
    });
  }

  // -------------------- Fast-swipe: priority init --------------------

  void _resetInitQueue() {
    _initSerial = Future.value();
  }

  /// Make the focused index ready ASAP (epoch-guarded, cache-first).
  Future<void> prioritizedFocusInit(int index, {required int epoch}) async {
    _resetInitQueue();

    if (index >= 0 && index < state.urls.length) {
      await _hydrateCacheFromDisk([state.urls[index]]);
    }
    try {
      await _ensureCachedFor(index, timeout: const Duration(milliseconds: 600));
    } catch (_) {}
    await initializeControllerAtIndex(index,
        preferNetwork: false, epoch: epoch);
  }

  /// On page change (call this from UI)
  void onVideoIndexChanged(int index) {
    _focusEpoch++; // 👈 bump epoch on every focus change
    final epoch = _focusEpoch; // capture for this navigation

    final reelsCubit = serviceLocator<ReelsCubit>();
    final shouldFetch = index + kPreloadLimit >= state.urls.length;
    if (shouldFetch) {
      reelsCubit.fetchReels();
    }

    // 1) Focus first (cache-first) — epoch guarded
    _unawaited(prioritizedFocusInit(index, epoch: epoch));

    // 2) Triple buffer cache around index, in background
    _unawaited(_ensureTripleBufferCached(index));

    // 3) Housekeeping: pause/dispose neighbors
    if (index > state.focusedIndex) {
      _stopControllerAtIndex(index - 1);
      _disposeControllerAtIndex(index - 2);
    } else {
      _stopControllerAtIndex(index + 1);
      _disposeControllerAtIndex(index + 2);
    }

    // 4) Preload neighbors sequentially after focus
    _unawaited(preloadVideosAroundIndex(index));

    // 5) Cache one more ahead
    final nextIndex = index + 1;
    if (nextIndex < state.urls.length) {
      _unawaited(_ensureRangeCached(nextIndex, nextIndex));
    }

    emit(state.copyWith(focusedIndex: index));
  }

  /// Pause focused and neighbors to free codec resources before init
  void forcePauseAround(int index) {
    _stopControllerAtIndex(state.focusedIndex);
    _stopControllerAtIndex(index - 1);
    _stopControllerAtIndex(index + 1);
  }

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
        controllers: Map<int, VideoPlayerController>.from(state.controllers),
      ));
    }

    try {
      await initializeControllerAtIndex(index,
          preferNetwork: true, epoch: _focusEpoch);
      log('✅ Video retry successful for index $index');
    } catch (e) {
      log('❌ Video retry failed for index $index: $e');
      await _handleVideoLoadError(index, 'Retry failed: $e');
    }
  }

  // -------------------- Disk hydration (cache-first on startup/re-entry) --------------------

  // Must match your isolate’s naming logic exactly
  String _safeFileNameFromUrl(String url) {
    final uri = Uri.tryParse(url);
    final last = (uri?.pathSegments.isNotEmpty ?? false)
        ? uri!.pathSegments.last
        : 'video.mp4';
    final sanitized = last.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final hash = url.hashCode.toUnsigned(20).toRadixString(16);
    final ext =
        p.extension(sanitized).isNotEmpty ? p.extension(sanitized) : '.mp4';
    final base = p.basenameWithoutExtension(sanitized);
    return '${base}_$hash$ext';
  }

  Future<String> _predictCachedPathForUrl(String url) async {
    final baseDir = await getTemporaryDirectory(); // SAME as isolate
    final cacheDir = Directory(p.join(baseDir.path, 'reels_video_cache'));
    return p.join(cacheDir.path, _safeFileNameFromUrl(url));
  }

  Future<void> _hydrateCacheFromDisk(List<String> urls) async {
    if (urls.isEmpty) return;
    final Map<String, String> additions = {};
    for (final url in urls) {
      try {
        final path = await _predictCachedPathForUrl(url);
        if (await File(path).exists()) {
          additions[url] = path;
        }
      } catch (_) {}
    }
    if (additions.isNotEmpty) {
      final newMap = Map<String, String>.from(state.cachedPaths)
        ..addAll(additions);
      emit(state.copyWith(cachedPaths: newMap));
    }
  }

  // -------------------- Caching --------------------

  /// Keep triple buffer cached (index-1..index+1). No eviction.
  Future<void> _ensureTripleBufferCached(int index) async {
    final List<String> toPrefetch = [];

    // cache a 5-wide window: index-2 .. index+2
    for (int i = index - 2; i <= index + 2; i++) {
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

      // Optionally swap non-focused neighbors to cached if they were network
      for (int i = index - 2; i <= index + 2; i++) {
        if (i < 0 || i >= state.urls.length) continue;
        if (i == state.focusedIndex) continue;
        _unawaited(_maybeSwapToCached(i));
      }
    } catch (e) {
      log('Cache isolate error: $e');
    }
  }

  /// Ensure a specific index is cached (short wait). Falls back silently.
  Future<void> _ensureCachedFor(int index,
      {Duration timeout = const Duration(milliseconds: 900)}) async {
    if (index < 0 || index >= state.urls.length) return;
    final url = state.urls[index];
    if (state.cachedPaths.containsKey(url)) return;

    try {
      final result = await cacheVideosInIsolate([url]).timeout(timeout);
      final newMap = Map<String, String>.from(state.cachedPaths)
        ..addAll(result.urlToPath);
      emit(state.copyWith(cachedPaths: newMap));
    } catch (_) {
      // timeout / error — ignore
    }
  }

  /// Batch ensure a range is cached (inclusive). No eviction.
  Future<void> _ensureRangeCached(int start, int end) async {
    final List<String> toPrefetch = [];
    for (int i = start; i <= end && i < state.urls.length; i++) {
      if (i < 0) continue;
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
      log('Cache range error: $e');
    }
  }

  String _effectivePathForUrl(String url) {
    return state.cachedPaths[url] ?? url;
  }

  // -------------------- Optional: swap to cached when safe --------------------

  bool _isNetworkController(VideoPlayerController c) =>
      c.dataSourceType == DataSourceType.network;

  Future<void> _maybeSwapToCached(int index) async {
    if (index < 0 || index >= state.urls.length) return;
    final url = state.urls[index];
    final cached = state.cachedPaths[url];
    if (cached == null) return;

    final current = state.controllers[index];
    if (current == null) return;

    final isPlaying = current.value.isInitialized && current.value.isPlaying;
    if (!_isNetworkController(current) || isPlaying) return;

    try {
      current.pause();
      current.dispose();
      state.controllers.remove(index);
      emit(state.copyWith(
          controllers:
              Map<int, VideoPlayerController>.from(state.controllers)));

      final fileController = VideoPlayerController.file(File(cached));
      state.controllers[index] = fileController;
      emit(state.copyWith(
          controllers:
              Map<int, VideoPlayerController>.from(state.controllers)));

      await fileController.initialize().timeout(const Duration(seconds: 12));
      fileController.setLooping(true);
      await fileController.seekTo(Duration.zero);
      log('🔁 Swapped index $index to cached file');
    } catch (e) {
      log('⚠️ Swap-to-cached failed at $index: $e');
    }
  }

  // -------------------- Initialization (serialized, epoch-guarded) --------------------

  Future<void> initializeControllerAtIndex(
    int index, {
    bool preferNetwork = false,
    int? epoch, // 👈 pass current epoch for stale-guard
  }) {
    _initSerial = _initSerial.then(
      (_) => _doInitializeControllerAtIndex(index,
          preferNetwork: preferNetwork, epoch: epoch),
    );
    return _initSerial;
  }

  Future<void> _doInitializeControllerAtIndex(
    int index, {
    bool preferNetwork = false,
    int? epoch, // 👈 if provided, we’ll ignore stale work
  }) async {
    if (index < 0 || index >= state.urls.length) return;

    // If this init is stale, bail early
    if (epoch != null && epoch != _focusEpoch) return;

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

      final Uri sourceUri = pathOrUrl.startsWith('http')
          ? Uri.parse(pathOrUrl)
          : Uri.file(pathOrUrl);

      // Stale check before allocation
      if (epoch != null && epoch != _focusEpoch) return;

      final controller = pathOrUrl.startsWith('http')
          ? VideoPlayerController.networkUrl(sourceUri)
          : VideoPlayerController.file(File(pathOrUrl));

      // add & emit so UI can build ReelsWidget immediately
      state.controllers[index] = controller;
      emit(state.copyWith(
          controllers:
              Map<int, VideoPlayerController>.from(state.controllers)));

      await controller.initialize().timeout(const Duration(seconds: 15));

      // Final stale check before we touch UI/loop/seek
      if (epoch != null && epoch != _focusEpoch) {
        try {
          controller.dispose();
        } catch (_) {}
        state.controllers.remove(index);
        emit(state.copyWith(
            controllers:
                Map<int, VideoPlayerController>.from(state.controllers)));
        return;
      }

      controller.setLooping(true);
      await controller.seekTo(Duration.zero); // prime first frame

      log('🚀 INITIALIZED (primed) $index [preferNetwork=$preferNetwork][epoch=$epoch]');
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
          await initializeControllerAtIndex(index + 1,
              preferNetwork: true, epoch: _focusEpoch);
        } catch (e) {
          log('❌ Failed to initialize next after error: $e');
        }
      } else if (index > 0) {
        emit(state.copyWith(focusedIndex: index - 1));
        try {
          await initializeControllerAtIndex(index - 1,
              preferNetwork: true, epoch: _focusEpoch);
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

  // -------------------- Preloading (sequential, cache-first for neighbors) --------------------

  Future<void> preloadVideosAroundIndex(int index) async {
    if (state.urls.isEmpty) return;

    final List<int> indicesToPreload = [];
    for (int i = index - 1; i <= index + 1; i++) {
      if (i >= 0 && i < state.urls.length && !isVideoReady(i)) {
        indicesToPreload.add(i);
      }
    }

    for (final i in indicesToPreload) {
      final isFocused = (i == state.focusedIndex);
      if (!isFocused) {
        await _ensureCachedFor(i, timeout: const Duration(milliseconds: 900));
      }
      try {
        await initializeControllerAtIndex(i,
            preferNetwork: isFocused, epoch: _focusEpoch);
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
