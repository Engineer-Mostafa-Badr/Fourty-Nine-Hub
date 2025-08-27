import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../../../../../../service_locator/service_locator.dart';
import '../../shared/constants.dart';
import '../explore_reels_cubit/reel_cubit.dart';
import 'preload_state.dart';

void _unawaited(Future<void> f) {}

class PreloadBloc extends Cubit<PreloadState> {
  PreloadBloc() : super(PreloadState.initial());

  StreamSubscription<ReelsState>? _reelsSubscription;
  Future<void> _initSerial = Future.value();
  int _focusEpoch = 0;

  /// 👇 كام فيديو قبل/بعد الحالي يفضل متخزن
  final int keepAliveWindow = 4;

  bool _isShuttingDown = false;

  // ---------------- Public API ----------------

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void resetFocusedIndex(int index) {
    emit(state.copyWith(focusedIndex: 0, reloadCounter: 0));
    _disposeControllerAtIndex(index);
  }

  Future<void> shutdown() async {
    _isShuttingDown = true;
    _initSerial = Future.value();

    await _reelsSubscription?.cancel();
    _reelsSubscription = null;

    for (final c in state.controllers.values) {
      try {
        if (c.value.isInitialized && c.value.isPlaying) await c.pause();
      } catch (_) {}
      try {
        await c.dispose();
      } catch (_) {}
    }

    emit(state.copyWith(controllers: {}, focusedIndex: 0, isLoading: false));
    _isShuttingDown = false;
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

        _initSerial = Future.value();
        _disposeAllControllers();

        emit(state.copyWith(
          urls: urls,
          isLoading: true,
          reloadCounter: state.reloadCounter + 1,
          focusedIndex: 0,
        ));

        await initializeControllerAtIndex(0, epoch: _focusEpoch);

        // ✅ بعد ما أول فيديو يتحضر، حمّل الجيران
        _unawaited(preloadVideosAroundIndex(0));

        if (urls.length > 1) {
          _unawaited(initializeControllerAtIndex(1, epoch: _focusEpoch));
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
            final i = state.focusedIndex;
            _unawaited(initializeControllerAtIndex(i + 1, epoch: _focusEpoch));
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
    _disposeAllControllers();
    _initSerial = Future.value();
    emit(state.copyWith(controllers: {}, focusedIndex: 0, isLoading: true));

    Future.microtask(() async {
      if (state.urls.isNotEmpty) {
        await initializeControllerAtIndex(0, epoch: _focusEpoch);
        _unawaited(preloadVideosAroundIndex(0));
        emit(state.copyWith(isLoading: false));
      } else {
        getVideosFromApi();
      }
    });
  }

  void onVideoIndexChanged(int index) {
    _focusEpoch++;
    final epoch = _focusEpoch;

    final reelsCubit = serviceLocator<ReelsCubit>();
    if (index + kPreloadLimit >= state.urls.length) {
      reelsCubit.fetchReels();
    }

    _unawaited(prioritizedFocusInit(index, epoch: epoch));

    // ✅ تخلّص من الكنترولرز اللي بعيد عن نافذة keepAliveWindow
    final keys = List<int>.from(state.controllers.keys);
    for (var i in keys) {
      if ((i - index).abs() > keepAliveWindow) {
        _disposeControllerAtIndex(i);
      }
    }

    _unawaited(preloadVideosAroundIndex(index));
    emit(state.copyWith(focusedIndex: index));
  }

  Future<void> prioritizedFocusInit(int index, {required int epoch}) async {
    _initSerial = Future.value();
    await initializeControllerAtIndex(index, epoch: epoch);
  }

  // ---------------- Initialization ----------------

  Future<void> initializeControllerAtIndex(
    int index, {
    int? epoch,
  }) {
    _initSerial = _initSerial.then(
      (_) => _doInitializeControllerAtIndex(index, epoch: epoch),
    );
    return _initSerial;
  }

  Future<void> _doInitializeControllerAtIndex(int index, {int? epoch}) async {
    if (_isShuttingDown || isClosed) return;
    if (index < 0 || index >= state.urls.length) return;
    if (epoch != null && epoch != _focusEpoch) return;

    final existing = state.controllers[index];
    if (existing != null) {
      if (existing.value.isInitialized) return;
      try {
        existing.dispose();
      } catch (_) {}
      state.controllers.remove(index);
      emit(state.copyWith(
        controllers: Map<int, VideoPlayerController>.from(state.controllers),
      ));
    }

    try {
      final url = state.urls[index];
      final effectiveUrl = await _pickLowestVariantIfHls(url);

      final controller =
          VideoPlayerController.networkUrl(Uri.parse(effectiveUrl));
      state.controllers[index] = controller;
      emit(state.copyWith(
        controllers: Map<int, VideoPlayerController>.from(state.controllers),
      ));

      await controller.initialize().timeout(const Duration(seconds: 15));

      // check shutdown/epoch again
      if (_isShuttingDown ||
          isClosed ||
          (epoch != null && epoch != _focusEpoch)) {
        try {
          await controller.pause();
        } catch (_) {}
        try {
          await controller.dispose();
        } catch (_) {}
        state.controllers.remove(index);
        emit(state.copyWith(
          controllers: Map<int, VideoPlayerController>.from(state.controllers),
        ));
        return;
      }

      controller.setLooping(true);
      await controller.seekTo(Duration.zero);
      log('🚀 INITIALIZED $index [$effectiveUrl]');
    } catch (e) {
      log('❌ Init error $index: $e');
    }
  }

  // ---------------- HLS Picker ----------------

  Future<String> _pickLowestVariantIfHls(String url) async {
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

  // ---------------- Helpers ----------------

  void _stopControllerAtIndex(int index) {
    final c = state.controllers[index];
    if (c == null) return;
    try {
      if (c.value.isInitialized && c.value.isPlaying) c.pause();
    } catch (_) {}
  }

  bool _disposeControllerAtIndex(int index, {bool force = false}) {
    // Never dispose the focused controller
    if (index == state.focusedIndex) return false;

    final c = state.controllers[index];
    if (c == null) return false;

    try {
      c.dispose();
    } catch (_) {}
    state.controllers.remove(index);
    emit(state.copyWith(
      controllers: Map<int, VideoPlayerController>.from(state.controllers),
    ));
    return true;
  }

  void _disposeAllControllers() {
    for (var c in state.controllers.values) {
      try {
        c.dispose();
      } catch (_) {}
    }
    emit(state.copyWith(controllers: {}));
  }

  Future<void> preloadVideosAroundIndex(int index) async {
    if (state.urls.isEmpty) return;

    final last = state.urls.length - 1;
    final start = math.max(0, index - keepAliveWindow);
    final end = math.min(last, index + keepAliveWindow);

    final order = <int>[];
    for (int d = 1; d <= keepAliveWindow; d++) {
      final left = index - d;
      final right = index + d;
      if (left >= start && left >= 0) order.add(left);
      if (right <= end && right <= last) order.add(right);
    }

    for (final i in order) {
      if (!isVideoReady(i)) {
        await initializeControllerAtIndex(i, epoch: _focusEpoch);
      }
    }

    _enforceMaxControllers();
  }

  void _enforceMaxControllers([int max = 7]) {
    if (state.controllers.length <= max) return;

    // Sort by distance from focused ASC (nearest first)
    final keysByDistanceAsc = state.controllers.keys.toList()
      ..sort((a, b) => (a - state.focusedIndex)
          .abs()
          .compareTo((b - state.focusedIndex).abs()));

    // Keep the nearest `max` (always include focused if present)
    final keepSet = <int>{};
    for (final k in keysByDistanceAsc) {
      keepSet.add(k);
      if (keepSet.length >= max) break;
    }
    keepSet.add(state.focusedIndex); // ensure focused is always kept

    // Dispose the rest (excluding focused explicitly)
    for (final k in state.controllers.keys.toList()) {
      if (!keepSet.contains(k) && k != state.focusedIndex) {
        _disposeControllerAtIndex(k, force: true);
      }
    }
  }

  // ---------------- Extra APIs for UI ----------------

  bool isVideoReady(int index) =>
      state.controllers[index]?.value.isInitialized ?? false;

  bool isVideoLoading(int index) =>
      !isVideoReady(index) &&
      state.urls.isNotEmpty &&
      index < state.urls.length;

  void pauseCurrent() {
    final i = state.focusedIndex;
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
        log('⚠️ pauseAll error: $e');
      }
    }
  }
}
