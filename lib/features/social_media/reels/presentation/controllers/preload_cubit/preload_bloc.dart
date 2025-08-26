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

        // dispose previous controllers
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

        // Initialize first two controllers from NETWORK (HLS)
        await initializeControllerAtIndex(0, preferNetwork: true, epoch: _focusEpoch);

        if (urls.length > 1) {
          _unawaited(initializeControllerAtIndex(1, preferNetwork: true, epoch: _focusEpoch));
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

            // as new items appear, keep initializing next
            final i = state.focusedIndex;
            _unawaited(initializeControllerAtIndex(i + 1, epoch: _focusEpoch, preferNetwork: true));
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
        // Network-only init
        await initializeControllerAtIndex(0, preferNetwork: true, epoch: _focusEpoch);

        if (state.urls.length > 1) {
          _unawaited(initializeControllerAtIndex(1, preferNetwork: true, epoch: _focusEpoch));
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

  /// Make the focused index ready ASAP (epoch-guarded, network-only).
  Future<void> prioritizedFocusInit(int index, {required int epoch}) async {
    _resetInitQueue();
    await initializeControllerAtIndex(index, preferNetwork: true, epoch: epoch);
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

    // 1) Focus first — epoch guarded
    _unawaited(prioritizedFocusInit(index, epoch: epoch));

    // 2) Housekeeping: pause/dispose neighbors
    if (index > state.focusedIndex) {
      _stopControllerAtIndex(index - 1);
      _disposeControllerAtIndex(index - 2);
    } else {
      _stopControllerAtIndex(index + 1);
      _disposeControllerAtIndex(index + 2);
    }

    // 3) Preload neighbors (network-only)
    _unawaited(preloadVideosAroundIndex(index));

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
      await initializeControllerAtIndex(index, preferNetwork: true, epoch: _focusEpoch);
      log('✅ Video retry successful for index $index');
    } catch (e) {
      log('❌ Video retry failed for index $index: $e');
      await _handleVideoLoadError(index, 'Retry failed: $e');
    }
  }

  // -------------------- Disk hydration / Caching (DISABLED) --------------------

  // Must match your isolate’s naming logic exactly — unused now.
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
    final baseDir = await getTemporaryDirectory();
    final cacheDir = Directory(p.join(baseDir.path, 'reels_video_cache'));
    return p.join(cacheDir.path, _safeFileNameFromUrl(url));
  }

  Future<void> _hydrateCacheFromDisk(List<String> urls) async {
    // caching disabled (no-op)
  }

  Future<void> _ensureCachedFor(int index,
      {Duration timeout = const Duration(milliseconds: 900)}) async {
    // caching disabled (no-op)
  }

  Future<void> _ensureRangeCached(int start, int end) async {
    // caching disabled (no-op)
  }

  Future<void> _ensureTripleBufferCached(int index) async {
    // caching disabled (no-op)
  }

  String _effectivePathForUrl(String url) {
    // Always return the original URL; we are not using file paths.
    return url;
  }

  bool _isNetworkController(VideoPlayerController c) =>
      c.dataSourceType == DataSourceType.network;

  Future<void> _maybeSwapToCached(int index) async {
    // caching disabled (no-op)
  }

  // -------------------- Initialization (serialized, epoch-guarded) --------------------

  Future<void> initializeControllerAtIndex(
    int index, {
    bool preferNetwork = true, // ignored; always network
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
    bool preferNetwork = true, // ignored
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

      // ✅ Always stream from network (HLS)
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));

      // add & emit so UI can build immediately
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

      log('🚀 INITIALIZED (HLS) $index');
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
      log('⚠️ STOP error at $index: $e');
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

  // -------------------- Preloading (sequential, network-only neighbors) --------------------

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
      try {
        await initializeControllerAtIndex(i,
            preferNetwork: true, epoch: _focusEpoch);
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
