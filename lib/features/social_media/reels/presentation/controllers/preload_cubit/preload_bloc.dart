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

        // Try to initialize the first video with retry mechanism
        bool firstVideoInitialized = false;
        int retryCount = 0;
        const maxRetries = 3;

        while (!firstVideoInitialized && retryCount < maxRetries) {
          try {
            await initializeControllerAtIndex(0);
            firstVideoInitialized = true;
            log('✅ First video initialized successfully');
          } catch (e) {
            retryCount++;
            log('❌ Failed to initialize first video (attempt $retryCount/$maxRetries): $e');

            if (retryCount >= maxRetries) {
              // If all retries failed, try to initialize the next video
              if (urls.length > 1) {
                log('🔄 All retries failed, trying next video');
                try {
                  await initializeControllerAtIndex(1);
                  emit(state.copyWith(focusedIndex: 1));
                  log('✅ Second video initialized as fallback');
                } catch (e2) {
                  log('❌ Failed to initialize fallback video: $e2');
                }
              }
            } else {
              // Wait before retry
              await Future.delayed(Duration(seconds: retryCount));
            }
          }
        }

        if (firstVideoInitialized) {
          _playControllerAtIndex(0);
        }

        if (urls.length > 1) await initializeControllerAtIndex(1);
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

        // Try to initialize the first video with retry mechanism
        bool firstVideoInitialized = false;
        int retryCount = 0;
        const maxRetries = 3;

        while (!firstVideoInitialized && retryCount < maxRetries) {
          try {
            await initializeControllerAtIndex(0);
            firstVideoInitialized = true;
            log('✅ First video initialized successfully on screen return');
          } catch (e) {
            retryCount++;
            log('❌ Failed to initialize first video on screen return (attempt $retryCount/$maxRetries): $e');

            if (retryCount >= maxRetries) {
              // If all retries failed, try to initialize the next video
              if (state.urls.length > 1) {
                log('🔄 All retries failed on screen return, trying next video');
                try {
                  await initializeControllerAtIndex(1);
                  emit(state.copyWith(focusedIndex: 1));
                  log('✅ Second video initialized as fallback on screen return');
                } catch (e2) {
                  log('❌ Failed to initialize fallback video on screen return: $e2');
                }
              }
            } else {
              // Wait before retry
              await Future.delayed(Duration(seconds: retryCount));
            }
          }
        }

        if (firstVideoInitialized) {
          _playControllerAtIndex(0);
        }

        if (state.urls.length > 1) {
          await initializeControllerAtIndex(1);
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

    // Use the new efficient preloading method
    preloadVideosAroundIndex(index);

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
    initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    _stopControllerAtIndex(index + 1);
    _disposeControllerAtIndex(index + 2);
    _playControllerAtIndex(index);
    if (index == 0) return;
    initializeControllerAtIndex(index - 1);
  }

  Future<void> initializeControllerAtIndex(int index) async {
    if (index < 0 || index >= state.urls.length) return;

    try {
      final String url = state.urls[index];
      final String pathOrUrl = _effectivePathForUrl(url);

      final Uri sourceUri =
          pathOrUrl.startsWith('http') ? pathOrUrl.toUri : Uri.file(pathOrUrl);

      final controller = pathOrUrl.startsWith('http')
          ? VideoPlayerController.networkUrl(sourceUri)
          : VideoPlayerController.file(File(pathOrUrl));

      state.controllers[index] = controller;

      // Add timeout for initialization
      await controller.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          log('❌ Timeout initializing video at index $index');
          throw TimeoutException(
              'Video initialization timeout', const Duration(seconds: 15));
        },
      );

      log('🚀🚀🚀 INITIALIZED $index');
    } catch (e) {
      log('❌ Error initializing video at index $index: $e');

      // Remove failed controller from state
      state.controllers.remove(index);

      // If this is the first video (index 0), try to initialize the next one
      if (index == 0 && state.urls.length > 1) {
        log('🔄 Retrying with next video at index 1');
        await initializeControllerAtIndex(1);
        // Update focused index to the working video
        emit(state.copyWith(focusedIndex: 1));
      }

      // Re-throw to let caller handle the error
      rethrow;
    }
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

  // Handle video loading errors gracefully
  Future<void> _handleVideoLoadError(int index, String error) async {
    log('❌ Video load error at index $index: $error');

    // Remove the failed controller
    state.controllers.remove(index);

    // If this is the current focused video, try to move to the next one
    if (index == state.focusedIndex) {
      if (index + 1 < state.urls.length) {
        log('🔄 Moving to next video due to load error');
        emit(state.copyWith(focusedIndex: index + 1));

        // Try to initialize the next video
        try {
          await initializeControllerAtIndex(index + 1);
          _playControllerAtIndex(index + 1);
        } catch (e) {
          log('❌ Failed to initialize next video after error: $e');
        }
      } else if (index > 0) {
        log('🔄 Moving to previous video due to load error');
        emit(state.copyWith(focusedIndex: index - 1));

        // Try to initialize the previous video
        try {
          await initializeControllerAtIndex(index - 1);
          _playControllerAtIndex(index - 1);
        } catch (e) {
          log('❌ Failed to initialize previous video after error: $e');
        }
      }
    }
  }

  // Check if a video is ready to play
  bool isVideoReady(int index) {
    final controller = state.controllers[index];
    return controller != null && controller.value.isInitialized;
  }

  // Get the loading status for a specific video
  bool isVideoLoading(int index) {
    return !isVideoReady(index) &&
        state.urls.isNotEmpty &&
        index < state.urls.length;
  }

  // Retry loading a specific video
  Future<void> retryVideoLoad(int index) async {
    if (index < 0 || index >= state.urls.length) return;

    log('🔄 Retrying video load for index $index');

    // Remove existing controller if any
    state.controllers.remove(index);

    try {
      await initializeControllerAtIndex(index);
      if (index == state.focusedIndex) {
        _playControllerAtIndex(index);
      }
      log('✅ Video retry successful for index $index');
    } catch (e) {
      log('❌ Video retry failed for index $index: $e');
      // If retry fails, try to move to next available video
      await _handleVideoLoadError(index, 'Retry failed: $e');
    }
  }

  // Preload videos around the current index more efficiently
  Future<void> preloadVideosAroundIndex(int index) async {
    if (state.urls.isEmpty) return;

    final List<int> indicesToPreload = [];

    // Add current index and adjacent indices
    for (int i = index - 1; i <= index + 1; i++) {
      if (i >= 0 &&
          i < state.urls.length &&
          !state.controllers.containsKey(i)) {
        indicesToPreload.add(i);
      }
    }

    // Preload videos in parallel for better performance
    if (indicesToPreload.isNotEmpty) {
      log('🔄 Preloading videos around index $index: $indicesToPreload');

      final futures =
          indicesToPreload.map((i) => initializeControllerAtIndex(i));
      try {
        await Future.wait(futures);
        log('✅ Preloading completed for indices: $indicesToPreload');
      } catch (e) {
        log('❌ Some videos failed to preload: $e');
        // Continue with available videos
      }
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
