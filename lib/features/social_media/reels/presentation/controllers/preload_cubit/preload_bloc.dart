import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../explore_reels_cubit/reel_cubit.dart';
import '../../../../../../main.dart';
import '../../../../../../service_locator/service_locator.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/isolates/get_video_isolate.dart';
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
    print('getVideosFromApi called');
    try {
      // Cancel any existing subscription to avoid duplication
      await _reelsSubscription?.cancel();
      _reelsSubscription = null;

      setLoading(true);
      final reelsCubit = serviceLocator<ReelsCubit>();

      // Check if data is already available in ReelsCubit's state
      if (reelsCubit.state.globalReels.isNotEmpty) {
        print('Reels already available, using existing data');

        // Get videos from existing state
        final List<String> urls = await getReelVideos();

        // Clear existing URLs and controllers to prevent duplicates
        for (var controller in state.controllers.values) {
          controller.dispose();
        }

        // Update state with new URLs
        emit(state.copyWith(
          urls: urls,
          controllers: {},
          isLoading: false,
          reloadCounter: state.reloadCounter + 1,
        ));

        // Initialize first videos
        if (urls.isNotEmpty) {
          await _initializeControllerAtIndex(0);
          _playControllerAtIndex(0);
          if (urls.length > 1) await _initializeControllerAtIndex(1);
        }

        log('Using existing reels data complete');
      } else {
        // No existing data, set up stream subscription to wait for data
        print('No existing reels data, setting up listener');
        _reelsSubscription = reelsCubit.stream.listen((reelsState) async {
          if (!reelsState.isLoading && reelsState.globalReels.isNotEmpty) {
            // Cancel subscription after first valid data
            await _reelsSubscription?.cancel();
            _reelsSubscription = null;

            final List<String> urls = await getReelVideos();
            print('Fetched URLs: ${urls.length}');

            if (urls.isEmpty) {
              setLoading(false);
              return;
            }

            // Update state with new URLs
            emit(state.copyWith(
              urls: urls,
              isLoading: false,
              reloadCounter: state.reloadCounter + 1,
            ));

            // Initialize first videos
            if (urls.isNotEmpty) {
              await _initializeControllerAtIndex(0);
              _playControllerAtIndex(0);
              if (urls.length > 1) await _initializeControllerAtIndex(1);
            }

            log('API fetch complete');
          }
        });

        // Trigger fetch if needed
        if (reelsCubit.state.globalReels.isEmpty) {
          print('Triggering fetchReels()');
          reelsCubit.fetchReels();
        }
      }
    } catch (e) {
      log('Error in getVideosFromApi: $e');
      setLoading(false);
      rethrow;
    }
  }
  // Todo: this is last Fetch videos from the API and initialize controllers for the first videos
  // Future<void> getVideosFromApi() async {
  //   print('getVideosFromApi called');
  //   try {
  //     setLoading(true);
  //     print('Fetching videos from API');
  //     // Future.delayed(const Duration(seconds: 3), () async{

  //     serviceLocator<ReelsCubit>().stream.listen((reelsState) async {
  //       if (!reelsState.isLoading) {
  //         final List<String> urls = await getReelVideos();
  //         print('Fetched URLs: $urls');

  //         final updatedUrls = List<String>.from(state.urls)..addAll(urls);
  //         print('message urls: ${updatedUrls.length}');
  //         if (updatedUrls.isEmpty) {
  //           setLoading(false);
  //           return;
  //         }
  //         emit(state.copyWith(
  //           urls: updatedUrls,
  //           isLoading: false,
  //           reloadCounter: state.reloadCounter + 1,
  //         ));

  //         if (updatedUrls.isNotEmpty) {
  //           await _initializeControllerAtIndex(0);
  //           _playControllerAtIndex(0);
  //           if (updatedUrls.length > 1) await _initializeControllerAtIndex(1);
  //         }

  //         log('API fetch complete');
  //       }
  //     });
  //   } catch (e) {
  //     log('error occurred $e');
  //     setLoading(false);
  //     rethrow;
  //   }
  // }
// Add this to PreloadBloc class
  void handleScreenReturn() {
    print('Handling return to reels screen');

    // Dispose all existing controllers to start fresh
    for (var entry in state.controllers.entries) {
      try {
        entry.value.pause();
        entry.value.dispose();
      } catch (e) {
        print('Error disposing controller: $e');
      }
    }

    // Reset state but keep URLs
    emit(state.copyWith(
        controllers: {}, // Clear all controllers
        focusedIndex: 0, // Reset to first video
        isLoading: true // Show loading while reinitializing
        ));

    // Reinitialize first video explicitly on next frame
    Future.microtask(() async {
      if (state.urls.isNotEmpty) {
        await _initializeControllerAtIndex(0);
        _playControllerAtIndex(0); // Start playing first video

        // Preload second video if available
        if (state.urls.length > 1) {
          await _initializeControllerAtIndex(1);
        }

        emit(state.copyWith(isLoading: false));
      } else {
        // No URLs available, need to fetch them
        getVideosFromApi();
      }
    });
  }

  // Handle video index change and preload logic
  void onVideoIndexChanged(int index) {
    // final shouldFetch = (index + kPreloadLimit) % kNextLimit == 0 &&
    //     state.urls.length == index + kPreloadLimit;
    final shouldFetch = index + kPreloadLimit >= state.urls.length;
    if (shouldFetch) {
      preloadVideos(index);
    }

    if (index > state.focusedIndex) {
      _playNext(index);
    } else {
      _playPrevious(index);
    }

    emit(state.copyWith(focusedIndex: index));
  }

  // Update the list of URLs with new videos
  void updateUrls(List<String> newUrls) {
    final updatedUrls = List<String>.from(state.urls)..addAll(newUrls);

    _initializeControllerAtIndex(state.focusedIndex + 1);
    emit(state.copyWith(
      urls: updatedUrls,
      reloadCounter: state.reloadCounter + 1,
      isLoading: false,
    ));
    log('🚀🚀🚀 NEW VIDEOS ADDED');
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
    final controller =
        VideoPlayerController.networkUrl(state.urls[index].toUri);
    state.controllers[index] = controller;

    await controller.initialize();
    log('🚀🚀🚀 INITIALIZED $index');
  }

  void _playControllerAtIndex(int index) {
    final controller = state.controllers[index];
    controller?.play();
    log('🚀🚀🚀 PLAYING $index');
  }

  void _stopControllerAtIndex(int index) {
    final controller = state.controllers[index];
    controller?.pause();
    // controller?.seekTo(Duration.zero);
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
