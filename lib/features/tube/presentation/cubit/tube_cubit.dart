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
import '../../domain/entities/add_favorite_tube_entity.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../../domain/usecases/add_favorite_tube_use_case.dart';
import '../../domain/usecases/get_all_tube_videos_use_case.dart';
import '../../domain/usecases/get_tube_favorite_videos_use_case.dart';
import '../../domain/usecases/remove_favorite_tube_use_case.dart';
import '../../domain/usecases/search_tube_use_case.dart';
import '../widgets/custom_tube_widget.dart';

part 'tube_state.dart';





class TubeCubit extends Cubit<TubeState> {
  final GetAllTubeVideosUseCase getAllTubeVideosUseCase;
  final GetTubeFavoriteVideosUseCase getTubeFavoriteVideosUseCase;
  final AddFavoriteTubeUseCase addFavoriteTubeUseCase;
  final RemoveFavoriteTubeUseCase removeFavoriteTubeUseCase;
  final SearchTubeVideoUseCase searchTubeVideoUseCase;

  TubeCubit(this.getAllTubeVideosUseCase, this.getTubeFavoriteVideosUseCase, this.addFavoriteTubeUseCase, this.removeFavoriteTubeUseCase, this.searchTubeVideoUseCase) : super(TubeState());
  List<GetAllTubeVideosEntity> currentVideoList = [];

  // ⚡ Search Tube Pagination
  List<GetAllTubeVideosEntity> searchTubeVideos = [];
  bool hasMoreSearchTubeVideos = true;
  int currentPageSearchTubeVideos = 1;
  bool isSearchTubeLoadingMore = false;
  bool isSearchTubeInitialLoading = false;
  String currentSearchTubeQuery = '';

  // 🔍 Load Initial Search
  Future<void> loadInitialSearchTubeVideos(BuildContext context, String query) async {
    debugPrint("🚀 CUBIT: loadInitialSearchTubeVideos() called with query=$query");

    isSearchTubeInitialLoading = true;
    searchTubeVideos.clear();
    currentPageSearchTubeVideos = 1;
    hasMoreSearchTubeVideos = true;
    currentSearchTubeQuery = query;

    emit(state.copyWith(
      status: StateStatus.loading,
      searchTubeVideosData: [], // 👈 optional: add this field in TubeState
    ));

    await getSearchTubeVideos(context);

    isSearchTubeInitialLoading = false;
  }

  // 🔁 Pagination / Load More
  Future<void> getSearchTubeVideos(BuildContext context) async {
    debugPrint("🚀 CUBIT: getSearchTubeVideos() called");
    debugPrint("📊 State: hasMore=$hasMoreSearchTubeVideos, "
        "isLoading=$isSearchTubeLoadingMore, "
        "page=$currentPageSearchTubeVideos, "
        "query=$currentSearchTubeQuery");

    if (!hasMoreSearchTubeVideos || isSearchTubeLoadingMore) {
      return;
    }

    isSearchTubeLoadingMore = true;

    final response = await searchTubeVideoUseCase(
      SearchTubeParams(
        page: currentPageSearchTubeVideos,
        limit: pageSize,
        searchQuery: currentSearchTubeQuery,
      ),
    );

    response.fold(
          (failure) {
        isSearchTubeLoadingMore = false;
        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ));
      },
          (data) {
        if (currentPageSearchTubeVideos == 1) {
          searchTubeVideos = List.from(data);
        } else {
          searchTubeVideos.addAll(data);
        }

        if (data.length < pageSize) {
          hasMoreSearchTubeVideos = false;
        } else {
          currentPageSearchTubeVideos++;
        }

        isSearchTubeLoadingMore = false;

        emit(state.copyWith(
          status: StateStatus.success,
          searchTubeVideosData: searchTubeVideos, // 👈 same as above
        ));
      },
    );
  }







  Future<void> toggleFavoriteTubeVideo(String videoId) async {
    emit(state.copyWith(status: StateStatus.loading));

    // 🔍 Find the target video from any source
    final targetVideo = allTubeVideos.firstWhere(
          (v) => v.id == videoId,
      orElse: () => favoriteTubeVideos.firstWhere(
            (v) => v.id == videoId,
        orElse: () => searchTubeVideos.firstWhere(
              (v) => v.id == videoId,
          orElse: () => GetAllTubeVideosEntity(id: videoId),
        ),
      ),
    );

    final bool isCurrentlyFavorite = targetVideo.isFavorite ?? false;

    // 🧠 Perform API call
    final response = isCurrentlyFavorite
        ? await removeFavoriteTubeUseCase(FavoriteTubeParams(id: videoId))
        : await addFavoriteTubeUseCase(FavoriteTubeParams(id: videoId));

    response.fold(
          (failure) {
        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ));
      },
          (entity) {
        // ✅ Update allTubeVideos
        allTubeVideos = allTubeVideos.map((v) {
          if (v.id == videoId) {
            return v.copyWith(isFavorite: !isCurrentlyFavorite);
          }
          return v;
        }).toList();

        // ✅ Update searchTubeVideos
        searchTubeVideos = searchTubeVideos.map((v) {
          if (v.id == videoId) {
            return v.copyWith(isFavorite: !isCurrentlyFavorite);
          }
          return v;
        }).toList();

        // ✅ Update favoriteTubeVideos
        final index = favoriteTubeVideos.indexWhere((v) => v.id == videoId);
        if (index != -1) {
          // Already in favorites → unfavorite → remove
          favoriteTubeVideos =
              favoriteTubeVideos.where((v) => v.id != videoId).toList();
        } else {
          // Not in favorites → favorite → add
          final newFav = allTubeVideos.firstWhere(
                (v) => v.id == videoId,
            orElse: () => searchTubeVideos.firstWhere(
                  (v) => v.id == videoId,
              orElse: () => targetVideo,
            ),
          );
          favoriteTubeVideos = [
            ...favoriteTubeVideos,
            newFav.copyWith(isFavorite: true),
          ];
        }

        // ✅ Emit updated state
        emit(state.copyWith(
          status: StateStatus.success,
          getAllTubeVideosData: allTubeVideos,
          getFavoriteTubeVideosData: favoriteTubeVideos,
          searchTubeVideosData: searchTubeVideos,
        ));
      },
    );
  }

  Future<void> toggleFavoriteTubeVideo1(String videoId) async {
    emit(state.copyWith(status: StateStatus.loading));

    // Find the video in allTubeVideos or favoriteTubeVideos
    final targetVideo = allTubeVideos.firstWhere(
          (v) => v.id == videoId,
      orElse: () => favoriteTubeVideos.firstWhere(
            (v) => v.id == videoId,
        orElse: () => GetAllTubeVideosEntity(id: videoId),
      ),
    );

    final bool isCurrentlyFavorite = targetVideo.isFavorite ?? false;

    final response = isCurrentlyFavorite
        ? await removeFavoriteTubeUseCase(FavoriteTubeParams(id: videoId))
        : await addFavoriteTubeUseCase(FavoriteTubeParams(id: videoId));

    response.fold(
          (failure) {
        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ));
      },
          (entity) {
        // ✅ Update allTubeVideos list
        allTubeVideos = allTubeVideos.map((v) {
          if (v.id == videoId) {
            return v.copyWith(isFavorite: !isCurrentlyFavorite);
          }
          return v;
        }).toList();

        // ✅ Update searchTubeVideos
        searchTubeVideos = searchTubeVideos.map((v) {
          if (v.id == videoId) {
            return v.copyWith(isFavorite: !isCurrentlyFavorite);
          }
          return v;
        }).toList();
        // ✅ Update favoriteTubeVideos list
        final index = favoriteTubeVideos.indexWhere((v) => v.id == videoId);

        if (index != -1) {
          // Already in favorites → unfavorite → remove
          favoriteTubeVideos = favoriteTubeVideos
              .where((v) => v.id != videoId)
              .toList();
        } else {
          // Not in favorites → favorite → add from allTubeVideos
          final newFav = allTubeVideos.firstWhere(
                (v) => v.id == videoId,
            orElse: () => targetVideo,
          );
          favoriteTubeVideos = [
            ...favoriteTubeVideos,
            newFav.copyWith(isFavorite: true),
          ];
        }

        // ✅ Emit updated state
        emit(state.copyWith(
          status: StateStatus.success,
          getAllTubeVideosData: allTubeVideos,
        ));
      },
    );
  }


  // 📌 Pagination Fields
  List<GetAllTubeVideosEntity> favoriteTubeVideos = [];
  bool hasMoreFavoriteTubeVideos = true;
  int currentPageFavoriteTubeVideos = 1;
  bool isFavoriteTubeVideosLoadingMore = false;
  bool isFavoriteTubeInitialLoading = false;

  // ⚡ Initial Load
  Future<void> loadInitialFavoriteTubeVideos() async {
    debugPrint("🚀 CUBIT: loadInitialFavoriteTubeVideos()");
    isFavoriteTubeInitialLoading = true;
    favoriteTubeVideos.clear();
    currentPageFavoriteTubeVideos = 1;
    hasMoreFavoriteTubeVideos = true;

    emit(state.copyWith(
      status: StateStatus.loading,
      getFavoriteTubeVideosData: [],
    ));

    await getFavoriteTubeVideos();
    isFavoriteTubeInitialLoading = false;
  }

  // ⚡ Load More (Pagination)
  Future<void> getFavoriteTubeVideos() async {
    if (!hasMoreFavoriteTubeVideos || isFavoriteTubeVideosLoadingMore) return;

    isFavoriteTubeVideosLoadingMore = true;
    if (currentPageFavoriteTubeVideos == 1) {
      emit(state.copyWith(status: StateStatus.loading));
    }

    final response = await getTubeFavoriteVideosUseCase(
      GetAllTubeVideosParams(page: currentPageFavoriteTubeVideos, limit: pageSize),
    );

    response.fold(
          (failure) {
        isFavoriteTubeVideosLoadingMore = false;
        emit(state.copyWith(status: StateStatus.error, failure: failure));
      },
          (data) {
        if (currentPageFavoriteTubeVideos == 1) {
          favoriteTubeVideos = List.from(data);
        } else {
          favoriteTubeVideos.addAll(data);
        }

        // Fix here
        if (data.length < pageSize) {
          hasMoreFavoriteTubeVideos = false;
        } else {
          currentPageFavoriteTubeVideos++;
        }

        isFavoriteTubeVideosLoadingMore = false;
        emit(state.copyWith(
          status: StateStatus.success,
          getFavoriteTubeVideosData: favoriteTubeVideos,
        ));
      },
    );

  }




  ///
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
        isTubeVideosLoadingMore = false;
        emit(state.copyWith(status: StateStatus.error, failure: failure));
      },
          (data) {
        if (currentPageTubeVideos == 1) {
          allTubeVideos = List.from(data);
        } else {
          allTubeVideos.addAll(data);
        }

        // Fix here
        if (data.length < pageSize) {
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
        // customControls: CustomVideoControls(
        //   cubit: this, // مرر الـ cubit الحالي
        //   onPrevious: playPreviousVideo,
        //   onNext: playNextVideo,
        //   onDoubleTapLeft: () {
        //     seekBackward20Seconds();
        //     SchedulerBinding.instance.addPostFrameCallback((_) {
        //       emit(state.copyWith(showBackwardIndicator: true));
        //       Future.delayed(const Duration(milliseconds: 1000), () {
        //         if (state.showBackwardIndicator) {
        //           emit(state.copyWith(showBackwardIndicator: false));
        //         }
        //       });
        //     });
        //   },
        //   onDoubleTapRight: () {
        //     seekForward20Seconds();
        //     SchedulerBinding.instance.addPostFrameCallback((_) {
        //       emit(state.copyWith(showForwardIndicator: true));
        //       Future.delayed(const Duration(milliseconds: 1000), () {
        //         if (state.showForwardIndicator) {
        //           emit(state.copyWith(showForwardIndicator: false));
        //         }
        //       });
        //     });
        //   },
        //   hasPrevious: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) > 0,
        //   hasNext: () => allTubeVideos.indexWhere((v) => v.id == state.currentVideo?.id) < allTubeVideos.length - 1,
        //   videoUrl: video.videoUrl!,
        // ),
        customControls: CustomVideoControls(
          cubit: this,
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
          hasPrevious: () {
            if (state.currentVideo == null || currentVideoList.isEmpty) return false;
            final currentIndex = currentVideoList.indexWhere((v) => v.id == state.currentVideo!.id);
            return currentIndex > 0;
          },
          hasNext: () {
            if (state.currentVideo == null || currentVideoList.isEmpty) return false;
            final currentIndex = currentVideoList.indexWhere((v) => v.id == state.currentVideo!.id);
            return currentIndex < currentVideoList.length - 1;
          },
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

  void playVideo(GetAllTubeVideosEntity video, {List<GetAllTubeVideosEntity>? videoList}) {
    final wasMinimized = state.isMinimized;

    // Always set the current list - use provided list or fallback to allTubeVideos
    if (videoList != null) {
      currentVideoList = videoList;
    } else if (currentVideoList.isEmpty) {
      currentVideoList = allTubeVideos;
    }

    if (state.currentVideo?.id == video.id &&
        state.chewieController != null &&
        state.videoPlayerController != null) {
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
      _initializeController(video).then((_) {
        if (wasMinimized) {
          emit(state.copyWith(isMinimized: true));
        }
      });
    });
  }
  // void playVideo(GetAllTubeVideosEntity video, {List<GetAllTubeVideosEntity>? videoList}) {
  //   final wasMinimized = state.isMinimized;
  //
  //   // Set the current list if provided
  //   if (videoList != null) {
  //     currentVideoList = videoList;
  //   }
  //
  //   if (state.currentVideo?.id == video.id &&
  //       state.chewieController != null &&
  //       state.videoPlayerController != null) {
  //     SchedulerBinding.instance.addPostFrameCallback((_) {
  //       emit(state.copyWith(isMinimized: false, isLoading: false));
  //     });
  //     return;
  //   }
  //
  //   emit(state.copyWith(
  //     isLoading: true,
  //     chewieController: null,
  //     videoPlayerController: null,
  //   ));
  //
  //   _disposeControllers();
  //
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //     _initializeController(video).then((_) {
  //       if (wasMinimized) {
  //         emit(state.copyWith(isMinimized: true));
  //       }
  //     });
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
    if (state.currentVideo == null || state.isLoading || currentVideoList.isEmpty) return;

    final currentIndex = currentVideoList.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex < currentVideoList.length - 1) {
      playVideo(currentVideoList[currentIndex + 1]);
    }
  }

  void playPreviousVideo() {
    if (state.currentVideo == null || state.isLoading || currentVideoList.isEmpty) return;

    final currentIndex = currentVideoList.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex > 0) {
      playVideo(currentVideoList[currentIndex - 1]);
    }
  }

  // void playNextVideo() {
  //   if (state.currentVideo == null || state.isLoading) return;
  //
  //   final currentIndex = currentVideoList.indexWhere((v) => v.id == state.currentVideo!.id);
  //   if (currentIndex < currentVideoList.length - 1) {
  //     playVideo(currentVideoList[currentIndex + 1], videoList: currentVideoList);
  //   }
  // }
  //
  // void playPreviousVideo() {
  //   if (state.currentVideo == null || state.isLoading) return;
  //
  //   final currentIndex = currentVideoList.indexWhere((v) => v.id == state.currentVideo!.id);
  //   if (currentIndex > 0) {
  //     playVideo(currentVideoList[currentIndex - 1], videoList: currentVideoList);
  //   }
  // }

  // void playNextVideo() {
  //   if (state.currentVideo == null || state.isLoading) return;
  //   final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
  //   if (currentIndex < allTubeVideos.length - 1) {
  //     playVideo(allTubeVideos[currentIndex + 1]);
  //   }
  // }
  //
  // void playPreviousVideo() {
  //   if (state.currentVideo == null || state.isLoading) return;
  //   final currentIndex = allTubeVideos.indexWhere((v) => v.id == state.currentVideo!.id);
  //   if (currentIndex > 0) {
  //     playVideo(allTubeVideos[currentIndex - 1]);
  //   }
  // }

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



