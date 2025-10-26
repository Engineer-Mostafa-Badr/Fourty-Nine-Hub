import 'dart:async';
import 'dart:math' as AndroidImportance;

import 'package:audio_service/audio_service.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' hide Priority;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/delete_tube_comment_use_case.dart';
import 'package:just_audio/just_audio.dart';

import 'package:video_player/video_player.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/error/failure.dart';
import '../../../../test_noti.dart';
import '../../domain/entities/add_favorite_tube_entity.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../../domain/entities/get_tube_video_commnets_entity.dart';
import '../../domain/usecases/add_favorite_tube_use_case.dart';
import '../../domain/usecases/create_comment_tube_video_use_case.dart';
import '../../domain/usecases/dislike_tube_video_use_case.dart';
import '../../domain/usecases/get_all_tube_videos_use_case.dart';
import '../../domain/usecases/get_related_tube_videos_use_case.dart';
import '../../domain/usecases/get_tube_favorite_videos_use_case.dart';
import '../../domain/usecases/get_tube_video_comments_use_case.dart';
import '../../domain/usecases/like_tube_video_use_case.dart';
import '../../domain/usecases/remove_favorite_tube_use_case.dart';
import '../../domain/usecases/search_tube_use_case.dart';
import '../../domain/usecases/update_comment_tube_video_use_case.dart';
import '../widgets/custom_tube_widget.dart';

part 'tube_state.dart';





class TubeCubit extends Cubit<TubeState> {
  final GetAllTubeVideosUseCase getAllTubeVideosUseCase;
  final GetTubeFavoriteVideosUseCase getTubeFavoriteVideosUseCase;
  final AddFavoriteTubeUseCase addFavoriteTubeUseCase;
  final RemoveFavoriteTubeUseCase removeFavoriteTubeUseCase;
  final SearchTubeVideoUseCase searchTubeVideoUseCase;
  final GetRelatedTubeVideosUseCase getRelatedTubeVideosUseCase;
  final GetTubeVideoCommentsUseCase getTubeVideoCommentsUseCase;
  final CreateCommentTubeVideoUseCase createCommentTubeVideoUseCase;
  final UpdateCommentTubeVideoUseCase updateCommentTubeVideoUseCase;
  final LikeTubeVideoUseCase likeTubeVideoUseCase;
  final DislikeTubeVideoUseCase dislikeTubeVideoUseCase;
  final DeleteTubeCommentUseCase deleteTubeCommentUseCase;
  TubeCubit(this.getAllTubeVideosUseCase, this.getTubeFavoriteVideosUseCase, this.addFavoriteTubeUseCase, this.removeFavoriteTubeUseCase, this.searchTubeVideoUseCase, this.getRelatedTubeVideosUseCase, this.getTubeVideoCommentsUseCase, this.createCommentTubeVideoUseCase, this.updateCommentTubeVideoUseCase, this.likeTubeVideoUseCase, this.dislikeTubeVideoUseCase, this.deleteTubeCommentUseCase) : super(TubeState());
  List<GetAllTubeVideosEntity> currentVideoList = [];


  /// 💬 Create a new comment on a video (COMPLETELY SILENT VERSION)
  Future<void> createCommentOnTubeVideo({
    required BuildContext context,
    required String videoId,
    required String content,
    String? parentCommentId,
  }) async {
    debugPrint("💬 Creating comment on videoId=$videoId");

    final response = await createCommentTubeVideoUseCase(
      CreateCommentTubeParams(
        content: content,
        videoId: videoId,
        parentCommentId: parentCommentId ?? '',
      ),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to create comment");
        // COMPLETELY SILENT: No state changes, no snackbars
      },
          (entity) async {
        debugPrint("✅ Comment created successfully!");

        // SILENT REFRESH: Refresh comments without loading states
        await _silentlyRefreshComments(context, videoId);
      },
    );
  }

  /// 🔄 Refresh comments without any loading indicators
  Future<void> _silentlyRefreshComments(BuildContext context, String videoId) async {
    try {
      final response = await getTubeVideoCommentsUseCase(
        GetRelatedTubeVideosParams(
          id: videoId,
          page: 1, // Always load first page for new comments
          limit: pageSize,
        ),
      );

      response.fold(
            (failure) {
          debugPrint("❌ Silent refresh failed");
          // SILENT: Don't emit error state
        },
            (entity) {
          final TubeVideoCommentsDataEntity? commentsData = entity.data;
          final List<TubeCommentEntity> newComments = commentsData?.comments ?? [];

          // Update comments list silently
          tubeVideoComments = List<TubeCommentEntity>.from(newComments);

          // Update pagination state
          hasMoreTubeVideoComments = newComments.length >= pageSize;
          currentPageTubeVideoComments = hasMoreTubeVideoComments ? 2 : 1;

          // Emit success without loading state
          emit(state.copyWith(
            status: StateStatus.success, // Use success, not loading
            tubeVideoCommentsData: List<TubeCommentEntity>.from(tubeVideoComments),
          ));

          debugPrint("✅ Comments silently refreshed: ${tubeVideoComments.length}");
        },
      );
    } catch (e) {
      debugPrint("❌ Error in silent refresh: $e");
      // SILENT: Don't show errors to user
    }
  }
  /// ✏️ Update an existing comment
  /// ✏️ Update an existing comment (SILENT VERSION)
  Future<void> updateCommentOnTubeVideo({
    required BuildContext context,
    required String commentId,
    required String videoId,
    required String content,
  }) async {
    debugPrint("✏️ Updating comment id=$commentId");

    final response = await updateCommentTubeVideoUseCase(
      UpdateCommentTubeParams(
        content: content,
        videoId: videoId,
      ),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to update comment");
        // SILENT: No error handling
      },
          (entity) async {
        debugPrint("✅ Comment updated successfully!");
        // SILENT REFRESH
        await _silentlyRefreshComments(context, videoId);
      },
    );
  }

  /// 🗑️ Delete a comment (SILENT VERSION)
  Future<void> deleteTubeComment({
    required BuildContext context,
    required String commentId,
    required String videoId,
  }) async {
    debugPrint("🗑️ Deleting comment id=$commentId for video=$videoId");

    // Optimistically remove from UI
    final commentIndex = tubeVideoComments.indexWhere((c) => c.id == commentId);
    TubeCommentEntity? removedComment;

    if (commentIndex != -1) {
      removedComment = tubeVideoComments[commentIndex];
      tubeVideoComments.removeAt(commentIndex);
      emit(state.copyWith(
        tubeVideoCommentsData: List.from(tubeVideoComments),
      ));
    }

    final response = await deleteTubeCommentUseCase(
      FavoriteTubeParams(id: commentId),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to delete comment");

        // Restore comment on failure
        if (removedComment != null && commentIndex != -1) {
          tubeVideoComments.insert(commentIndex, removedComment);
          emit(state.copyWith(
            tubeVideoCommentsData: List.from(tubeVideoComments),
          ));
        }
        // SILENT: No snackbar
      },
          (entity) {
        debugPrint("✅ Comment deleted successfully!");
        // SILENT: No snackbar, UI already updated optimistically
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }

  /// 👍 Like a comment
  Future<void> likeComment(String commentId) async {
    debugPrint("👍 LikeComment called for commentId=$commentId");

    final response = await likeTubeVideoUseCase(
      FavoriteTubeParams(id: commentId),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to like comment");
      },
          (entity) {
        debugPrint("✅ Comment liked successfully!");
        // Update is handled optimistically in the UI
      },
    );
  }

  /// 👎 Dislike a comment
  Future<void> dislikeComment(String commentId) async {
    debugPrint("👎 DislikeComment called for commentId=$commentId");

    final response = await dislikeTubeVideoUseCase(
      FavoriteTubeParams(id: commentId),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to dislike comment");
      },
          (entity) {
        debugPrint("✅ Comment disliked successfully!");
        // Update is handled optimistically in the UI
      },
    );
  }

  // ========================================
  // 🎬 VIDEO MANAGEMENT
  // ========================================

  /// ❤️ Like a video
  Future<void> likeTubeVideo(String videoId) async {
    debugPrint("👍 LikeTubeVideo called for videoId=$videoId");

    final response = await likeTubeVideoUseCase(
      FavoriteTubeParams(id: videoId),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to like video");
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
          (entity) {
        debugPrint("✅ Video liked successfully!");
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }

  /// 👎 Dislike a video
  Future<void> dislikeTubeVideo(String videoId) async {
    debugPrint("👎 DislikeTubeVideo called for videoId=$videoId");

    final response = await dislikeTubeVideoUseCase(
      FavoriteTubeParams(id: videoId),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to dislike video");
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
          (entity) {
        debugPrint("✅ Video disliked successfully!");
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }
  List<TubeCommentEntity> tubeVideoComments = [];
  bool hasMoreTubeVideoComments = true;
  int currentPageTubeVideoComments = 1;
  bool isTubeVideoCommentsLoadingMore = false;
  bool isTubeVideoCommentsInitialLoading = false;
  String currentTubeVideoId = '';

// 🔹 Load Initial Tube Video Comments
  Future<void> loadInitialTubeVideoComments(BuildContext context, String videoId) async {
    debugPrint("💬 CUBIT: loadInitialTubeVideoComments() called with videoId=$videoId");

    isTubeVideoCommentsInitialLoading = true;
    tubeVideoComments.clear();
    currentPageTubeVideoComments = 1;
    hasMoreTubeVideoComments = true;
    currentTubeVideoId = videoId;

    emit(state.copyWith(
      status: StateStatus.loading,
      tubeVideoCommentsData: [],
    ));

    await getTubeVideoComments(context); // 👈 directly call pagination method

    isTubeVideoCommentsInitialLoading = false;
  }

// 🔁 Pagination / Load More Tube Video Comments
  Future<void> getTubeVideoComments(BuildContext context) async {
    debugPrint("💬 CUBIT: getTubeVideoComments() called");
    debugPrint(
      "📊 State: hasMore=$hasMoreTubeVideoComments, "
          "isLoading=$isTubeVideoCommentsLoadingMore, "
          "page=$currentPageTubeVideoComments, "
          "videoId=$currentTubeVideoId",
    );

    if (!hasMoreTubeVideoComments || isTubeVideoCommentsLoadingMore) return;

    isTubeVideoCommentsLoadingMore = true;

    final response = await getTubeVideoCommentsUseCase(
      GetRelatedTubeVideosParams(
        id: currentTubeVideoId,
        page: currentPageTubeVideoComments,
        limit: pageSize,
      ),
    );

    response.fold(
          (failure) {
        isTubeVideoCommentsLoadingMore = false;
        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ));
      },
          (entity) {
        // ✅ Ensure we're accessing the correct property
        final TubeVideoCommentsDataEntity? commentsData = entity.data;
        final List<TubeCommentEntity> newComments = commentsData?.comments ?? [];

        debugPrint("📥 Received ${newComments.length} comments");

        if (currentPageTubeVideoComments == 1) {
          tubeVideoComments = List<TubeCommentEntity>.from(newComments);
        } else {
          tubeVideoComments.addAll(newComments);
        }

        // Handle pagination end
        if (newComments.length < pageSize) {
          hasMoreTubeVideoComments = false;
          debugPrint("📭 No more comments available");
        } else {
          currentPageTubeVideoComments++;
          debugPrint("📖 Loading next page: $currentPageTubeVideoComments");
        }

        isTubeVideoCommentsLoadingMore = false;

        emit(state.copyWith(
          status: StateStatus.success,
          tubeVideoCommentsData: List<TubeCommentEntity>.from(tubeVideoComments),
        ));

        debugPrint("✅ Tube comments loaded: ${tubeVideoComments.length}");
      },
    );
  }



// 💬 Tube Video Comments Pagination


  // ⚡ Related Tube Videos Pagination
  List<GetAllTubeVideosEntity> relatedTubeVideos = [];
  bool hasMoreRelatedTubeVideos = true;
  int currentPageRelatedTubeVideos = 1;
  bool isRelatedTubeLoadingMore = false;
  bool isRelatedTubeInitialLoading = false;
  String currentRelatedTubeId = '';

// 🔍 Load Initial Related Videos
  Future<void> loadInitialRelatedTubeVideos(BuildContext context, String videoId) async {
    debugPrint("🚀 CUBIT: loadInitialRelatedTubeVideos() called with videoId=$videoId");

    isRelatedTubeInitialLoading = true;
    relatedTubeVideos.clear();
    currentPageRelatedTubeVideos = 1;
    hasMoreRelatedTubeVideos = true;
    currentRelatedTubeId = videoId;

    emit(state.copyWith(
      status: StateStatus.loading,
      relatedTubeVideosData: [], // 👈 make sure TubeState supports this field
    ));

    await getRelatedTubeVideos(context);

    isRelatedTubeInitialLoading = false;
  }

// 🔁 Pagination / Load More Related Videos
  Future<void> getRelatedTubeVideos(BuildContext context) async {
    debugPrint("🚀 CUBIT: getRelatedTubeVideos() called");
    debugPrint("📊 State: hasMore=$hasMoreRelatedTubeVideos, "
        "isLoading=$isRelatedTubeLoadingMore, "
        "page=$currentPageRelatedTubeVideos, "
        "videoId=$currentRelatedTubeId");

    if (!hasMoreRelatedTubeVideos || isRelatedTubeLoadingMore) {
      return;
    }

    isRelatedTubeLoadingMore = true;

    final response = await getRelatedTubeVideosUseCase(
      GetRelatedTubeVideosParams(
        id: currentRelatedTubeId,
        page: currentPageRelatedTubeVideos,
        limit: pageSize,
      ),
    );

    response.fold(
          (failure) {
        isRelatedTubeLoadingMore = false;
        emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ));
      },
          (data) {
        if (currentPageRelatedTubeVideos == 1) {
          relatedTubeVideos = List.from(data);
        } else {
          relatedTubeVideos.addAll(data);
        }

        if (data.length < pageSize) {
          hasMoreRelatedTubeVideos = false;
        } else {
          currentPageRelatedTubeVideos++;
        }

        isRelatedTubeLoadingMore = false;

        emit(state.copyWith(
          status: StateStatus.success,
          relatedTubeVideosData: relatedTubeVideos, // 👈 match TubeState
        ));
      },
    );
  }


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
            return currentIndex >= 0 && currentIndex < currentVideoList.length - 1;
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

  void playVideo(GetAllTubeVideosEntity video, {List<GetAllTubeVideosEntity>? videoList}) async {
    final wasMinimized = state.isMinimized;

    // Update currentVideoList with the provided videoList or use existing one
    if (videoList != null && videoList.isNotEmpty) {
      currentVideoList = List.from(videoList);
    } else if (currentVideoList.isEmpty) {
      // Fallback to allTubeVideos or favoriteTubeVideos if no list is provided
      currentVideoList = allTubeVideos.isNotEmpty ? allTubeVideos : favoriteTubeVideos;
    }

    emit(state.copyWith(
      isLoading: true,
      chewieController: null,
      videoPlayerController: null,
    ));

    _disposeControllers();

    await Future.delayed(const Duration(milliseconds: 100)); // Tiny delay for smoother transition

    await _initializeController(video);
    if (wasMinimized) {
      emit(state.copyWith(isMinimized: true));
    }
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
    if (currentIndex >= 0 && currentIndex < currentVideoList.length - 1) {
      playVideo(currentVideoList[currentIndex + 1], videoList: currentVideoList);
    }
  }

  void playPreviousVideo() {
    if (state.currentVideo == null || state.isLoading || currentVideoList.isEmpty) return;

    final currentIndex = currentVideoList.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex > 0) {
      playVideo(currentVideoList[currentIndex - 1], videoList: currentVideoList);
    }
  }

  void seekForward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final duration = state.videoPlayerController!.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 20);
      final wasPlaying = state.videoPlayerController!.value.isPlaying;

      state.videoPlayerController!.pause().then((_) async {
        if (newPosition < duration) {
          await state.videoPlayerController!.seekTo(newPosition);
        } else {
          await state.videoPlayerController!.seekTo(duration);
        }
        if (wasPlaying) {
          await state.videoPlayerController!.play();
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          emit(state.copyWith(showForwardIndicator: true));
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (state.showForwardIndicator) {
              emit(state.copyWith(showForwardIndicator: false));
            }
          });
        });
      });
    }
  }

  void seekBackward20Seconds() {
    if (state.videoPlayerController != null && !state.isLoading) {
      final currentPosition = state.videoPlayerController!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 20);
      final wasPlaying = state.videoPlayerController!.value.isPlaying;

      state.videoPlayerController!.pause().then((_) async {
        if (newPosition > Duration.zero) {
          await state.videoPlayerController!.seekTo(newPosition);
        } else {
          await state.videoPlayerController!.seekTo(Duration.zero);
        }
        if (wasPlaying) {
          await state.videoPlayerController!.play();
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          emit(state.copyWith(showBackwardIndicator: true));
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (state.showBackwardIndicator) {
              emit(state.copyWith(showBackwardIndicator: false));
            }
          });
        });
      });
    }
  }

  void _disposeControllers() {
    try {
      if (state.chewieController != null) {
        state.chewieController!.pause();
        state.chewieController!.dispose();
      }
      if (state.videoPlayerController != null) {
        state.videoPlayerController!.pause();
        state.videoPlayerController!.dispose();
      }

      emit(state.copyWith(
        chewieController: null,
        videoPlayerController: null,
      ));
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



