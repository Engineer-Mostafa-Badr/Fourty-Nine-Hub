import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  /// how many items to keep around the focused one
  final int keepAliveWindow = 4;

  bool _isShuttingDown = false;

  // ---------------- Public API ----------------

  void setLoading(bool isLoading) => emit(state.copyWith(isLoading: isLoading));

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
        await c.pause();
        await c.setVolume(0.0);
      } catch (_) {}
      try {
        c.dispose();
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
        _unawaited(preloadVideosAroundIndex(0));

        // Let bloc control playback (don’t auto-play in the widget)
        _playOnlyIndex(0);

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
        _playOnlyIndex(0);
        emit(state.copyWith(isLoading: false));
      } else {
        getVideosFromApi();
      }
    });
  }

  /// Call this when the visible page changes (debounced in UI).
  void onVideoIndexChanged(int index) {
    _focusEpoch++;
    final epoch = _focusEpoch;

    final reelsCubit = serviceLocator<ReelsCubit>();
    if (index + kPreloadLimit >= state.urls.length) {
      reelsCubit.fetchReels();
    }

    // ensure focus state is correct ASAP (play focused, mute others)
    _playOnlyIndex(index);

    // heavy work (init + preload) serialized and debounced
    _unawaited(prioritizedFocusInit(index, epoch: epoch));

    // dispose far controllers
    final keys = List<int>.from(state.controllers.keys);
    for (var i in keys) {
      if ((i - index).abs() > keepAliveWindow) {
        _disposeControllerAtIndex(i);
      }
    }

    _unawaited(preloadVideosAroundIndex(index));
    emit(state.copyWith(focusedIndex: index));
  }

  /// Call this immediately on page change (non-debounced) to avoid audio overlap.
  void pauseAllExcept(int index) {
    for (final entry in state.controllers.entries) {
      final k = entry.key;
      final c = entry.value;
      if (k == index) continue;
      try {
        c.pause();
        c.setVolume(0.0);
      } catch (_) {}
    }
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

  bool _bpInitialized(BetterPlayerController c) {
    try {
      return c.isVideoInitialized() ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _doInitializeControllerAtIndex(int index, {int? epoch}) async {
    if (_isShuttingDown || isClosed) return;
    if (index < 0 || index >= state.urls.length) return;
    if (epoch != null && epoch != _focusEpoch) return;

    final existing = state.controllers[index];
    if (existing != null) {
      // ✅ If already initialized, re-use it. Don’t recreate (prevents “reset” flicker).
      if (_bpInitialized(existing)) return;

      // Otherwise dispose broken/uninitialized instance and recreate.
      try {
        existing.dispose();
      } catch (_) {}
      state.controllers.remove(index);
      emit(state.copyWith(
        controllers: Map<int, BetterPlayerController>.from(state.controllers),
      ));
    }

    try {
      final rawUrl = state.urls[index];
      final url = await _pickLowestVideoVariantIfHls(rawUrl);

      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        url,
        // in-memory/network cache only; device persistent cache disabled
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: false,
        ),
        notificationConfiguration: const BetterPlayerNotificationConfiguration(
          showNotification: false,
        ),
        videoFormat: url.toLowerCase().endsWith('.m3u8')
            ? BetterPlayerVideoFormat.hls
            : BetterPlayerVideoFormat.other,
      );

      final controller = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: false, // bloc decides when to play
          looping: true,
          fit: BoxFit.cover,
          showPlaceholderUntilPlay: true,
          placeholder: const ColoredBox(color: Colors.black),
          controlsConfiguration: const BetterPlayerControlsConfiguration(
            showControls: false,
            enableProgressBar: true,
            enableProgressBarDrag: true,
            enablePlayPause: false,
            enableMute: false,
            enableSkips: false,
            enableFullscreen: false,
            enableProgressText: false,
          ),
        ),
        betterPlayerDataSource: dataSource,
      );

      state.controllers[index] = controller;
      emit(state.copyWith(
        controllers: Map<int, BetterPlayerController>.from(state.controllers),
      ));

      // If focus changed while we were initializing, leave it paused & muted.
      if (epoch != null && epoch != _focusEpoch) {
        try {
          await controller.pause();
          await controller.setVolume(0.0);
        } catch (_) {}
        return;
      }

      // Enforce correct audio state for current focus (no auto-play here, bloc controls it)
      if (index == state.focusedIndex) {
        // we'll call _playOnlyIndex from onVideoIndexChanged/getVideosFromApi
      } else {
        try {
          await controller.pause();
          await controller.setVolume(0.0);
        } catch (_) {}
      }

      log('🚀 INITIALIZED $index [$url]');
    } catch (e) {
      log('❌ Init error $index: $e');
    }
  }

  // ---------------- HLS Picker (skip audio-only variants) ----------------

  Future<String> _pickLowestVideoVariantIfHls(String url) async {
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
        if (!l.startsWith('#EXT-X-STREAM-INF:')) continue;

        // require RESOLUTION to avoid audio-only variants
        final hasResolution =
            RegExp(r'RESOLUTION=\d+x\d+', caseSensitive: false).hasMatch(l);
        if (!hasResolution) continue;

        final bwMatch = RegExp(r'BANDWIDTH=(\d+)').firstMatch(l);
        final bw = bwMatch != null ? int.parse(bwMatch.group(1)!) : 999999999;

        final nextLine = (i + 1 < lines.length) ? lines[i + 1].trim() : '';
        if (nextLine.isEmpty || nextLine.startsWith('#')) continue;

        final resolved = Uri.parse(url).resolve(nextLine).toString();
        variants.add({'bw': bw, 'uri': resolved});
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

  void _playOnlyIndex(int index) {
    for (final entry in state.controllers.entries) {
      final k = entry.key;
      final c = entry.value;
      if (k == index) {
        _unawaited(() async {
          try {
            await c.setVolume(1.0);
            await c.play();
          } catch (_) {}
        }());
      } else {
        _unawaited(() async {
          try {
            await c.pause();
            await c.setVolume(0.0);
          } catch (_) {}
        }());
      }
    }
  }

  bool _disposeControllerAtIndex(int index, {bool force = false}) {
    if (!force && index == state.focusedIndex) return false;
    final c = state.controllers[index];
    if (c == null) return false;

    try {
      c.dispose();
    } catch (_) {}
    state.controllers.remove(index);
    emit(state.copyWith(
      controllers: Map<int, BetterPlayerController>.from(state.controllers),
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

  void _enforceMaxControllers([int? hardCap]) {
    // keep: focused ± keepAliveWindow (plus tiny buffer)
    final targetMax = hardCap ?? (math.min(2 * keepAliveWindow + 3, 21));

    if (state.controllers.length <= targetMax) return;

    final keysByDistanceAsc = state.controllers.keys.toList()
      ..sort((a, b) => (a - state.focusedIndex)
          .abs()
          .compareTo((b - state.focusedIndex).abs()));

    final keepSet = <int>{};
    for (final k in keysByDistanceAsc) {
      keepSet.add(k);
      if (keepSet.length >= targetMax) break;
    }
    keepSet.add(state.focusedIndex);

    for (final k in state.controllers.keys.toList()) {
      if (!keepSet.contains(k) && k != state.focusedIndex) {
        _disposeControllerAtIndex(k, force: true);
      }
    }
  }

  // ---------------- Extra APIs for UI ----------------

  bool isVideoReady(int index) {
    final c = state.controllers[index];
    try {
      return c?.isVideoInitialized() ?? false;
    } catch (_) {
      return c != null;
    }
  }

  bool isVideoLoading(int index) =>
      !isVideoReady(index) &&
      state.urls.isNotEmpty &&
      index < state.urls.length;

  void pauseCurrent() {
    final i = state.focusedIndex;
    final c = state.controllers[i];
    if (c == null) return;
    try {
      c.pause();
      c.setVolume(0.0);
      log('⏸️ pauseCurrent: $i');
    } catch (e) {
      log('⚠️ pauseCurrent error: $e');
    }
  }

  void pauseIndex(int index) {
    final c = state.controllers[index];
    if (c == null) return;
    try {
      c.pause();
      c.setVolume(0.0);
      log('⏸️ pauseIndex: $index');
    } catch (e) {
      log('⚠️ pauseIndex error: $e');
    }
  }

  void pauseAll() {
    for (final entry in state.controllers.entries) {
      final i = entry.key;
      final c = entry.value;
      try {
        c.pause();
        c.setVolume(0.0);
        log('⏸️ pauseAll: $i');
      } catch (e) {
        log('⚠️ pauseAll error: $e');
      }
    }
  }
}
