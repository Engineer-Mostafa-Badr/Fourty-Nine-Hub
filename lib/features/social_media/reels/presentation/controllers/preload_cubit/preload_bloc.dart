// preload_bloc.dart

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/preload_cubit/preload_events.dart';

import '../../../../../../core/isolates/get_video_isolate.dart';
import '../../shared/constants.dart';
import 'preload_state.dart';
import 'package:video_player/video_player.dart';

class PreloadBloc extends Bloc<PreloadEvent, PreloadState> {
  PreloadBloc() : super(PreloadState.initial()) {
    on<SetLoading>((event, emit) {
      emit(state.copyWith(isLoading: true));
    });

    on<GetVideosFromApiEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        log('event entered');
        final List<String> _urls = await getReelVideos();
        log(_urls.map((e) => e).toString());

        final updatedUrls = List<String>.from(state.urls)..addAll(_urls);
        log('urls  ${state.urls}');

        emit(state.copyWith(
          urls: updatedUrls,
          isLoading: false,
          reloadCounter: state.reloadCounter + 1,
        ));
        await _initializeControllerAtIndex(0);
        _playControllerAtIndex(0);
        await _initializeControllerAtIndex(1);

        log('event exited');
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
        ));
        rethrow;
      }
    });

    on<OnVideoIndexChanged>((event, emit) {
      final shouldFetch = (event.index + kPreloadLimit) % kNextLimit == 0 &&
          state.urls.length == event.index + kPreloadLimit;

      if (shouldFetch) {
        createIsolate(event.index);
      }

      if (event.index > state.focusedIndex) {
        _playNext(event.index);
      } else {
        _playPrevious(event.index);
      }

      emit(state.copyWith(focusedIndex: event.index));
    });

    on<UpdateUrls>((event, emit) {
      final updatedUrls = List<String>.from(state.urls)..addAll(event.urls);

      _initializeControllerAtIndex(state.focusedIndex + 1);
      emit(state.copyWith(
        urls: updatedUrls,
        reloadCounter: state.reloadCounter + 1,
        isLoading: false,
      ));
      log('🚀🚀🚀 NEW VIDEOS ADDED');
    });
  }

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
    _initializeControllerAtIndex(index - 1);
  }

  Future<void> _initializeControllerAtIndex(int index) async {
    final controller =
        VideoPlayerController.networkUrl(state.urls[index].toUri);
    state.controllers[index] = controller;

    await controller.initialize();

    log('🚀🚀🚀 INITIALIZED $index');

    // Emit new state with the updated controller map
    // final updatedControllers = Map<int, VideoPlayerController>.from(state.controllers)
    //   ..[index] = controller;

    // emit(state.copyWith(controllers: updatedControllers));
    log('🚀🚀🚀 EMITTED $index');
  }

  void _playControllerAtIndex(int index) {
    final controller = state.controllers[index];
    controller?.play();
    log('🚀🚀🚀 PLAYING $index');
  }

  void _stopControllerAtIndex(int index) {
    final controller = state.controllers[index];
    controller?.pause();
    controller?.seekTo(Duration.zero);
    log('🚀🚀🚀 STOPPED $index');
  }

  void _disposeControllerAtIndex(int index) {
    final controller = state.controllers.remove(index);
    controller?.dispose();
    log('🚀🚀🚀 DISPOSED $index');

    final updatedControllers =
        Map<int, VideoPlayerController>.from(state.controllers)..remove(index);

    emit(state.copyWith(controllers: updatedControllers));
    log('🚀🚀🚀 EMITTED DISPOSED $index');
  }
}
