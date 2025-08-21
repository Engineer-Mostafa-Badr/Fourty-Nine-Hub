import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../explore_reels_cubit/reel_cubit.dart';
import '../../../../../../main.dart';
import '../../../../../../service_locator/service_locator.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/isolates/video_cache_isolate.dart';
import '../../shared/constants.dart';
import 'preload_state.dart';

class PreloadBloc extends Cubit<PreloadState> {
  PreloadBloc() : super(PreloadState.initial());
  StreamSubscription<ReelsState>? _reelsSubscription;

  // Set the loading state
  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void resetFocusedIndex(int index) {
    emit(state.copyWith(focusedIndex: 0, reloadCounter: 0));
    _disposeControllerAtIndex(index);
  }

  Future<void> getVideosFromApi() async {
    try {
      // Cancel any existing subscription to avoid duplication
      await _reelsSubscription?.cancel();
      _reelsSubscription = null;

      setLoading(true);
      final reelsCubit = serviceLocator<ReelsCubit>();

      Future<void> applyUrlsFromCubit() async {
        final urls =
            reelsCubit.state.globalReels.map((e) => e.videoMedia).toList();
        if (urls.isEmpty) return;

        // Reset controllers
        for (var controller in state.controllers.values) {
          controller.dispose();
        }

        emit(state.copyWith(
          urls: urls,
          controllers: {},
          isLoading: false,
          reloadCounter: state.reloadCounter + 1,
        ));

        await _ensureTripleBufferCached(0);

        await _initializeControllerAtIndex(0);
        _playControllerAtIndex(0);
        if (urls.length > 1) await _initializeControllerAtIndex(1);
      }

      if (reelsCubit.state.globalReels.isNotEmpty) {
        await applyUrlsFromCubit();
      }

      _reelsSubscription = reelsCubit.stream.listen((reelsState) async {
        if (!reelsState.isLoading && reelsState.globalReels.isNotEmpty) {
          // Append any newly added URLs
          final updated =
              reelsState.globalReels.map((e) => e.videoMedia).toList();
          if (updated.length != state.urls.length) {
            emit(state.copyWith(urls: updated));
            // Pre-cache around current focus
            _ensureTripleBufferCached(state.focusedIndex);
            // Ensure next controller prepared
            _initializeControllerAtIndex(state.focusedIndex + 1);
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

  // Add this to PreloadBloc class
  void handleScreenReturn() {
    // Dispose all existing controllers to start fresh
    for (var entry in state.controllers.entries) {
      try {
        entry.value.pause();
        entry.value.dispose();
      } catch (_) {}
    }

    emit(state.copyWith(controllers: {}, focusedIndex: 0, isLoading: true));

    Future.microtask(() async {
      if (state.urls.isNotEmpty) {
        await _ensureTripleBufferCached(0);
        await _initializeControllerAtIndex(0);
        _playControllerAtIndex(0);
        if (state.urls.length > 1) {
          await _initializeControllerAtIndex(1);
        }
        emit(state.copyWith(isLoading: false));
      } else {
        getVideosFromApi();
      }
    });
  }

  // Handle video index change and preload logic
  void onVideoIndexChanged(int index) {
    final reelsCubit = serviceLocator<ReelsCubit>();
    final shouldFetch = index + kPreloadLimit >= state.urls.length;
    if (shouldFetch) {
      // trigger backend fetch through cubit; listener will append
      reelsCubit.fetchReels();
    }

    _ensureTripleBufferCached(index);

    if (index > state.focusedIndex) {
      _playNext(index);
    } else {
      _playPrevious(index);
    }

    emit(state.copyWith(focusedIndex: index));
  }

  // Ensure we have cached files for [index-1, index, index+1]
  Future<void> _ensureTripleBufferCached(int index) async {
    final List<String> toPrefetch = [];
    for (final i in [index - 1, index, index + 1]) {
      if (i < 0 || i >= state.urls.length) continue;
      final url = state.urls[i];
      if (!(state.cachedPaths.containsKey(url))) {
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

  // Private helper methods for managing video player controllers
  void _playNext(int index) {
    _stopControllerAtIndex(index - 1);
    _disposeControllerAtIndex(index - 2);
    _playControllerAtIndex(index);
    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    _stopControllerAtIndex(index + 1);
    _disposeControllerAtIndex(index + 2);
    _playControllerAtIndex(index);
    if (index == 0) return;
    _initializeControllerAtIndex(index - 1);
  }

  Future<void> _initializeControllerAtIndex(int index) async {
    if (index < 0 || index >= state.urls.length) return;
    final String url = state.urls[index];
    final String pathOrUrl = _effectivePathForUrl(url);

    final Uri sourceUri =
        pathOrUrl.startsWith('http') ? pathOrUrl.toUri : Uri.file(pathOrUrl);

    final controller = pathOrUrl.startsWith('http')
        ? VideoPlayerController.networkUrl(sourceUri)
        : VideoPlayerController.file(File(sourceUri.toFilePath()));

    state.controllers[index] = controller;

    await controller.initialize();
    log('🚀🚀🚀 INITIALIZED $index');
  }

  void _playControllerAtIndex(int index) {
    final controller = state.controllers[index];
    controller?.setLooping(true);
    controller?.play();
    log('🚀🚀🚀 PLAYING $index');
  }

  void _stopControllerAtIndex(int index) {
    final controller = state.controllers[index];
    controller?.pause();
    log('🚀🚀🚀 STOPPED $index');
  }

  void _disposeControllerAtIndex(int index) {
    final controller = state.controllers.remove(index);
    controller?.dispose();
    log('🚀🚀🚀 DISPOSED $index');
  }

  void _disposeAllControllers() {
    for (var controller in state.controllers.values) {
      controller.dispose();
    }
  }

  pauseTheVideo() {
    final preloadBloc = navigatorKey.currentContext!.read<PreloadBloc>();
    final currentIndex = preloadBloc.state.focusedIndex;
    if (preloadBloc.state.controllers[currentIndex]?.value.isPlaying ?? false) {
      preloadBloc.state.controllers[currentIndex]?.pause();
    }
  }

  void dispose() {
    _reelsSubscription?.cancel();
    _disposeAllControllers();
    super.close();
  }
}
