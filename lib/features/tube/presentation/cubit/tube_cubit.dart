import 'dart:async';
import 'dart:math' as AndroidImportance;

import 'package:audio_service/audio_service.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' hide Priority;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:video_player/video_player.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/error/failure.dart';
import '../../../../test_noti.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../../domain/usecases/get_all_tube_videos_use_case.dart';
import '../widgets/custom_tube_widget.dart';

part 'tube_state.dart';

/*
class TubeCubit extends Cubit<TubeState> {
  final GetAllTubeVideosUseCase getAllTubeVideosUseCase;

  TubeCubit(this.getAllTubeVideosUseCase) : super(TubeState());

  bool isBackgroundMode = false;
  static BackgroundAudioHandler? _audioHandler;
  static bool _isInitialized = false;

  Future<void> _initializeAudioService() async {
    if (_isInitialized && _audioHandler != null) return;

    try {
      if (AudioService.running) {
        debugPrint("ℹ️ AudioService already running, skipping init");
        return;
      }

      _audioHandler = await AudioService.init(
        builder: () => BackgroundAudioHandler(),
        config:  AudioServiceConfig(
          androidNotificationChannelId: 'com.tube.player.channel.audio',
          androidNotificationChannelName: 'Tube Player',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: false, // change to false for control buttons
          preloadArtwork: false,
        ),
      );

      _isInitialized = true;
      debugPrint("✅ AudioService initialized successfully");
    } catch (e, stackTrace) {
      debugPrint("❌ Error initializing AudioService: $e");
      debugPrintStack(stackTrace: stackTrace);
      _isInitialized = false;
      _audioHandler = null;
      rethrow;
    }
  }

  Future<void> toggleBackgroundMode(bool enabled, String videoUrl) async {
    try {
      if (enabled) {
        await _startBackgroundPlayback(videoUrl);
      } else {
        await _stopBackgroundPlayback();
      }

      emit(state.copyWith(isBackgroundMode: enabled));
    } catch (e, stackTrace) {
      debugPrint('Error in toggleBackgroundMode: $e');
      debugPrintStack(stackTrace: stackTrace);

      // Fallback
      await state.videoPlayerController?.play();
      emit(state.copyWith(isBackgroundMode: false));
    }
  }

  Future<void> _startBackgroundPlayback(String videoUrl) async {
    // أوقف الفيديو العادي
    await state.videoPlayerController?.pause();

    // Initialize audio service
    await _initializeAudioService();

    if (_audioHandler == null) {
      throw Exception("AudioHandler not initialized");
    }

    // Set up media item
    final mediaItem = MediaItem(
      id: videoUrl,
      title: state.currentVideo?.title ?? "Tube Video",
      album: "Tube Player",
      artUri: state.currentVideo?.thumbnail != null
          ? Uri.parse(state.currentVideo!.thumbnail!)
          : null,
    );

    try {
      // Use the custom method to update media item
      await _audioHandler!.updateMediaItem(mediaItem);
      await _audioHandler!.play();

      debugPrint("🎵 Background playback started");
    } catch (e) {
      debugPrint("❌ Error starting background playback: $e");
      rethrow;
    }
  }

  Future<void> _stopBackgroundPlayback() async {
    if (_audioHandler != null) {
      try {
        await _audioHandler!.stop();
        debugPrint("🎵 Background playback stopped");
      } catch (e) {
        debugPrint("❌ Error stopping background playback: $e");
      }
    }

    // ارجع شغل الفيديو العادي
    await state.videoPlayerController?.play();
  }

  // باقي الكود كما هو...
  void updateVideoController(VideoPlayerController newController) {
    emit(state.copyWith(videoPlayerController: newController));
  }

  // 📌 Pagination Fields
  List<GetAllTubeVideosEntity> allTubeVideos = [];
  bool hasMoreTubeVideos = true;
  int currentPageTubeVideos = 1;
  bool isTubeVideosLoadingMore = false;
  bool isTubeVideosInitialLoading = false;
  final int pageSize = 10;

  // ⚡ Initial Load
  Future<void> loadInitialAllTubeVideos() async {
    debugPrint("🚀 CUBIT: loadInitialAllTubeVideos()");
    isTubeVideosInitialLoading = true;
    allTubeVideos.clear();
    currentPageTubeVideos = 1;
    hasMoreTubeVideos = true;

    emit(state.copyWith(
      status: StateStatus.loading,
      getAllTubeVideosData: [],
    ));

    await getAllTubeVideos();
    isTubeVideosInitialLoading = false;
  }

  // ⚡ Load More (Pagination)
  Future<void> getAllTubeVideos() async {
    if (!hasMoreTubeVideos || isTubeVideosLoadingMore) return;

    isTubeVideosLoadingMore = true;
    if (currentPageTubeVideos == 1) {
      emit(state.copyWith(status: StateStatus.loading));
    }

    final response = await getAllTubeVideosUseCase(
      GetAllTubeVideosParams(page: currentPageTubeVideos, limit: pageSize),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to load tube videos: $failure");
        isTubeVideosLoadingMore = false;
        emit(state.copyWith(status: StateStatus.error, failure: failure));
      },
          (data) {
        debugPrint("✅ Success: Received ${data.length} videos");

        if (currentPageTubeVideos == 1) {
          allTubeVideos = List.from(data);
        } else {
          allTubeVideos.addAll(data);
        }

        if (data.isEmpty) {
          hasMoreTubeVideos = false;
        } else {
          currentPageTubeVideos++;
        }

        isTubeVideosLoadingMore = false;
        emit(state.copyWith(
          status: StateStatus.success,
          getAllTubeVideosData: allTubeVideos,
        ));
      },
    );
  }

  // 🎬 Video Player Logic
  bool _isInitializing = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  Future<void> _initializeController(GetAllTubeVideosEntity video) async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      final videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(video.videoUrl!),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true, // غير لـ true علشان يشتغل في الخلفية
          allowBackgroundPlayback: true, // غير لـ true
        ),
      );

      await videoPlayerController.initialize();
      videoPlayerController.setLooping(false);
      videoPlayerController.setVolume(1.0);

      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey.withOpacity(0.3),
          bufferedColor: Colors.white.withOpacity(0.5),
        ),
        placeholder: Image.network(
          video.thumbnail!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                Text(errorMessage, style: const TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () {
                    if (_retryCount < _maxRetries) {
                      _retryCount++;
                      _disposeControllers();
                      playVideo(video);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        customControls: CustomVideoControls(
          onPrevious: playPreviousVideo,
          onNext: playNextVideo,
          onDoubleTapLeft: () {
            seekBackward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showBackwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showBackwardIndicator) {
                  emit(state.copyWith(showBackwardIndicator: false));
                }
              });
            });
          },
          onDoubleTapRight: () {
            seekForward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showForwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showForwardIndicator) {
                  emit(state.copyWith(showForwardIndicator: false));
                }
              });
            });
          },
          hasPrevious: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) > 0,
          hasNext: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) < allTubeVideos.length - 1,
          videoUrl: video.videoUrl!,
        ),
        allowedScreenSleep: false,
        showOptions: true,
        allowPlaybackSpeedChanging: true,
      );

      videoPlayerController.addListener(() {
        if (videoPlayerController.value.isPlaying != state.isPlaying) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            emit(state.copyWith(isPlaying: videoPlayerController.value.isPlaying));
          });
        }
      });

      _retryCount = 0;
      emit(state.copyWith(
        currentVideo: video,
        videoPlayerController: videoPlayerController,
        chewieController: chewieController,
        isPlaying: true,
        isMinimized: false,
        isLoading: false,
      ));
    } catch (error) {
      debugPrint('Error initializing video player: $error');
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 1));
        await _initializeController(video);
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } finally {
      _isInitializing = false;
    }
  }


  void playVideo(GetAllTubeVideosEntity video) {
    if (state.currentVideo?.id == video.id && state.chewieController != null && state.videoPlayerController != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false, isLoading: false));
      });
      return;
    }

    // Emit loading state before disposing controllers
    emit(state.copyWith(
      isLoading: true,
      chewieController: null,
      videoPlayerController: null,
    ));

    // Dispose old controllers
    _disposeControllers();

    // Schedule initialization in the next frame to ensure UI updates
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeController(video);
    });
  }

  void togglePlayPause() {
    if (state.chewieController != null && state.videoPlayerController != null && !state.isLoading) {
      if (state.isPlaying) {
        state.chewieController!.pause();
      } else {
        state.chewieController!.play();
      }
      emit(state.copyWith(isPlaying: !state.isPlaying));

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (state.videoPlayerController != null) {
          emit(state.copyWith(isPlaying: state.videoPlayerController!.value.isPlaying));
        }
      });
    }
  }

  void minimizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: true));
      });
    }
  }

  void maximizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false));
      });
    }
  }

  void closePlayer() {
    _disposeControllers();
    emit(state.copyWith(
      clearCurrentVideo: true,
      clearControllers: true,
      isMinimized: false,
      isPlaying: false,
      isLoading: false,
    ));
    _retryCount = 0;
  }

  void playNextVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex < allTubeVideos.length - 1) {
      playVideo(allTubeVideos[currentIndex + 1]);
    }
  }

  void playPreviousVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex > 0) {
      playVideo(allTubeVideos[currentIndex - 1]);
    }
  }

  void seekForward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final duration = state.videoPlayerController!.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 20);
      if (newPosition < duration) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(duration);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void seekBackward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 20);
      if (newPosition > Duration.zero) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(Duration.zero);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void _disposeControllers() {
    try {
      if (state.chewieController != null) {
        state.chewieController!.pause();
        state.chewieController!.dispose();
      }
      if (state.videoPlayerController != null && state.videoPlayerController!.value.isInitialized) {
        state.videoPlayerController!.pause();
        state.videoPlayerController!.dispose();
      }
    } catch (e) {
      debugPrint('Error disposing controllers: $e');
    }
  }

  @override
  Future<void> close() async {
    // لا تقم بتعطيل الـ AudioHandler علشان ممكن يبقى شغال في الخلفية
    _disposeControllers();
    super.close();
  }
}
class BackgroundAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  MediaItem? _currentMediaItem;

  BackgroundAudioHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    // When the player state changes, update the notification
    _player.playerStateStream.listen((state) {
      playbackState.add(playbackState.value.copyWith(
        playing: state.playing,
        processingState: _transformProcessingState(state.processingState),
      ));
    });
  }

  AudioProcessingState _transformProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: _transformProcessingState(_player.processingState),
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  // ✅ updateMediaItem sets up the notification
  Future<void> updateMediaItem(MediaItem item) async {
    _currentMediaItem = item;

    // Add to the handler's mediaItem stream (not the local variable)
    this.mediaItem.add(item);

    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(item.id)),
      );
      debugPrint("✅ Audio source set successfully");
    } catch (e) {
      debugPrint("❌ Error setting audio source: $e");
      rethrow;
    }
  }

  // ✅ Control methods update the notification state automatically
  @override
  Future<void> play() async {
    await _player.play();
    playbackState.add(playbackState.value.copyWith(playing: true));
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    playbackState.add(playbackState.value.copyWith(playing: false));
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    mediaItem.add(null);
    playbackState.add(playbackState.value.copyWith(playing: false));
  }
}

*/




class TubeCubit extends Cubit<TubeState> {
  final GetAllTubeVideosUseCase getAllTubeVideosUseCase;

  TubeCubit(this.getAllTubeVideosUseCase) : super(TubeState());

  // 📌 Pagination Fields
  List<GetAllTubeVideosEntity> allTubeVideos = [];
  bool hasMoreTubeVideos = true;
  int currentPageTubeVideos = 1;
  bool isTubeVideosLoadingMore = false;
  bool isTubeVideosInitialLoading = false;
  final int pageSize = 10;

  // ⚡ Initial Load
  Future<void> loadInitialAllTubeVideos() async {
    debugPrint("🚀 CUBIT: loadInitialAllTubeVideos()");
    isTubeVideosInitialLoading = true;
    allTubeVideos.clear();
    currentPageTubeVideos = 1;
    hasMoreTubeVideos = true;

    emit(state.copyWith(
      status: StateStatus.loading,
      getAllTubeVideosData: [],
    ));

    await getAllTubeVideos();
    isTubeVideosInitialLoading = false;
  }

  // ⚡ Load More (Pagination)
  Future<void> getAllTubeVideos() async {
    if (!hasMoreTubeVideos || isTubeVideosLoadingMore) return;

    isTubeVideosLoadingMore = true;
    if (currentPageTubeVideos == 1) {
      emit(state.copyWith(status: StateStatus.loading));
    }

    final response = await getAllTubeVideosUseCase(
      GetAllTubeVideosParams(page: currentPageTubeVideos, limit: pageSize),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to load tube videos: $failure");
        isTubeVideosLoadingMore = false;
        emit(state.copyWith(status: StateStatus.error, failure: failure));
      },
          (data) {
        debugPrint("✅ Success: Received ${data.length} videos");

        if (currentPageTubeVideos == 1) {
          allTubeVideos = List.from(data);
        } else {
          allTubeVideos.addAll(data);
        }

        if (data.isEmpty) {
          hasMoreTubeVideos = false;
        } else {
          currentPageTubeVideos++;
        }

        isTubeVideosLoadingMore = false;
        emit(state.copyWith(
          status: StateStatus.success,
          getAllTubeVideosData: allTubeVideos,
        ));
      },
    );
  }

  // 🎬 Video Player Logic
  bool _isInitializing = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  Future<void> _initializeController(GetAllTubeVideosEntity video) async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      // final videoPlayerController = VideoPlayerController.networkUrl(
      //   Uri.parse(GetAllTubeVideosEntity.videoUrl!),
      //   videoPlayerOptions: VideoPlayerOptions(
      //     mixWithOthers: false,
      //     allowBackgroundPlayback: false,
      //   ),
      // );
      final videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(video.videoUrl!),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      await videoPlayerController.initialize();
      videoPlayerController.setLooping(false);
      videoPlayerController.setVolume(1.0);

      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey.withOpacity(0.3),
          bufferedColor: Colors.white.withOpacity(0.5),
        ),
        placeholder: Image.network(
          video.thumbnail!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                Text(errorMessage, style: const TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () {
                    if (_retryCount < _maxRetries) {
                      _retryCount++;
                      _disposeControllers();
                      playVideo(video);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        customControls: CustomVideoControls(
          onPrevious: playPreviousVideo,
          onNext: playNextVideo,
          onDoubleTapLeft: () {
            seekBackward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showBackwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showBackwardIndicator) {
                  emit(state.copyWith(showBackwardIndicator: false));
                }
              });
            });
          },
          onDoubleTapRight: () {
            seekForward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showForwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showForwardIndicator) {
                  emit(state.copyWith(showForwardIndicator: false));
                }
              });
            });
          },
          hasPrevious: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) > 0,
          hasNext: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) < allTubeVideos.length - 1,
          videoUrl: video.videoUrl!,
        ),
        allowedScreenSleep: false,
        showOptions: true,
        allowPlaybackSpeedChanging: true,
      );

      videoPlayerController.addListener(() {
        if (videoPlayerController.value.isPlaying != state.isPlaying) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            emit(state.copyWith(isPlaying: videoPlayerController.value.isPlaying));
          });
        }
      });

      _retryCount = 0;
      emit(state.copyWith(
        currentVideo: video,
        videoPlayerController: videoPlayerController,
        chewieController: chewieController,
        isPlaying: true,
        isMinimized: false,
        isLoading: false,
      ));
    } catch (error) {
      debugPrint('Error initializing video player: $error');
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 1));
        await _initializeController(video);
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } finally {
      _isInitializing = false;
    }
  }

  void playVideo(GetAllTubeVideosEntity video) {
    final wasMinimized = state.isMinimized;

    if (state.currentVideo?.id == video.id && state.chewieController != null && state.videoPlayerController != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false, isLoading: false));
      });
      return;
    }

    // Emit loading state before disposing controllers
    emit(state.copyWith(
      isLoading: true,
      chewieController: null,
      videoPlayerController: null,
    ));

    // Dispose old controllers
    _disposeControllers();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeController(video).then((_) {
        // لو الفيديو كان صغير قبل، خلي MiniPlayer يرجع
        if (wasMinimized) {
          emit(state.copyWith(isMinimized: true));
        }
      });
    });
  }

  // void playVideo(GetAllTubeVideosEntity video) {
  //   if (state.currentVideo?.id == video.id && state.chewieController != null && state.videoPlayerController != null) {
  //     SchedulerBinding.instance.addPostFrameCallback((_) {
  //       emit(state.copyWith(isMinimized: false, isLoading: false));
  //     });
  //     return;
  //   }
  //
  //   // Emit loading state before disposing controllers
  //   emit(state.copyWith(
  //     isLoading: true,
  //     chewieController: null,
  //     videoPlayerController: null,
  //   ));
  //
  //   // Dispose old controllers
  //   _disposeControllers();
  //
  //   // Schedule initialization in the next frame to ensure UI updates
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //     _initializeController(video);
  //   });
  // }

  void togglePlayPause() {
    if (state.chewieController != null && state.videoPlayerController != null && !state.isLoading) {
      if (state.isPlaying) {
        state.chewieController!.pause();
      } else {
        state.chewieController!.play();
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isPlaying: state.videoPlayerController!.value.isPlaying));
      });
    }
  }

  void minimizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: true));
      });
    }
  }

  void maximizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false));
      });
    }
  }

  void closePlayer() {
    _disposeControllers();
    emit(state.copyWith(
      clearCurrentVideo: true,
      clearControllers: true,
      isMinimized: false,
      isPlaying: false,
      isLoading: false,
    ));
    _retryCount = 0;
  }




  void playNextVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex < allTubeVideos.length - 1) {
      playVideo(allTubeVideos[currentIndex + 1]);
    }
  }

  void playPreviousVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex > 0) {
      playVideo(allTubeVideos[currentIndex - 1]);
    }
  }

  void seekForward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final duration = state.videoPlayerController!.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 20);
      if (newPosition < duration) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(duration);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void seekBackward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 20);
      if (newPosition > Duration.zero) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(Duration.zero);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void _disposeControllers() {
    try {
      if (state.chewieController != null) {
        state.chewieController!.pause();
        state.chewieController!.dispose();
      }
      if (state.videoPlayerController != null && state.videoPlayerController!.value.isInitialized) {
        state.videoPlayerController!.pause();
        state.videoPlayerController!.dispose();
      }
    } catch (e) {
      debugPrint('Error disposing controllers: $e');
    }
  }

  @override
  Future<void> close() async {
    _disposeControllers();
    super.close();
  }
}



/*
class TubeCubit extends Cubit<TubeState> {
  TubeCubit(

  ) : super(TubeState());

  // 📌 Your Cubit fields
  List<GetAllTubeVideosEntity > findData = [];

  bool hasMoreFindData = true; // whether API has more pages
  int currentPageFindData = 1; // current page index
  bool isFindDataLoadingMore = false; // prevents multiple parallel API calls
  bool isFindDataInitialLoading = false; // separate flag for first load

  final int pageSize = 5; // how many items per page
// 📌 Initial load (with user info)
  void loadInitialFindData(
      BuildContext context, {
        required String gender,
        required String userId,
        required bool isLoggedIn,
      }) async {
    print("🚀 CUBIT: loadInitialFindData() called with gender=$gender, userId=$userId, isLoggedIn=$isLoggedIn");

    selectedGender = gender;
    isFindDataInitialLoading = true;
    findData.clear();
    currentPageFindData = 1;
    hasMoreFindData = true;

    emit(state.copyWith(
      status: FindStates.loading,
      findData: [],
    ));

    await getFindData(context, userId: userId, isLoggedIn: isLoggedIn);

    isFindDataInitialLoading = false;
  }
  Future<void> getFindData(
      BuildContext context, {
        String? userId,
        bool? isLoggedIn,
      }) async {
    print("🚀 CUBIT: getFindData() called");
    print("📊 State: hasMore=$hasMoreFindData, isLoading=$isFindDataLoadingMore, page=$currentPageFindData, gender=$selectedGender");

    if (!hasMoreFindData || isFindDataLoadingMore) {
      print("⚠️ Skipping API call - no more data or already loading");
      return;
    }

    isFindDataLoadingMore = true;

    if (currentPageFindData == 1) {
      emit(state.copyWith(status: FindStates.loading));
    }

    final response = await getFindUseCase(
      GetFindParams(
        page: currentPageFindData,
        limit: pageSize,
        gender: selectedGender ?? "",
        userId: userId ?? "",
        isLoggedIn: isLoggedIn ?? false,
      ),
    );

    response.fold(
          (failure) {
        print("❌ API call failed: $failure");
        isFindDataLoadingMore = false;

        emit(state.copyWith(
          failure: failure,
          status: FindStates.failure,
        ));
      },
          (data) {
        print("✅ API call success, received ${data.length} items");

        if (currentPageFindData == 1) {
          findData = List.from(data);
        } else {
          findData.addAll(data);
        }

        if (data.isEmpty) {
          hasMoreFindData = false;
          print("🛑 No more pages available (empty response)");
        } else {
          currentPageFindData++;
          print("➡️ Next page: $currentPageFindData (received ${data.length} items)");
        }

        isFindDataLoadingMore = false;

        emit(state.copyWith(
          status: FindStates.success,
          findData: findData,
        ));

        print("📦 Total items in findData: ${findData.length}");
      },
    );
  }

  int _retryCount = 0;
  static const int _maxRetries = 3;
  bool _isInitializing = false; // Prevent concurrent initializations



  Future<void> _initializeController(Video video) async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      final videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(video.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      await videoPlayerController.initialize();
      videoPlayerController.setLooping(false);
      videoPlayerController.setVolume(1.0);

      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey.withOpacity(0.3),
          bufferedColor: Colors.white.withOpacity(0.5),
        ),
        placeholder: Image.network(
          video.thumbnail,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                Text(errorMessage, style: const TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () {
                    if (_retryCount < _maxRetries) {
                      _retryCount++;
                      _disposeControllers();
                      playVideo(video);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        customControls: CustomVideoControls(
          onPrevious: playPreviousVideo,
          onNext: playNextVideo,
          onDoubleTapLeft: () {
            seekBackward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showBackwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showBackwardIndicator) {
                  emit(state.copyWith(showBackwardIndicator: false));
                }
              });
            });
          },
          onDoubleTapRight: () {
            seekForward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showForwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showForwardIndicator) {
                  emit(state.copyWith(showForwardIndicator: false));
                }
              });
            });
          },
          hasPrevious: () => allVideos.indexWhere((v) => v.id == state.GetAllTubeVideosEntity ?.id) > 0,
          hasNext: () => allVideos.indexWhere((v) => v.id == state.GetAllTubeVideosEntity ?.id) < allVideos.length - 1,
          videoUrl: video.videoUrl,
        ),
        allowedScreenSleep: false,
        showOptions: true,
        allowPlaybackSpeedChanging: true,
      );

      videoPlayerController.addListener(() {
        if (videoPlayerController.value.isPlaying != state.isPlaying) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            emit(state.copyWith(isPlaying: videoPlayerController.value.isPlaying));
          });
        }
      });

      _retryCount = 0;
      emit(state.copyWith(
        GetAllTubeVideosEntity : video,
        videoPlayerController: videoPlayerController,
        chewieController: chewieController,
        isPlaying: true,
        isMinimized: false,
        isLoading: false,
      ));
    } catch (error) {
      debugPrint('Error initializing video player: $error');
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 1));
        await _initializeController(video);
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } finally {
      _isInitializing = false;
    }
  }

  void playVideo(Video video) {
    if (state.GetAllTubeVideosEntity ?.id == video.id && state.chewieController != null && state.videoPlayerController != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false, isLoading: false));
      });
      return;
    }

    // Emit loading state before disposing controllers
    emit(state.copyWith(
      isLoading: true,
      chewieController: null,
      videoPlayerController: null,
    ));

    // Dispose old controllers
    _disposeControllers();

    // Schedule initialization in the next frame to ensure UI updates
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeController(video);
    });
  }

  void togglePlayPause() {
    if (state.chewieController != null && state.videoPlayerController != null && !state.isLoading) {
      if (state.isPlaying) {
        state.chewieController!.pause();
      } else {
        state.chewieController!.play();
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isPlaying: state.videoPlayerController!.value.isPlaying));
      });
    }
  }

  void minimizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: true));
      });
    }
  }

  void maximizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false));
      });
    }
  }

  void closePlayer() {
    _disposeControllers();
    emit(VideoPlayerState(
      GetAllTubeVideosEntity : null,
      videoPlayerController: null,
      chewieController: null,
      isMinimized: false,
      isPlaying: false,
      isLoading: false,
    ));
    _retryCount = 0;
  }

  void playNextVideo() {
    if (state.GetAllTubeVideosEntity  == null || state.isLoading) return;
    final currentIndex = allVideos.indexWhere((v) => v.id == state.GetAllTubeVideosEntity !.id);
    if (currentIndex < allVideos.length - 1) {
      playVideo(allVideos[currentIndex + 1]);
    }
  }

  void playPreviousVideo() {
    if (state.GetAllTubeVideosEntity  == null || state.isLoading) return;
    final currentIndex = allVideos.indexWhere((v) => v.id == state.GetAllTubeVideosEntity !.id);
    if (currentIndex > 0) {
      playVideo(allVideos[currentIndex - 1]);
    }
  }

  void seekForward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final duration = state.videoPlayerController!.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 20);
      if (newPosition < duration) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(duration);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void seekBackward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 20);
      if (newPosition > Duration.zero) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(Duration.zero);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }



  void _disposeControllers() {
    try {
      if (state.chewieController != null) {
        state.chewieController!.pause();
        state.chewieController!.dispose();
      }
      if (state.videoPlayerController != null && state.videoPlayerController!.value.isInitialized) {
        state.videoPlayerController!.pause();
        state.videoPlayerController!.dispose();
      }
    } catch (e) {
      debugPrint('Error disposing controllers: $e');
    }
  }

  @override
  Future<void> close() async {
    _disposeControllers();
    super.close();
  }

}
*/

/*
class TubeCubit extends Cubit<TubeState> {
  final GetAllTubeVideosUseCase getAllTubeVideosUseCase;

  TubeCubit(this.getAllTubeVideosUseCase) : super(TubeState());

  bool isBackgroundMode = false;
  final AudioPlayer backgroundPlayer = AudioPlayer();

  Future<void> toggleBackgroundMode(bool enabled, String videoUrl) async {
    isBackgroundMode = enabled;

    if (enabled) {
      // أوقف تشغيل الفيديو
      state.videoPlayerController?.pause();

      try {
        // إعداد مصدر الصوت مع بيانات الإشعار
        await backgroundPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(videoUrl),
            tag: MediaItem(
              id: videoUrl,
              album: "Tube Player",
              title: state.currentVideo?.title ?? "Now Playing",
            ),
          ),
        );

        await backgroundPlayer.play();
        debugPrint("🎵 Background audio started");
      } catch (e, st) {
        debugPrint("❌ Error starting background audio: $e");
        debugPrintStack(stackTrace: st);
      }
    } else {
      await backgroundPlayer.stop();
      state.videoPlayerController?.play();
    }

    emit(state.copyWith(isBackgroundMode: isBackgroundMode));
  }


  void updateVideoController(VideoPlayerController newController) {
    emit(state.copyWith(videoPlayerController: newController));
  }

  // 📌 Pagination Fields
  List<GetAllTubeVideosEntity> allTubeVideos = [];
  bool hasMoreTubeVideos = true;
  int currentPageTubeVideos = 1;
  bool isTubeVideosLoadingMore = false;
  bool isTubeVideosInitialLoading = false;
  final int pageSize = 10;

  // ⚡ Initial Load
  Future<void> loadInitialAllTubeVideos() async {
    debugPrint("🚀 CUBIT: loadInitialAllTubeVideos()");
    isTubeVideosInitialLoading = true;
    allTubeVideos.clear();
    currentPageTubeVideos = 1;
    hasMoreTubeVideos = true;

    emit(state.copyWith(
      status: StateStatus.loading,
      getAllTubeVideosData: [],
    ));

    await getAllTubeVideos();
    isTubeVideosInitialLoading = false;
  }

  // ⚡ Load More (Pagination)
  Future<void> getAllTubeVideos() async {
    if (!hasMoreTubeVideos || isTubeVideosLoadingMore) return;

    isTubeVideosLoadingMore = true;
    if (currentPageTubeVideos == 1) {
      emit(state.copyWith(status: StateStatus.loading));
    }

    final response = await getAllTubeVideosUseCase(
      GetAllTubeVideosParams(page: currentPageTubeVideos, limit: pageSize),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to load tube videos: $failure");
        isTubeVideosLoadingMore = false;
        emit(state.copyWith(status: StateStatus.error, failure: failure));
      },
          (data) {
        debugPrint("✅ Success: Received ${data.length} videos");

        if (currentPageTubeVideos == 1) {
          allTubeVideos = List.from(data);
        } else {
          allTubeVideos.addAll(data);
        }

        if (data.isEmpty) {
          hasMoreTubeVideos = false;
        } else {
          currentPageTubeVideos++;
        }

        isTubeVideosLoadingMore = false;
        emit(state.copyWith(
          status: StateStatus.success,
          getAllTubeVideosData: allTubeVideos,
        ));
      },
    );
  }

  // 🎬 Video Player Logic
  bool _isInitializing = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  Future<void> _initializeController(GetAllTubeVideosEntity video) async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      // final videoPlayerController = VideoPlayerController.networkUrl(
      //   Uri.parse(GetAllTubeVideosEntity.videoUrl!),
      //   videoPlayerOptions: VideoPlayerOptions(
      //     mixWithOthers: false,
      //     allowBackgroundPlayback: false,
      //   ),
      // );
      final videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(video.videoUrl!),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      await videoPlayerController.initialize();
      videoPlayerController.setLooping(false);
      videoPlayerController.setVolume(1.0);

      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey.withOpacity(0.3),
          bufferedColor: Colors.white.withOpacity(0.5),
        ),
        placeholder: Image.network(
          video.thumbnail!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                Text(errorMessage, style: const TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () {
                    if (_retryCount < _maxRetries) {
                      _retryCount++;
                      _disposeControllers();
                      playVideo(video);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        customControls: CustomVideoControls(
          onPrevious: playPreviousVideo,
          onNext: playNextVideo,
          onDoubleTapLeft: () {
            seekBackward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showBackwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showBackwardIndicator) {
                  emit(state.copyWith(showBackwardIndicator: false));
                }
              });
            });
          },
          onDoubleTapRight: () {
            seekForward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showForwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showForwardIndicator) {
                  emit(state.copyWith(showForwardIndicator: false));
                }
              });
            });
          },
          hasPrevious: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) > 0,
          hasNext: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) < allTubeVideos.length - 1,
          videoUrl: video.videoUrl!,
        ),
        allowedScreenSleep: false,
        showOptions: true,
        allowPlaybackSpeedChanging: true,
      );

      videoPlayerController.addListener(() {
        if (videoPlayerController.value.isPlaying != state.isPlaying) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            emit(state.copyWith(isPlaying: videoPlayerController.value.isPlaying));
          });
        }
      });

      _retryCount = 0;
      emit(state.copyWith(
        currentVideo: video,
        videoPlayerController: videoPlayerController,
        chewieController: chewieController,
        isPlaying: true,
        isMinimized: false,
        isLoading: false,
      ));
    } catch (error) {
      debugPrint('Error initializing video player: $error');
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 1));
        await _initializeController(video);
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } finally {
      _isInitializing = false;
    }
  }


  void playVideo(GetAllTubeVideosEntity video) {
    if (state.currentVideo?.id == video.id && state.chewieController != null && state.videoPlayerController != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false, isLoading: false));
      });
      return;
    }

    // Emit loading state before disposing controllers
    emit(state.copyWith(
      isLoading: true,
      chewieController: null,
      videoPlayerController: null,
    ));

    // Dispose old controllers
    _disposeControllers();

    // Schedule initialization in the next frame to ensure UI updates
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeController(video);
    });
  }
  void togglePlayPause() {
    if (state.chewieController != null && state.videoPlayerController != null && !state.isLoading) {
      if (state.isPlaying) {
        state.chewieController!.pause();
      } else {
        state.chewieController!.play();
      }
      // ✅ Ensure state is updated immediately
      emit(state.copyWith(isPlaying: !state.isPlaying));

      // Also update from controller value as backup
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (state.videoPlayerController != null) {
          emit(state.copyWith(isPlaying: state.videoPlayerController!.value.isPlaying));
        }
      });
    }
  }
  void togglePlayPause1() {
    if (state.chewieController != null && state.videoPlayerController != null && !state.isLoading) {
      if (state.isPlaying) {
        state.chewieController!.pause();
      } else {
        state.chewieController!.play();
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isPlaying: state.videoPlayerController!.value.isPlaying));
      });
    }
  }

  void minimizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: true));
      });
    }
  }

  void maximizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false));
      });
    }
  }

  void closePlayer() {
    _disposeControllers();
    emit(state.copyWith(
      clearCurrentVideo: true,
      clearControllers: true,
      isMinimized: false,
      isPlaying: false,
      isLoading: false,
    ));
    _retryCount = 0;
  }




  void playNextVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex < allTubeVideos.length - 1) {
      playVideo(allTubeVideos[currentIndex + 1]);
    }
  }

  void playPreviousVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex > 0) {
      playVideo(allTubeVideos[currentIndex - 1]);
    }
  }

  void seekForward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final duration = state.videoPlayerController!.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 20);
      if (newPosition < duration) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(duration);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void seekBackward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 20);
      if (newPosition > Duration.zero) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(Duration.zero);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void _disposeControllers() {
    try {
      if (state.chewieController != null) {
        state.chewieController!.pause();
        state.chewieController!.dispose();
      }
      if (state.videoPlayerController != null && state.videoPlayerController!.value.isInitialized) {
        state.videoPlayerController!.pause();
        state.videoPlayerController!.dispose();
      }
    } catch (e) {
      debugPrint('Error disposing controllers: $e');
    }
  }

  @override
  Future<void> close() async {
    _disposeControllers();
    super.close();
  }
}

*/

//
// class TubeCubit extends Cubit<TubeState> {
//   final GetAllTubeVideosUseCase getAllTubeVideosUseCase;
//   final NotificationService _notificationService = NotificationService();
//   StreamSubscription<String>? _notificationSubscription;
//
//   TubeCubit(this.getAllTubeVideosUseCase) : super(TubeState()) {
//     _initializeNotificationListener();
//   }
//
//   bool isBackgroundMode = false;
//   final AudioPlayer _backgroundPlayer = AudioPlayer();
//   StreamSubscription? _playerStateSubscription;
//
// // في TubeCubit - استبدل الميثودز دي بالنسخة المحدثة
//
//   void _initializeNotificationListener() {
//     _notificationSubscription = NotificationService.actionStream.listen(
//           (action) {
//         debugPrint("🎯 Received notification action: $action");
//         _handleNotificationAction(action);
//       },
//       onError: (error) {
//         debugPrint("❌ Error in notification stream: $error");
//       },
//       cancelOnError: false, // Keep listening even if there's an error
//     );
//   }
//
//   Future<void> _handleNotificationAction(String action) async {
//     debugPrint("🔔 Processing notification action: $action");
//
//     try {
//       switch (action) {
//         case 'pause':
//           debugPrint("⏸️ Pause button clicked");
//           if (_backgroundPlayer.playing) {
//             await _backgroundPlayer.pause();
//             await _showNotification(
//               state.currentVideo?.title ?? "Tube Player",
//               "Paused - Tap to resume",
//               paused: true,
//             );
//           }
//           break;
//
//         case 'play':
//           debugPrint("▶️ Play button clicked");
//           if (!_backgroundPlayer.playing) {
//             await _backgroundPlayer.play();
//             await _showNotification(
//               state.currentVideo?.title ?? "Tube Player",
//               "Playing in background",
//               paused: false,
//             );
//           }
//           break;
//
//         case 'stop':
//           debugPrint("⏹️ Stop button clicked");
//           await toggleBackgroundMode(false, '');
//           break;
//
//         case 'tap':
//           debugPrint("👆 Notification tapped - toggling play/pause");
//           if (_backgroundPlayer.playing) {
//             await _backgroundPlayer.pause();
//             await _showNotification(
//               state.currentVideo?.title ?? "Tube Player",
//               "Paused - Tap to resume",
//               paused: true,
//             );
//           } else {
//             await _backgroundPlayer.play();
//             await _showNotification(
//               state.currentVideo?.title ?? "Tube Player",
//               "Playing in background",
//               paused: false,
//             );
//           }
//           break;
//
//         default:
//           debugPrint("⚠️ Unknown notification action: $action");
//       }
//     } catch (e, stackTrace) {
//       debugPrint("❌ Error handling notification action '$action': $e");
//       debugPrintStack(stackTrace: stackTrace);
//     }
//   }
//
//   Future<void> _showNotification(String title, String message, {bool paused = false}) async {
//     try {
//       final actions = paused
//           ? [
//         const AndroidNotificationAction(
//           'play',
//           'Play',
//           showsUserInterface: false,
//           cancelNotification: false,
//         ),
//         const AndroidNotificationAction(
//           'stop',
//           'Stop',
//           showsUserInterface: false,
//           cancelNotification: true,
//         ),
//       ]
//           : [
//         const AndroidNotificationAction(
//           'pause',
//           'Pause',
//           showsUserInterface: false,
//           cancelNotification: false,
//         ),
//         const AndroidNotificationAction(
//           'stop',
//           'Stop',
//           showsUserInterface: false,
//           cancelNotification: true,
//         ),
//       ];
//
//       await _notificationService.showNotification(
//         id: 1,
//         title: title,
//         body: message,
//         actions: actions,
//       );
//
//       debugPrint("✅ Notification shown: $title - $message");
//     } catch (e) {
//       debugPrint("❌ Error showing notification: $e");
//     }
//   }
//
//   @override
//   Future<void> close() async {
//     debugPrint("🔄 Closing TubeCubit...");
//
//     await _notificationSubscription?.cancel();
//     await _playerStateSubscription?.cancel();
//
//     // Stop background player and hide notification
//     if (_backgroundPlayer.playing) {
//       await _backgroundPlayer.stop();
//     }
//     await _backgroundPlayer.dispose();
//
//     await _hideNotification();
//     _notificationService.dispose();
//     _disposeControllers();
//
//     await super.close();
//     debugPrint("✅ TubeCubit closed");
//   }
//
//   Future<void> _initializeNotifications() async {
//     await _notificationService.initialize();
//   }
//
//
//   Future<void> _hideNotification() async {
//     await _notificationService.cancelNotification(1);
//   }
//
//   Future<void> toggleBackgroundMode(bool enabled, String videoUrl) async {
//     try {
//       if (enabled) {
//         await _startBackgroundPlayback(videoUrl);
//       } else {
//         await _stopBackgroundPlayback();
//       }
//
//       isBackgroundMode = enabled;
//       emit(state.copyWith(isBackgroundMode: enabled));
//     } catch (e, stackTrace) {
//       debugPrint('Error in toggleBackgroundMode: $e');
//       debugPrintStack(stackTrace: stackTrace);
//
//       // Fallback
//       await _resumeVideoIfNeeded();
//       isBackgroundMode = false;
//       emit(state.copyWith(isBackgroundMode: false));
//     }
//   }
//
//   Future<void> _startBackgroundPlayback(String videoUrl) async {
//     // Initialize notifications first
//     await _initializeNotifications();
//
//     // أوقف الفيديو العادي أولاً
//     await _pauseVideoForBackground();
//
//     try {
//       // Stop any existing playback
//       await _backgroundPlayer.stop();
//
//       // Configure audio session for background playback
//       await _backgroundPlayer.setAudioSource(
//         AudioSource.uri(Uri.parse(videoUrl)),
//       );
//
//       // Listen to player state changes
//       _playerStateSubscription?.cancel();
//       _playerStateSubscription = _backgroundPlayer.playerStateStream.listen((playerState) {
//         if (playerState.processingState == ProcessingState.completed) {
//           _hideNotification();
//           // Auto-stop background mode when video completes
//           if (isBackgroundMode) {
//             toggleBackgroundMode(false, '');
//           }
//         }
//       });
//
//       // Show notification
//       await _showNotification(
//         state.currentVideo?.title ?? "Tube Player",
//         "Playing in background",
//         paused: false,
//       );
//
//       // Start playback
//       await _backgroundPlayer.play();
//
//       debugPrint("🎵 Background playback started with notification");
//
//     } catch (e) {
//       debugPrint("❌ Error starting background playback: $e");
//       await _hideNotification();
//       await _resumeVideoIfNeeded();
//       rethrow;
//     }
//   }
//
//   Future<void> _stopBackgroundPlayback() async {
//     try {
//       await _backgroundPlayer.stop();
//       await _hideNotification();
//       await _playerStateSubscription?.cancel();
//       debugPrint("🎵 Background playback stopped");
//     } catch (e) {
//       debugPrint("❌ Error stopping background playback: $e");
//     }
//
//     // ارجع شغل الفيديو العادي
//     await _resumeVideoIfNeeded();
//   }
//
//   Future<void> _pauseVideoForBackground() async {
//     if (state.videoPlayerController?.value.isInitialized == true &&
//         state.videoPlayerController!.value.isPlaying) {
//       await state.videoPlayerController?.pause();
//       debugPrint("⏸️ Paused video for background playback");
//     }
//   }
//
//   Future<void> _resumeVideoIfNeeded() async {
//     if (state.videoPlayerController?.value.isInitialized == true &&
//         !state.videoPlayerController!.value.isPlaying &&
//         !isBackgroundMode) {
//       await state.videoPlayerController?.play();
//       debugPrint("▶️ Resumed video after background playback");
//     }
//   }
//
//   // Method to handle video play/pause from UI
//   Future<void> toggleVideoPlayPause() async {
//     if (state.chewieController != null && state.videoPlayerController != null && !state.isLoading) {
//       if (state.isPlaying) {
//         await state.chewieController!.pause();
//         // If background mode is active, also pause background audio
//         if (isBackgroundMode && _backgroundPlayer.playing) {
//           await _backgroundPlayer.pause();
//           await _showNotification(
//             state.currentVideo?.title ?? "Tube Player",
//             "Paused - Tap to resume",
//             paused: true,
//           );
//         }
//       } else {
//         await state.chewieController!.play();
//         // If background mode is active, also play background audio
//         if (isBackgroundMode && !_backgroundPlayer.playing) {
//           await _backgroundPlayer.play();
//           await _showNotification(
//             state.currentVideo?.title ?? "Tube Player",
//             "Playing in background",
//             paused: false,
//           );
//         }
//       }
//
//       emit(state.copyWith(isPlaying: !state.isPlaying));
//
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         if (state.videoPlayerController != null) {
//           emit(state.copyWith(isPlaying: state.videoPlayerController!.value.isPlaying));
//         }
//       });
//     }
//   }
//
//   // باقي الكود كما هو...
//   void updateVideoController(VideoPlayerController newController) {
//     emit(state.copyWith(videoPlayerController: newController));
//   }
//
//   // 📌 Pagination Fields
//   List<GetAllTubeVideosEntity> allTubeVideos = [];
//   bool hasMoreTubeVideos = true;
//   int currentPageTubeVideos = 1;
//   bool isTubeVideosLoadingMore = false;
//   bool isTubeVideosInitialLoading = false;
//   final int pageSize = 10;
//
//   // ⚡ Initial Load
//   Future<void> loadInitialAllTubeVideos() async {
//     debugPrint("🚀 CUBIT: loadInitialAllTubeVideos()");
//     isTubeVideosInitialLoading = true;
//     allTubeVideos.clear();
//     currentPageTubeVideos = 1;
//     hasMoreTubeVideos = true;
//
//     emit(state.copyWith(
//       status: StateStatus.loading,
//       getAllTubeVideosData: [],
//     ));
//
//     await getAllTubeVideos();
//     isTubeVideosInitialLoading = false;
//   }
//
//   // ⚡ Load More (Pagination)
//   Future<void> getAllTubeVideos() async {
//     if (!hasMoreTubeVideos || isTubeVideosLoadingMore) return;
//
//     isTubeVideosLoadingMore = true;
//     if (currentPageTubeVideos == 1) {
//       emit(state.copyWith(status: StateStatus.loading));
//     }
//
//     final response = await getAllTubeVideosUseCase(
//       GetAllTubeVideosParams(page: currentPageTubeVideos, limit: pageSize),
//     );
//
//     response.fold(
//           (failure) {
//         debugPrint("❌ Failed to load tube videos: $failure");
//         isTubeVideosLoadingMore = false;
//         emit(state.copyWith(status: StateStatus.error, failure: failure));
//       },
//           (data) {
//         debugPrint("✅ Success: Received ${data.length} videos");
//
//         if (currentPageTubeVideos == 1) {
//           allTubeVideos = List.from(data);
//         } else {
//           allTubeVideos.addAll(data);
//         }
//
//         if (data.isEmpty) {
//           hasMoreTubeVideos = false;
//         } else {
//           currentPageTubeVideos++;
//         }
//
//         isTubeVideosLoadingMore = false;
//         emit(state.copyWith(
//           status: StateStatus.success,
//           getAllTubeVideosData: allTubeVideos,
//         ));
//       },
//     );
//   }
//
//   // 🎬 Video Player Logic
//   bool _isInitializing = false;
//   int _retryCount = 0;
//   static const int _maxRetries = 3;
//
//   Future<void> _initializeController(GetAllTubeVideosEntity video) async {
//     if (_isInitializing) return;
//     _isInitializing = true;
//
//     try {
//       final videoPlayerController = VideoPlayerController.networkUrl(
//         Uri.parse(video.videoUrl!),
//         videoPlayerOptions: VideoPlayerOptions(
//           mixWithOthers: true,
//           allowBackgroundPlayback: true,
//         ),
//       );
//
//       await videoPlayerController.initialize();
//       videoPlayerController.setLooping(false);
//       videoPlayerController.setVolume(1.0);
//
//       final chewieController = ChewieController(
//         videoPlayerController: videoPlayerController,
//         autoPlay: true,
//         looping: false,
//         allowFullScreen: true,
//         allowMuting: true,
//         showControls: true,
//         materialProgressColors: ChewieProgressColors(
//           playedColor: Colors.red,
//           handleColor: Colors.red,
//           backgroundColor: Colors.grey.withOpacity(0.3),
//           bufferedColor: Colors.white.withOpacity(0.5),
//         ),
//         placeholder: Image.network(
//           video.thumbnail!,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
//         ),
//         errorBuilder: (context, errorMessage) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error, color: Colors.white, size: 50),
//                 const SizedBox(height: 10),
//                 Text(errorMessage, style: const TextStyle(color: Colors.white)),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_retryCount < _maxRetries) {
//                       _retryCount++;
//                       _disposeControllers();
//                       playVideo(video);
//                     }
//                   },
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         },
//         customControls: CustomVideoControls(
//           onPrevious: playPreviousVideo,
//           onNext: playNextVideo,
//           onDoubleTapLeft: () {
//             seekBackward20Seconds();
//             SchedulerBinding.instance.addPostFrameCallback((_) {
//               emit(state.copyWith(showBackwardIndicator: true));
//               Future.delayed(const Duration(milliseconds: 1000), () {
//                 if (state.showBackwardIndicator) {
//                   emit(state.copyWith(showBackwardIndicator: false));
//                 }
//               });
//             });
//           },
//           onDoubleTapRight: () {
//             seekForward20Seconds();
//             SchedulerBinding.instance.addPostFrameCallback((_) {
//               emit(state.copyWith(showForwardIndicator: true));
//               Future.delayed(const Duration(milliseconds: 1000), () {
//                 if (state.showForwardIndicator) {
//                   emit(state.copyWith(showForwardIndicator: false));
//                 }
//               });
//             });
//           },
//           hasPrevious: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) > 0,
//           hasNext: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) < allTubeVideos.length - 1,
//           videoUrl: video.videoUrl!,
//         ),
//         allowedScreenSleep: false,
//         showOptions: true,
//         allowPlaybackSpeedChanging: true,
//       );
//
//       videoPlayerController.addListener(() {
//         if (videoPlayerController.value.isPlaying != state.isPlaying) {
//           SchedulerBinding.instance.addPostFrameCallback((_) {
//             emit(state.copyWith(isPlaying: videoPlayerController.value.isPlaying));
//           });
//         }
//       });
//
//       _retryCount = 0;
//       emit(state.copyWith(
//         currentVideo: video,
//         videoPlayerController: videoPlayerController,
//         chewieController: chewieController,
//         isPlaying: true,
//         isMinimized: false,
//         isLoading: false,
//       ));
//     } catch (error) {
//       debugPrint('Error initializing video player: $error');
//       if (_retryCount < _maxRetries) {
//         _retryCount++;
//         await Future.delayed(const Duration(seconds: 1));
//         await _initializeController(video);
//       } else {
//         emit(state.copyWith(isLoading: false));
//       }
//     } finally {
//       _isInitializing = false;
//     }
//   }
//
//   void playVideo(GetAllTubeVideosEntity video) {
//     if (state.currentVideo?.id == video.id && state.chewieController != null && state.videoPlayerController != null) {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         emit(state.copyWith(isMinimized: false, isLoading: false));
//       });
//       return;
//     }
//
//     emit(state.copyWith(
//       isLoading: true,
//       chewieController: null,
//       videoPlayerController: null,
//     ));
//
//     _disposeControllers();
//
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       _initializeController(video);
//     });
//   }
//
//   void minimizePlayer() {
//     if (state.chewieController != null && !state.isLoading) {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         emit(state.copyWith(isMinimized: true));
//       });
//     }
//   }
//
//   void maximizePlayer() {
//     if (state.chewieController != null && !state.isLoading) {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         emit(state.copyWith(isMinimized: false));
//       });
//     }
//   }
//
//   void closePlayer() {
//     // Stop background playback when closing player
//     if (isBackgroundMode) {
//       toggleBackgroundMode(false, '');
//     }
//     _disposeControllers();
//     emit(state.copyWith(
//       clearCurrentVideo: true,
//       clearControllers: true,
//       isMinimized: false,
//       isPlaying: false,
//       isLoading: false,
//     ));
//     _retryCount = 0;
//   }
//
//   void playNextVideo() {
//     if (state.currentVideo == null || state.isLoading) return;
//     final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
//     if (currentIndex < allTubeVideos.length - 1) {
//       playVideo(allTubeVideos[currentIndex + 1]);
//     }
//   }
//
//   void playPreviousVideo() {
//     if (state.currentVideo == null || state.isLoading) return;
//     final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
//     if (currentIndex > 0) {
//       playVideo(allTubeVideos[currentIndex - 1]);
//     }
//   }
//
//   void seekForward20Seconds() {
//     if (state.videoPlayerController != null && !state.isLoading) {
//       final currentPosition = state.videoPlayerController!.value.position;
//       final duration = state.videoPlayerController!.value.duration;
//       final newPosition = currentPosition + const Duration(seconds: 20);
//       if (newPosition < duration) {
//         state.videoPlayerController!.seekTo(newPosition);
//       } else {
//         state.videoPlayerController!.seekTo(duration);
//       }
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         emit(state.copyWith());
//       });
//     }
//   }
//
//   void seekBackward20Seconds() {
//     if (state.videoPlayerController != null && !state.isLoading) {
//       final currentPosition = state.videoPlayerController!.value.position;
//       final newPosition = currentPosition - const Duration(seconds: 20);
//       if (newPosition > Duration.zero) {
//         state.videoPlayerController!.seekTo(newPosition);
//       } else {
//         state.videoPlayerController!.seekTo(Duration.zero);
//       }
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         emit(state.copyWith());
//       });
//     }
//   }
//
//   void _disposeControllers() {
//     try {
//       if (state.chewieController != null) {
//         state.chewieController!.pause();
//         state.chewieController!.dispose();
//       }
//       if (state.videoPlayerController != null && state.videoPlayerController!.value.isInitialized) {
//         state.videoPlayerController!.pause();
//         state.videoPlayerController!.dispose();
//       }
//     } catch (e) {
//       debugPrint('Error disposing controllers: $e');
//     }
//   }
//
//   // Method to handle app background/foreground transitions
//   Future<void> handleAppPaused() async {
//     if (isBackgroundMode && _backgroundPlayer.playing) {
//       debugPrint("📱 App paused - background audio continues");
//     }
//   }
//
//   Future<void> handleAppResumed() async {
//     if (isBackgroundMode) {
//       debugPrint("📱 App resumed - background audio is active");
//     }
//   }
// }

/*
/// work with background but lag
class TubeCubit extends Cubit<TubeState> {
  final GetAllTubeVideosUseCase getAllTubeVideosUseCase;

  TubeCubit(this.getAllTubeVideosUseCase) : super(TubeState());

  bool isBackgroundMode = false;
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  StreamSubscription? _playerStateSubscription;

  @override
  Future<void> close() async {
    await _playerStateSubscription?.cancel();
    await _backgroundPlayer.dispose();
    await _hideNotification();
    _disposeControllers();
    super.close();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> _showNotification(String title, String message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'tube_player_channel',
      'Tube Player Background',
      channelDescription: 'Plays tube videos in background',
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      playSound: false, // مهم علشان مايتشغلش صوت مع الإشعار
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      actions: [
        AndroidNotificationAction('pause', 'Pause'),
        AndroidNotificationAction('stop', 'Stop'),
      ],
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      1,
      title,
      message,
      details,
    );
  }

  Future<void> _hideNotification() async {
    await _notifications.cancel(1);
  }

  Future<void> _setupNotificationActions() async {
    // Handle notification actions
    _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        switch (response.actionId) {
          case 'pause':
            await _backgroundPlayer.pause();
            await _showNotification(
              state.currentVideo?.title ?? "Tube Player",
              "Paused",
            );
            break;
          case 'stop':
            await toggleBackgroundMode(false, '');
            break;
        }
      },
    );
  }

  Future<void> toggleBackgroundMode(bool enabled, String videoUrl) async {
    try {
      if (enabled) {
        await _startBackgroundPlayback(videoUrl);
      } else {
        await _stopBackgroundPlayback();
      }

      emit(state.copyWith(isBackgroundMode: enabled));
    } catch (e, stackTrace) {
      debugPrint('Error in toggleBackgroundMode: $e');
      debugPrintStack(stackTrace: stackTrace);

      // Fallback
      await state.videoPlayerController?.play();
      emit(state.copyWith(isBackgroundMode: false));
    }
  }

  Future<void> _startBackgroundPlayback(String videoUrl) async {
    // Initialize notifications first
    await _initializeNotifications();
    await _setupNotificationActions();

    // أوقف الفيديو العادي أولاً
    if (state.videoPlayerController?.value.isPlaying == true) {
      await state.videoPlayerController?.pause();
    }

    try {
      // Configure audio session for background playback
      await _backgroundPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(videoUrl)),
      );

      // Listen to player state changes
      _playerStateSubscription?.cancel();
      _playerStateSubscription = _backgroundPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _hideNotification();
        }
      });

      // Show notification
      await _showNotification(
        state.currentVideo?.title ?? "Tube Player",
        "Playing in background",
      );

      // Start playback
      await _backgroundPlayer.play();

      debugPrint("🎵 Background playback started with notification");

    } catch (e) {
      debugPrint("❌ Error starting background playback: $e");
      await _hideNotification();
      rethrow;
    }
  }

  Future<void> _stopBackgroundPlayback() async {
    try {
      await _backgroundPlayer.stop();
      await _hideNotification();
      await _playerStateSubscription?.cancel();
      debugPrint("🎵 Background playback stopped");
    } catch (e) {
      debugPrint("❌ Error stopping background playback: $e");
    }

    // ارجع شغل الفيديو العادي فقط إذا كان مش متوقف
    if (state.videoPlayerController?.value.isInitialized == true &&
        !state.videoPlayerController!.value.isPlaying) {
      await state.videoPlayerController?.play();
    }
  }

  // إصلاح مشكلة التشغيل المزدوج - أضف هذه الـ methods الجديدة
  Future<void> pauseVideoForBackground() async {
    if (state.videoPlayerController?.value.isPlaying == true) {
      await state.videoPlayerController?.pause();
    }
  }

  Future<void> resumeVideoFromBackground() async {
    if (state.videoPlayerController?.value.isInitialized == true &&
        !state.videoPlayerController!.value.isPlaying &&
        !isBackgroundMode) {
      await state.videoPlayerController?.play();
    }
  }

  // عدل الـ toggleBackgroundMode علشان تستخدم الـ methods الجديدة
  Future<void> toggleBackgroundModeFixed(bool enabled, String videoUrl) async {
    try {
      if (enabled) {
        await pauseVideoForBackground(); // أوقف الفيديو أولاً
        await _startBackgroundPlayback(videoUrl);
      } else {
        await _stopBackgroundPlayback();
        await resumeVideoFromBackground(); // شغل الفيديو بعد ما توقف الخلفية
      }

      emit(state.copyWith(isBackgroundMode: enabled));
    } catch (e, stackTrace) {
      debugPrint('Error in toggleBackgroundMode: $e');
      debugPrintStack(stackTrace: stackTrace);

      // Fallback
      await resumeVideoFromBackground();
      emit(state.copyWith(isBackgroundMode: false));
    }
  }

  // باقي الكود كما هو مع تعديل بسيط في الـ _initializeController
  void updateVideoController(VideoPlayerController newController) {
    emit(state.copyWith(videoPlayerController: newController));
  }

  // 📌 Pagination Fields
  List<GetAllTubeVideosEntity> allTubeVideos = [];
  bool hasMoreTubeVideos = true;
  int currentPageTubeVideos = 1;
  bool isTubeVideosLoadingMore = false;
  bool isTubeVideosInitialLoading = false;
  final int pageSize = 10;

  // ⚡ Initial Load
  Future<void> loadInitialAllTubeVideos() async {
    debugPrint("🚀 CUBIT: loadInitialAllTubeVideos()");
    isTubeVideosInitialLoading = true;
    allTubeVideos.clear();
    currentPageTubeVideos = 1;
    hasMoreTubeVideos = true;

    emit(state.copyWith(
      status: StateStatus.loading,
      getAllTubeVideosData: [],
    ));

    await getAllTubeVideos();
    isTubeVideosInitialLoading = false;
  }

  // ⚡ Load More (Pagination)
  Future<void> getAllTubeVideos() async {
    if (!hasMoreTubeVideos || isTubeVideosLoadingMore) return;

    isTubeVideosLoadingMore = true;
    if (currentPageTubeVideos == 1) {
      emit(state.copyWith(status: StateStatus.loading));
    }

    final response = await getAllTubeVideosUseCase(
      GetAllTubeVideosParams(page: currentPageTubeVideos, limit: pageSize),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to load tube videos: $failure");
        isTubeVideosLoadingMore = false;
        emit(state.copyWith(status: StateStatus.error, failure: failure));
      },
          (data) {
        debugPrint("✅ Success: Received ${data.length} videos");

        if (currentPageTubeVideos == 1) {
          allTubeVideos = List.from(data);
        } else {
          allTubeVideos.addAll(data);
        }

        if (data.isEmpty) {
          hasMoreTubeVideos = false;
        } else {
          currentPageTubeVideos++;
        }

        isTubeVideosLoadingMore = false;
        emit(state.copyWith(
          status: StateStatus.success,
          getAllTubeVideosData: allTubeVideos,
        ));
      },
    );
  }

  // 🎬 Video Player Logic
  bool _isInitializing = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  Future<void> _initializeController(GetAllTubeVideosEntity video) async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      final videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(video.videoUrl!),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: true,
        ),
      );

      await videoPlayerController.initialize();
      videoPlayerController.setLooping(false);
      videoPlayerController.setVolume(1.0);

      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey.withOpacity(0.3),
          bufferedColor: Colors.white.withOpacity(0.5),
        ),
        placeholder: Image.network(
          video.thumbnail!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                Text(errorMessage, style: const TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () {
                    if (_retryCount < _maxRetries) {
                      _retryCount++;
                      _disposeControllers();
                      playVideo(video);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        customControls: CustomVideoControls(
          onPrevious: playPreviousVideo,
          onNext: playNextVideo,
          onDoubleTapLeft: () {
            seekBackward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showBackwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showBackwardIndicator) {
                  emit(state.copyWith(showBackwardIndicator: false));
                }
              });
            });
          },
          onDoubleTapRight: () {
            seekForward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showForwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showForwardIndicator) {
                  emit(state.copyWith(showForwardIndicator: false));
                }
              });
            });
          },
          hasPrevious: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) > 0,
          hasNext: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) < allTubeVideos.length - 1,
          videoUrl: video.videoUrl!,
        ),
        allowedScreenSleep: false,
        showOptions: true,
        allowPlaybackSpeedChanging: true,
      );

      videoPlayerController.addListener(() {
        if (videoPlayerController.value.isPlaying != state.isPlaying) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            emit(state.copyWith(isPlaying: videoPlayerController.value.isPlaying));
          });
        }
      });

      _retryCount = 0;
      emit(state.copyWith(
        currentVideo: video,
        videoPlayerController: videoPlayerController,
        chewieController: chewieController,
        isPlaying: true,
        isMinimized: false,
        isLoading: false,
      ));
    } catch (error) {
      debugPrint('Error initializing video player: $error');
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 1));
        await _initializeController(video);
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } finally {
      _isInitializing = false;
    }
  }

  void playVideo(GetAllTubeVideosEntity video) {
    if (state.currentVideo?.id == video.id && state.chewieController != null && state.videoPlayerController != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false, isLoading: false));
      });
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      chewieController: null,
      videoPlayerController: null,
    ));

    _disposeControllers();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeController(video);
    });
  }

  void togglePlayPause() {
    if (state.chewieController != null && state.videoPlayerController != null && !state.isLoading) {
      if (state.isPlaying) {
        state.chewieController!.pause();
      } else {
        state.chewieController!.play();
      }
      emit(state.copyWith(isPlaying: !state.isPlaying));

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (state.videoPlayerController != null) {
          emit(state.copyWith(isPlaying: state.videoPlayerController!.value.isPlaying));
        }
      });
    }
  }

  void minimizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: true));
      });
    }
  }

  void maximizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false));
      });
    }
  }

  void closePlayer() {
    _disposeControllers();
    // Stop background playback when closing player
    if (isBackgroundMode) {
      toggleBackgroundMode(false, '');
    }
    emit(state.copyWith(
      clearCurrentVideo: true,
      clearControllers: true,
      isMinimized: false,
      isPlaying: false,
      isLoading: false,
    ));
    _retryCount = 0;
  }

  void playNextVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex < allTubeVideos.length - 1) {
      playVideo(allTubeVideos[currentIndex + 1]);
    }
  }

  void playPreviousVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex > 0) {
      playVideo(allTubeVideos[currentIndex - 1]);
    }
  }

  void seekForward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final duration = state.videoPlayerController!.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 20);
      if (newPosition < duration) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(duration);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void seekBackward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 20);
      if (newPosition > Duration.zero) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(Duration.zero);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void _disposeControllers() {
    try {
      if (state.chewieController != null) {
        state.chewieController!.pause();
        state.chewieController!.dispose();
      }
      if (state.videoPlayerController != null && state.videoPlayerController!.value.isInitialized) {
        state.videoPlayerController!.pause();
        state.videoPlayerController!.dispose();
      }
    } catch (e) {
      debugPrint('Error disposing controllers: $e');
    }
  }

  // Method to handle app background/foreground transitions
  Future<void> handleAppPaused() async {
    if (isBackgroundMode && _backgroundPlayer.playing) {
      debugPrint("📱 App paused - background audio continues");
    }
  }

  Future<void> handleAppResumed() async {
    if (isBackgroundMode) {
      debugPrint("📱 App resumed - background audio is active");
    }
  }
}

*/



/*
class TubeCubit extends Cubit<TubeState> {
  final GetAllTubeVideosUseCase getAllTubeVideosUseCase;

  TubeCubit(this.getAllTubeVideosUseCase) : super(TubeState());

  bool isBackgroundMode = false;
  final AudioPlayer backgroundPlayer = AudioPlayer();

  Future<void> toggleBackgroundMode(bool enabled, String videoUrl) async {
    isBackgroundMode = enabled;

    if (enabled) {
      // أوقف تشغيل الفيديو
      state.videoPlayerController?.pause();

      try {
        // إعداد مصدر الصوت مع بيانات الإشعار
        await backgroundPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(videoUrl),
            tag: MediaItem(
              id: videoUrl,
              album: "Tube Player",
              title: state.currentVideo?.title ?? "Now Playing",
            ),
          ),
        );

        await backgroundPlayer.play();
        debugPrint("🎵 Background audio started");
      } catch (e, st) {
        debugPrint("❌ Error starting background audio: $e");
        debugPrintStack(stackTrace: st);
      }
    } else {
      await backgroundPlayer.stop();
      state.videoPlayerController?.play();
    }

    emit(state.copyWith(isBackgroundMode: isBackgroundMode));
  }


  void updateVideoController(VideoPlayerController newController) {
    emit(state.copyWith(videoPlayerController: newController));
  }

  // 📌 Pagination Fields
  List<GetAllTubeVideosEntity> allTubeVideos = [];
  bool hasMoreTubeVideos = true;
  int currentPageTubeVideos = 1;
  bool isTubeVideosLoadingMore = false;
  bool isTubeVideosInitialLoading = false;
  final int pageSize = 10;

  // ⚡ Initial Load
  Future<void> loadInitialAllTubeVideos() async {
    debugPrint("🚀 CUBIT: loadInitialAllTubeVideos()");
    isTubeVideosInitialLoading = true;
    allTubeVideos.clear();
    currentPageTubeVideos = 1;
    hasMoreTubeVideos = true;

    emit(state.copyWith(
      status: StateStatus.loading,
      getAllTubeVideosData: [],
    ));

    await getAllTubeVideos();
    isTubeVideosInitialLoading = false;
  }

  // ⚡ Load More (Pagination)
  Future<void> getAllTubeVideos() async {
    if (!hasMoreTubeVideos || isTubeVideosLoadingMore) return;

    isTubeVideosLoadingMore = true;
    if (currentPageTubeVideos == 1) {
      emit(state.copyWith(status: StateStatus.loading));
    }

    final response = await getAllTubeVideosUseCase(
      GetAllTubeVideosParams(page: currentPageTubeVideos, limit: pageSize),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to load tube videos: $failure");
        isTubeVideosLoadingMore = false;
        emit(state.copyWith(status: StateStatus.error, failure: failure));
      },
          (data) {
        debugPrint("✅ Success: Received ${data.length} videos");

        if (currentPageTubeVideos == 1) {
          allTubeVideos = List.from(data);
        } else {
          allTubeVideos.addAll(data);
        }

        if (data.isEmpty) {
          hasMoreTubeVideos = false;
        } else {
          currentPageTubeVideos++;
        }

        isTubeVideosLoadingMore = false;
        emit(state.copyWith(
          status: StateStatus.success,
          getAllTubeVideosData: allTubeVideos,
        ));
      },
    );
  }

  // 🎬 Video Player Logic
  bool _isInitializing = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  Future<void> _initializeController(GetAllTubeVideosEntity video) async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      // final videoPlayerController = VideoPlayerController.networkUrl(
      //   Uri.parse(GetAllTubeVideosEntity.videoUrl!),
      //   videoPlayerOptions: VideoPlayerOptions(
      //     mixWithOthers: false,
      //     allowBackgroundPlayback: false,
      //   ),
      // );
      final videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(video.videoUrl!),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      await videoPlayerController.initialize();
      videoPlayerController.setLooping(false);
      videoPlayerController.setVolume(1.0);

      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey.withOpacity(0.3),
          bufferedColor: Colors.white.withOpacity(0.5),
        ),
        placeholder: Image.network(
          video.thumbnail!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                Text(errorMessage, style: const TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () {
                    if (_retryCount < _maxRetries) {
                      _retryCount++;
                      _disposeControllers();
                      playVideo(video);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        customControls: CustomVideoControls(
          onPrevious: playPreviousVideo,
          onNext: playNextVideo,
          onDoubleTapLeft: () {
            seekBackward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showBackwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showBackwardIndicator) {
                  emit(state.copyWith(showBackwardIndicator: false));
                }
              });
            });
          },
          onDoubleTapRight: () {
            seekForward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showForwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showForwardIndicator) {
                  emit(state.copyWith(showForwardIndicator: false));
                }
              });
            });
          },
          hasPrevious: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) > 0,
          hasNext: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) < allTubeVideos.length - 1,
          videoUrl: video.videoUrl!,
        ),
        allowedScreenSleep: false,
        showOptions: true,
        allowPlaybackSpeedChanging: true,
      );

      videoPlayerController.addListener(() {
        if (videoPlayerController.value.isPlaying != state.isPlaying) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            emit(state.copyWith(isPlaying: videoPlayerController.value.isPlaying));
          });
        }
      });

      _retryCount = 0;
      emit(state.copyWith(
        currentVideo: video,
        videoPlayerController: videoPlayerController,
        chewieController: chewieController,
        isPlaying: true,
        isMinimized: false,
        isLoading: false,
      ));
    } catch (error) {
      debugPrint('Error initializing video player: $error');
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 1));
        await _initializeController(video);
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } finally {
      _isInitializing = false;
    }
  }


  void playVideo(GetAllTubeVideosEntity video) {
    if (state.currentVideo?.id == video.id && state.chewieController != null && state.videoPlayerController != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false, isLoading: false));
      });
      return;
    }

    // Emit loading state before disposing controllers
    emit(state.copyWith(
      isLoading: true,
      chewieController: null,
      videoPlayerController: null,
    ));

    // Dispose old controllers
    _disposeControllers();

    // Schedule initialization in the next frame to ensure UI updates
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeController(video);
    });
  }
  void togglePlayPause() {
    if (state.chewieController != null && state.videoPlayerController != null && !state.isLoading) {
      if (state.isPlaying) {
        state.chewieController!.pause();
      } else {
        state.chewieController!.play();
      }
      // ✅ Ensure state is updated immediately
      emit(state.copyWith(isPlaying: !state.isPlaying));

      // Also update from controller value as backup
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (state.videoPlayerController != null) {
          emit(state.copyWith(isPlaying: state.videoPlayerController!.value.isPlaying));
        }
      });
    }
  }
  void togglePlayPause1() {
    if (state.chewieController != null && state.videoPlayerController != null && !state.isLoading) {
      if (state.isPlaying) {
        state.chewieController!.pause();
      } else {
        state.chewieController!.play();
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isPlaying: state.videoPlayerController!.value.isPlaying));
      });
    }
  }

  void minimizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: true));
      });
    }
  }

  void maximizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false));
      });
    }
  }

  void closePlayer() {
    _disposeControllers();
    emit(state.copyWith(
      clearCurrentVideo: true,
      clearControllers: true,
      isMinimized: false,
      isPlaying: false,
      isLoading: false,
    ));
    _retryCount = 0;
  }




  void playNextVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex < allTubeVideos.length - 1) {
      playVideo(allTubeVideos[currentIndex + 1]);
    }
  }

  void playPreviousVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex > 0) {
      playVideo(allTubeVideos[currentIndex - 1]);
    }
  }

  void seekForward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final duration = state.videoPlayerController!.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 20);
      if (newPosition < duration) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(duration);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void seekBackward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 20);
      if (newPosition > Duration.zero) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(Duration.zero);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void _disposeControllers() {
    try {
      if (state.chewieController != null) {
        state.chewieController!.pause();
        state.chewieController!.dispose();
      }
      if (state.videoPlayerController != null && state.videoPlayerController!.value.isInitialized) {
        state.videoPlayerController!.pause();
        state.videoPlayerController!.dispose();
      }
    } catch (e) {
      debugPrint('Error disposing controllers: $e');
    }
  }

  @override
  Future<void> close() async {
    _disposeControllers();
    super.close();
  }
}

*/


///
/*
class TubeCubit extends Cubit<TubeState> {
  final GetAllTubeVideosUseCase getAllTubeVideosUseCase;
  final NotificationService _notificationService = NotificationService();
  StreamSubscription<String>? _notificationSubscription;

  TubeCubit(this.getAllTubeVideosUseCase) : super(TubeState()) {
    _initializeNotificationListener();
  }

  bool isBackgroundMode = false;
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  StreamSubscription? _playerStateSubscription;

  void _initializeNotificationListener() {
    _notificationSubscription = NotificationService.actionStream.listen(
          (action) {
        debugPrint("🎯 Received notification action: $action");
        _handleNotificationAction(action);
      },
      onError: (error) {
        debugPrint("❌ Error in notification stream: $error");
      },
      cancelOnError: false,
    );
  }

  Future<void> _handleNotificationAction(String action) async {
    debugPrint("🔔 Processing notification action: $action");

    try {
      switch (action) {
        case 'pause':
          debugPrint("⏸️ Pause button clicked");
          if (_backgroundPlayer.playing) {
            await _backgroundPlayer.pause();
            await _showNotification(
              state.currentVideo?.title ?? "Tube Player",
              "Paused - Tap Play to resume",
              paused: true,
            );
          }
          break;

        case 'play':
          debugPrint("▶️ Play button clicked");
          if (!_backgroundPlayer.playing) {
            await _backgroundPlayer.play();
            await _showNotification(
              state.currentVideo?.title ?? "Tube Player",
              "Playing in background",
              paused: false,
            );
          }
          break;

        case 'stop':
          debugPrint("⏹️ Stop button clicked - disabling background mode");
          isBackgroundMode = false;
          emit(state.copyWith(isBackgroundMode: false));

          await _backgroundPlayer.stop();
          await _hideNotification();
          await _playerStateSubscription?.cancel();

          // Resume normal video playback
          await _resumeVideoIfNeeded();
          break;

        case 'tap':
          debugPrint("👆 Notification tapped - toggling play/pause");
          if (_backgroundPlayer.playing) {
            await _backgroundPlayer.pause();
            await _showNotification(
              state.currentVideo?.title ?? "Tube Player",
              "Paused - Tap Play to resume",
              paused: true,
            );
          } else {
            await _backgroundPlayer.play();
            await _showNotification(
              state.currentVideo?.title ?? "Tube Player",
              "Playing in background",
              paused: false,
            );
          }
          break;

        default:
          debugPrint("⚠️ Unknown notification action: $action");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error handling notification action '$action': $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _showNotification(String title, String message, {bool paused = false}) async {
    try {
      final actions = paused
          ? [
        const AndroidNotificationAction(
          'play',
          'Play',
          showsUserInterface: false,
          cancelNotification: false,
        ),
        const AndroidNotificationAction(
          'stop',
          'Stop',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ]
          : [
        const AndroidNotificationAction(
          'pause',
          'Pause',
          showsUserInterface: false,
          cancelNotification: false,
        ),
        const AndroidNotificationAction(
          'stop',
          'Stop',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ];

      await _notificationService.showNotification(
        id: 1,
        title: title,
        body: message,
        actions: actions,
      );

      debugPrint("✅ Notification shown: $title - $message");
    } catch (e) {
      debugPrint("❌ Error showing notification: $e");
    }
  }

  @override
  Future<void> close() async {
    debugPrint("🔄 Closing TubeCubit...");

    await _notificationSubscription?.cancel();
    await _playerStateSubscription?.cancel();

    if (_backgroundPlayer.playing) {
      await _backgroundPlayer.stop();
    }
    await _backgroundPlayer.dispose();

    await _hideNotification();
    _notificationService.dispose();
    _disposeControllers();

    await super.close();
    debugPrint("✅ TubeCubit closed");
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
  }

  Future<void> _hideNotification() async {
    await _notificationService.cancelNotification(1);
  }

  // Main toggle method - called from UI button
  Future<void> toggleBackgroundMode(bool enabled, String videoUrl) async {
    try {
      if (enabled) {
        debugPrint("🎵 Enabling background mode");

        // Check if video is currently playing
        final isVideoPlaying = state.videoPlayerController?.value.isPlaying ?? false;

        if (isVideoPlaying) {
          // Only start background playback if video is playing
          debugPrint("▶️ Video is playing - starting background playback");
          await _startBackgroundPlayback(videoUrl);
        } else {
          // Video is paused - just enable the mode without starting playback
          debugPrint("⏸️ Video is paused - enabling background mode without playback");
          await _initializeNotifications();
          await _showNotification(
            state.currentVideo?.title ?? "Tube Player",
            "Background mode enabled - Paused",
            paused: true,
          );
        }
      } else {
        debugPrint("🛑 Stopping background mode");
        await _stopBackgroundMode();
      }

      isBackgroundMode = enabled;
      emit(state.copyWith(isBackgroundMode: enabled));
    } catch (e, stackTrace) {
      debugPrint('❌ Error in toggleBackgroundMode: $e');
      debugPrintStack(stackTrace: stackTrace);

      await _resumeVideoIfNeeded();
      isBackgroundMode = false;
      emit(state.copyWith(isBackgroundMode: false));
    }
  }

  Future<void> _stopBackgroundMode() async {
    try {
      await _backgroundPlayer.stop();
      await _hideNotification();
      await _playerStateSubscription?.cancel();

      isBackgroundMode = false;
      emit(state.copyWith(isBackgroundMode: false));

      debugPrint("🎵 Background mode stopped");
    } catch (e) {
      debugPrint("❌ Error stopping background mode: $e");
    }

    await _resumeVideoIfNeeded();
  }

  Future<void> _startBackgroundPlayback(String videoUrl) async {
    await _initializeNotifications();
    await _pauseVideoForBackground();

    try {
      await _backgroundPlayer.stop();

      await _backgroundPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(videoUrl)),
      );

      _playerStateSubscription?.cancel();
      _playerStateSubscription = _backgroundPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          debugPrint("🎵 Video completed in background - moving to next");

          if (isBackgroundMode) {
            playNextVideo();
          } else {
            _hideNotification();
          }
        }
      });

      await _showNotification(
        state.currentVideo?.title ?? "Tube Player",
        "Playing in background",
        paused: false,
      );

      await _backgroundPlayer.play();

      debugPrint("🎵 Background playback started");

    } catch (e) {
      debugPrint("❌ Error starting background playback: $e");
      await _hideNotification();
      await _resumeVideoIfNeeded();
      rethrow;
    }
  }

  Future<void> _pauseVideoForBackground() async {
    if (state.videoPlayerController?.value.isInitialized == true &&
        state.videoPlayerController!.value.isPlaying) {
      await state.videoPlayerController?.pause();
      debugPrint("⏸️ Paused video for background playback");
    }
  }

  Future<void> _resumeVideoIfNeeded() async {
    if (state.videoPlayerController?.value.isInitialized == true &&
        !state.videoPlayerController!.value.isPlaying &&
        !isBackgroundMode) {
      await state.videoPlayerController?.play();
      debugPrint("▶️ Resumed video after background playback");
    }
  }

  Future<void> toggleVideoPlayPause() async {
    if (state.chewieController != null && state.videoPlayerController != null && !state.isLoading) {
      if (state.isPlaying) {
        await state.chewieController!.pause();
        if (isBackgroundMode && _backgroundPlayer.playing) {
          await _backgroundPlayer.pause();
          await _showNotification(
            state.currentVideo?.title ?? "Tube Player",
            "Paused - Tap Play to resume",
            paused: true,
          );
        }
      } else {
        await state.chewieController!.play();

        // If background mode is enabled and video was paused, start background playback now
        if (isBackgroundMode) {
          if (!_backgroundPlayer.playing && state.currentVideo?.videoUrl != null) {
            await _startBackgroundPlayback(state.currentVideo!.videoUrl!);
          } else if (_backgroundPlayer.playing) {
            // Just resume if already loaded
            await _backgroundPlayer.play();
            await _showNotification(
              state.currentVideo?.title ?? "Tube Player",
              "Playing in background",
              paused: false,
            );
          }
        }
      }

      emit(state.copyWith(isPlaying: !state.isPlaying));

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (state.videoPlayerController != null) {
          emit(state.copyWith(isPlaying: state.videoPlayerController!.value.isPlaying));
        }
      });
    }
  }

  void updateVideoController(VideoPlayerController newController) {
    emit(state.copyWith(videoPlayerController: newController));
  }

  List<GetAllTubeVideosEntity> allTubeVideos = [];
  bool hasMoreTubeVideos = true;
  int currentPageTubeVideos = 1;
  bool isTubeVideosLoadingMore = false;
  bool isTubeVideosInitialLoading = false;
  final int pageSize = 10;

  Future<void> loadInitialAllTubeVideos() async {
    debugPrint("🚀 CUBIT: loadInitialAllTubeVideos()");
    isTubeVideosInitialLoading = true;
    allTubeVideos.clear();
    currentPageTubeVideos = 1;
    hasMoreTubeVideos = true;

    emit(state.copyWith(
      status: StateStatus.loading,
      getAllTubeVideosData: [],
    ));

    await getAllTubeVideos();
    isTubeVideosInitialLoading = false;
  }

  Future<void> getAllTubeVideos() async {
    if (!hasMoreTubeVideos || isTubeVideosLoadingMore) return;

    isTubeVideosLoadingMore = true;
    if (currentPageTubeVideos == 1) {
      emit(state.copyWith(status: StateStatus.loading));
    }

    final response = await getAllTubeVideosUseCase(
      GetAllTubeVideosParams(page: currentPageTubeVideos, limit: pageSize),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to load tube videos: $failure");
        isTubeVideosLoadingMore = false;
        emit(state.copyWith(status: StateStatus.error, failure: failure));
      },
          (data) {
        debugPrint("✅ Success: Received ${data.length} videos");

        if (currentPageTubeVideos == 1) {
          allTubeVideos = List.from(data);
        } else {
          allTubeVideos.addAll(data);
        }

        if (data.isEmpty) {
          hasMoreTubeVideos = false;
        } else {
          currentPageTubeVideos++;
        }

        isTubeVideosLoadingMore = false;
        emit(state.copyWith(
          status: StateStatus.success,
          getAllTubeVideosData: allTubeVideos,
        ));
      },
    );
  }

  bool _isInitializing = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  Future<void> _initializeController(GetAllTubeVideosEntity video) async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      final videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(video.videoUrl!),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: true,
        ),
      );

      await videoPlayerController.initialize();
      videoPlayerController.setLooping(false);
      videoPlayerController.setVolume(1.0);

      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: !isBackgroundMode, // Don't autoplay if in background mode
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey.withOpacity(0.3),
          bufferedColor: Colors.white.withOpacity(0.5),
        ),
        placeholder: Image.network(
          video.thumbnail!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                Text(errorMessage, style: const TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () {
                    if (_retryCount < _maxRetries) {
                      _retryCount++;
                      _disposeControllers();
                      playVideo(video);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        customControls: CustomVideoControls(
          onPrevious: playPreviousVideo,
          onNext: playNextVideo,
          onDoubleTapLeft: () {
            seekBackward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showBackwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showBackwardIndicator) {
                  emit(state.copyWith(showBackwardIndicator: false));
                }
              });
            });
          },
          onDoubleTapRight: () {
            seekForward20Seconds();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(state.copyWith(showForwardIndicator: true));
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.showForwardIndicator) {
                  emit(state.copyWith(showForwardIndicator: false));
                }
              });
            });
          },
          hasPrevious: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) > 0,
          hasNext: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) < allTubeVideos.length - 1,
          videoUrl: video.videoUrl!,
        ),
        allowedScreenSleep: false,
        showOptions: true,
        allowPlaybackSpeedChanging: true,
      );

      videoPlayerController.addListener(() {
        if (videoPlayerController.value.isPlaying != state.isPlaying) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            emit(state.copyWith(isPlaying: videoPlayerController.value.isPlaying));
          });
        }
      });

      _retryCount = 0;
      emit(state.copyWith(
        currentVideo: video,
        videoPlayerController: videoPlayerController,
        chewieController: chewieController,
        isPlaying: !isBackgroundMode,
        isMinimized: false,
        isLoading: false,
      ));

      // If background mode is active, start background playback for new video
      if (isBackgroundMode) {
        await _startBackgroundPlayback(video.videoUrl!);
      }

    } catch (error) {
      debugPrint('❌ Error initializing video player: $error');
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 1));
        await _initializeController(video);
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } finally {
      _isInitializing = false;
    }
  }

  void playVideo(GetAllTubeVideosEntity video) {
    if (state.currentVideo?.id == video.id && state.chewieController != null && state.videoPlayerController != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false, isLoading: false));
      });
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      chewieController: null,
      videoPlayerController: null,
    ));

    _disposeControllers();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeController(video);
    });
  }

  void minimizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: true));
      });
    }
  }

  void maximizePlayer() {
    if (state.chewieController != null && !state.isLoading) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(isMinimized: false));
      });
    }
  }

  void closePlayer() {
    if (isBackgroundMode) {
      _stopBackgroundMode();
    }
    _disposeControllers();
    emit(state.copyWith(
      clearCurrentVideo: true,
      clearControllers: true,
      isMinimized: false,
      isPlaying: false,
      isLoading: false,
    ));
    _retryCount = 0;
  }

  void playNextVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex < allTubeVideos.length - 1) {
      playVideo(allTubeVideos[currentIndex + 1]);
    } else {
      debugPrint("📝 No more videos to play");
      if (isBackgroundMode) {
        _hideNotification();
      }
    }
  }

  void playPreviousVideo() {
    if (state.currentVideo == null || state.isLoading) return;
    final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex > 0) {
      playVideo(allTubeVideos[currentIndex - 1]);
    }
  }

  void seekForward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final duration = state.videoPlayerController!.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 20);
      if (newPosition < duration) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(duration);
      }

      // Also seek in background player if active
      if (isBackgroundMode && _backgroundPlayer.playing) {
        _backgroundPlayer.seek(newPosition);
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void seekBackward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 20);
      if (newPosition > Duration.zero) {
        state.videoPlayerController!.seekTo(newPosition);
      } else {
        state.videoPlayerController!.seekTo(Duration.zero);
      }

      // Also seek in background player if active
      if (isBackgroundMode && _backgroundPlayer.playing) {
        _backgroundPlayer.seek(newPosition > Duration.zero ? newPosition : Duration.zero);
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith());
      });
    }
  }

  void _disposeControllers() {
    try {
      if (state.chewieController != null) {
        state.chewieController!.pause();
        state.chewieController!.dispose();
      }
      if (state.videoPlayerController != null && state.videoPlayerController!.value.isInitialized) {
        state.videoPlayerController!.pause();
        state.videoPlayerController!.dispose();
      }
    } catch (e) {
      debugPrint('❌ Error disposing controllers: $e');
    }
  }

  Future<void> handleAppPaused() async {
    if (isBackgroundMode && _backgroundPlayer.playing) {
      debugPrint("📱 App paused - background audio continues");
    }
  }

  Future<void> handleAppResumed() async {
    if (isBackgroundMode) {
      debugPrint("📱 App resumed - background audio is active");
    }
  }
}
 */
///