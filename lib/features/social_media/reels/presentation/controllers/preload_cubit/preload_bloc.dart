import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/isolates/get_video_isolate.dart';
import '../../shared/constants.dart';
import 'preload_state.dart';

class PreloadBloc extends Cubit<PreloadState> {
  PreloadBloc() : super(PreloadState.initial());

  // Set the loading state
  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }
  void resetFocusedIndex(int index) {
    emit(state.copyWith(focusedIndex: 0,reloadCounter: 0));
    _disposeControllerAtIndex(index);
  }

  // Fetch videos from the API and initialize controllers for the first videos
  Future<void> getVideosFromApi() async {
    setLoading(true);
    try {
      log('Fetching videos from API');
      final List<String> urls = await getReelVideos();
      log('Fetched URLs: $urls');

      final updatedUrls = List<String>.from(state.urls)..addAll(urls);
      log('message urls: ${updatedUrls.length}');
      emit(state.copyWith(
        urls: updatedUrls,
        isLoading: false,
        reloadCounter: state.reloadCounter + 1,
      ));

      await _initializeControllerAtIndex(0);
      _playControllerAtIndex(0);
      await _initializeControllerAtIndex(1);

      log('API fetch complete');
    } catch (e) {
      log('error occurred $e');
      setLoading(false);
      rethrow;
    }
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
}
