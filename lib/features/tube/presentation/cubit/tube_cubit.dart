import 'dart:async';
import 'dart:math' as AndroidImportance;

import 'package:audio_service/audio_service.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' hide Priority;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/tube/domain/entities/get_active_category_entity.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/create_video_tube_use_case.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/delete_tube_comment_use_case.dart';
import 'package:just_audio/just_audio.dart';

import 'package:video_player/video_player.dart';
import '../../../../common/functions/global/upload_file.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/error/failure.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../../test_noti.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entities/add_favorite_tube_entity.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../../domain/entities/get_tube_video_commnets_entity.dart';
import '../../domain/usecases/add_favorite_tube_use_case.dart';
import '../../domain/usecases/create_comment_tube_video_use_case.dart';
import '../../domain/usecases/dislike_tube_comment_use_case.dart';
import '../../domain/usecases/dislike_tube_video_use_case.dart';
import '../../domain/usecases/get_active_categories_use_case.dart';
import '../../domain/usecases/get_all_tube_videos_use_case.dart';
import '../../domain/usecases/get_my_tube_videos_use_case.dart';
import '../../domain/usecases/get_related_tube_videos_use_case.dart';
import '../../domain/usecases/get_tube_favorite_videos_use_case.dart';
import '../../domain/usecases/get_tube_video_comments_use_case.dart';
import '../../domain/usecases/like_tube_comment_use_case.dart';
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
  final LikeTubeCommentUseCase likeTubeCommentUseCase;
  final DislikeTubeCommentUseCase dislikeTubeCommentUseCase;
  final DeleteTubeCommentUseCase deleteTubeCommentUseCase;
  final LikeTubeVideoUseCase likeTubeVideoUseCase;
  final DislikeTubeVideoUseCase dislikeTubeVideoUseCase;
  final GetActiveCategoriesUseCase getActiveCategoriesUseCase;
  final CreateVideoTubeUseCase createTubeVideoUseCase;
  final GetMyTubeVideosUseCase getMyTubeVideosUseCase;

  TubeCubit(
    this.getAllTubeVideosUseCase,
    this.getTubeFavoriteVideosUseCase,
    this.addFavoriteTubeUseCase,
    this.removeFavoriteTubeUseCase,
    this.searchTubeVideoUseCase,
    this.getRelatedTubeVideosUseCase,
    this.getTubeVideoCommentsUseCase,
    this.createCommentTubeVideoUseCase,
    this.updateCommentTubeVideoUseCase,
    this.likeTubeCommentUseCase,
    this.dislikeTubeCommentUseCase,
    this.deleteTubeCommentUseCase, this.likeTubeVideoUseCase, this.dislikeTubeVideoUseCase, this.getActiveCategoriesUseCase, this.createTubeVideoUseCase, this.getMyTubeVideosUseCase,
  ) : super(TubeState());


  List<GetAllTubeVideosEntity> myTubeVideos = [];
  bool hasMoreMyTubeVideos = true;
  int currentPageMyTubeVideos = 1;
  bool isMyTubeVideosLoadingMore = false;
  bool isMyTubeVideosInitialLoading = false;

  String? get currentUserId {
    final userCubit = serviceLocator<UserCubit>();
    return userCubit.isLoggedIn ? userCubit.state.data?.id : null;
  }

  Future<void> loadInitialMyTubeVideos() async {
    debugPrint("🚀 CUBIT: loadInitialMyTubeVideos(userId: $currentUserId)");

    isMyTubeVideosInitialLoading = true;
    myTubeVideos.clear();
    currentPageMyTubeVideos = 1;
    hasMoreMyTubeVideos = true;

    emit(state.copyWith(
      status: StateStatus.loading,
      getAllTubeVideosData: [],
    ));

    await getMyTubeVideos();
    isMyTubeVideosInitialLoading = false;
  }

  Future<void> getMyTubeVideos() async {
    if (!hasMoreMyTubeVideos || isMyTubeVideosLoadingMore) return;

    isMyTubeVideosLoadingMore = true;
    debugPrint("📥 Loading MY videos | Page: $currentPageMyTubeVideos | userId: $currentUserId");

    if (currentPageMyTubeVideos == 1) {
      emit(state.copyWith(status: StateStatus.loading));
    }

    final response = await getMyTubeVideosUseCase(
      GetAllTubeVideosParams(
        page: currentPageMyTubeVideos,
        limit: pageSize,
        userId: currentUserId,
      ),
    );

    response.fold(
          (failure) {
        isMyTubeVideosLoadingMore = false;
        emit(state.copyWith(status: StateStatus.error, failure: failure));
      },
          (data) {
        if (currentPageMyTubeVideos == 1) {
          myTubeVideos = List.from(data);
        } else {
          myTubeVideos.addAll(data);
        }

        if (data.length < pageSize) {
          hasMoreMyTubeVideos = false;
        } else {
          currentPageMyTubeVideos++;
        }

        isMyTubeVideosLoadingMore = false;
        emit(state.copyWith(
          status: StateStatus.success,
          getAllTubeVideosData: myTubeVideos,
        ));
      },
    );
  }



  void addVideo(UploadFileEntity video) {
    final updatedVideos = List<UploadFileEntity>.from(state.videos ?? [])..add(video);
    emit(state.copyWith(
      videos: updatedVideos,
      failure: null,
    ));
  }

  void clearUploadedVideos() {
    emit(state.copyWith(
      videos: const [],
      uploadStatus: StateStatus.initial,
      failure: null,
      addFavoriteTubeData: null,
    ));
  }

  Future<void> loadActiveCategories() async {
    emit(state.copyWith(status: StateStatus.loading));
    final response = await getActiveCategoriesUseCase(NoParams());
    response.fold(
          (failure) => emit(state.copyWith(
        status: StateStatus.error,
        failure: failure,
      )),
          (categories) {
        print('Fetched categories: ${categories.data.categories.map((c) => c.id).toList()}');
        emit(state.copyWith(
          status: StateStatus.success,
          activeCategories: categories.data.categories,
          failure: null,
        ));
      },
    );
  }

  Future<void> createTubeVideo({
    required String title,
    required String description,
    required String categoryId,
  }) async {
    emit(state.copyWith(
      uploadStatus: StateStatus.loading,
      failure: null,
      addFavoriteTubeData: null,
    ));

    final response = await createTubeVideoUseCase(
      CreateTubeVideoParams(
        title: title,
        description: description,
        categoryId: categoryId,
      ),
    );

    response.fold(
          (failure) {
        print('createTubeVideo error: $failure');
        emit(state.copyWith(
          uploadStatus: StateStatus.error,
          failure: failure,
          addFavoriteTubeData: null,
        ));
      },
          (entity) => emit(state.copyWith(
        uploadStatus: StateStatus.success,
        addFavoriteTubeData: entity,
        failure: null,
      )),
    );
  }








  List<GetAllTubeVideosEntity> currentVideoList = [];
  // In TubeCubit

  /// Toggle the expanded state of a comment's replies
  void toggleCommentReplies(String commentId) {
    final currentState = state;
    final expandedComments = Map<String, bool>.from(currentState.expandedComments);
    expandedComments[commentId] = !(expandedComments[commentId] ?? false);
    emit(currentState.copyWith(expandedComments: expandedComments));
  }

  /// 💬 Create a new comment on a video
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
      },
          (entity) async {
        debugPrint("✅ Comment created successfully!");

        // If it's a reply, ensure parent is expanded
        Map<String, bool> newExpandedComments = Map.from(state.expandedComments);
        if (parentCommentId != null) {
          newExpandedComments[parentCommentId] = true;
        }

        // Refresh from backend to get latest comments & replies
        await _silentlyRefreshComments(context, videoId);

        // Emit updated expansion state
        emit(state.copyWith(
          expandedComments: newExpandedComments,
          lastRepliedCommentId: parentCommentId,
        ));
      },
    );
  }

  /// 🔄 Refresh comments without duplication or loading indicators
  /// 🔄 Refresh comments without duplication or loading indicators
  Future<void> _silentlyRefreshComments(
      BuildContext context,
      String videoId,
      ) async {
    try {
      // ✅ Get userId from UserCubit
      final userCubit = serviceLocator<UserCubit>();
      final userId = userCubit.isLoggedIn ? userCubit.state.data?.id : null;

      final response = await getTubeVideoCommentsUseCase(
        GetTubeCommentsParams(
          id: videoId,
          page: 1,
          limit: pageSize,
          userId: userId, // ✅ Optional
        ),
      );

      response.fold(
            (failure) {
          debugPrint("❌ Silent refresh failed");
        },
            (entity) {
          final TubeVideoCommentsDataEntity? commentsData = entity.data;
          final List<TubeCommentEntity> newComments = commentsData?.comments ?? [];

          // ✅ Overwrite existing list to avoid duplicates
          tubeVideoComments = List<TubeCommentEntity>.from(newComments);

          // ✅ Handle pagination
          hasMoreTubeVideoComments = newComments.length >= pageSize;
          currentPageTubeVideoComments = hasMoreTubeVideoComments ? 2 : 1;

          // ✅ Emit new clean state
          emit(state.copyWith(
            status: StateStatus.success,
            tubeVideoCommentsData:
            List<TubeCommentEntity>.from(tubeVideoComments),
          ));

          debugPrint("✅ Comments silently refreshed: ${tubeVideoComments.length}");
        },
      );
    } catch (e) {
      debugPrint("❌ Error in silent refresh: $e");
    }
  }

  // Future<void> _silentlyRefreshComments(BuildContext context, String videoId) async {
  //   try {
  //     final response = await getTubeVideoCommentsUseCase(
  //       GetRelatedTubeVideosParams(
  //         id: videoId,
  //         page: 1,
  //         limit: pageSize,
  //       ),
  //     );
  //
  //     response.fold(
  //           (failure) {
  //         debugPrint("❌ Silent refresh failed");
  //       },
  //           (entity) {
  //         final TubeVideoCommentsDataEntity? commentsData = entity.data;
  //         final List<TubeCommentEntity> newComments = commentsData?.comments ?? [];
  //
  //         // Overwrite existing list to avoid duplicates
  //         tubeVideoComments = List<TubeCommentEntity>.from(newComments);
  //
  //         // Pagination handling
  //         hasMoreTubeVideoComments = newComments.length >= pageSize;
  //         currentPageTubeVideoComments = hasMoreTubeVideoComments ? 2 : 1;
  //
  //         // Emit clean state
  //         emit(state.copyWith(
  //           status: StateStatus.success,
  //           tubeVideoCommentsData: List<TubeCommentEntity>.from(tubeVideoComments),
  //         ));
  //
  //         debugPrint("✅ Comments silently refreshed: ${tubeVideoComments.length}");
  //       },
  //     );
  //   } catch (e) {
  //     debugPrint("❌ Error in silent refresh: $e");
  //   }
  // }

  /// ✏️ Update an existing comment
  /// ✏️ Update an existing comment
  /// ✏️ Update an existing comment
  /// ✏️ Update an existing comment
  Future<void> updateCommentOnTubeVideo({
    required BuildContext context,
    required String commentId,
    required String content,
  }) async {
    debugPrint("✏️ Updating comment id=$commentId");

    TubeCommentEntity? originalComment;
    TubeReplyEntity? originalReply;
    String? videoId;
    int? parentIndex;
    int? replyIndex;

    // 🔍 1. Check if it's a top-level comment
    final commentIndex = tubeVideoComments.indexWhere((c) => c.id == commentId);

    if (commentIndex != -1) {
      // ✅ Top-level comment
      originalComment = tubeVideoComments[commentIndex];
      videoId = originalComment.video;

      // Optimistically update UI
      tubeVideoComments[commentIndex] = originalComment.copyWith(
        content: content,
        updatedAt: DateTime.now(),
      );

      emit(state.copyWith(
        tubeVideoCommentsData: List.from(tubeVideoComments),
      ));
    } else {
      // 🔍 2. Check if it's a reply inside any top-level comment
      for (int i = 0; i < tubeVideoComments.length; i++) {
        final replies = tubeVideoComments[i].replies;
        final rIndex = replies.indexWhere((r) => r.id == commentId);

        if (rIndex != -1) {
          parentIndex = i;
          replyIndex = rIndex;
          originalReply = replies[rIndex];
          videoId = originalReply.video;

          // ✅ Optimistic UI update for reply
          final updatedReply = originalReply.copyWith(
            content: content,
            updatedAt: DateTime.now(),
          );

          final updatedReplies = List<TubeReplyEntity>.from(replies);
          updatedReplies[rIndex] = updatedReply;

          tubeVideoComments[i] = tubeVideoComments[i].copyWith(
            replies: updatedReplies,
          );

          emit(state.copyWith(
            tubeVideoCommentsData: List.from(tubeVideoComments),
          ));
          break;
        }
      }
    }

    // ❌ Still not found in either list
    if (videoId == null) {
      debugPrint("❌ Comment or reply not found in local state");
      return;
    }

    // 🔄 Make API call
    final response = await updateCommentTubeVideoUseCase(
      UpdateCommentTubeParams(
        commentId: commentId,
        content: content,
      ),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to update comment");
        // 🔁 Rollback optimistic UI update
        if (originalComment != null && commentIndex != -1) {
          tubeVideoComments[commentIndex!] = originalComment;
        } else if (originalReply != null && parentIndex != null && replyIndex != null) {
          final updatedReplies = List<TubeReplyEntity>.from(
            tubeVideoComments[parentIndex!].replies,
          );
          updatedReplies[replyIndex!] = originalReply;
          tubeVideoComments[parentIndex!] = tubeVideoComments[parentIndex!].copyWith(
            replies: updatedReplies,
          );
        }

        emit(state.copyWith(
          tubeVideoCommentsData: List.from(tubeVideoComments),
        ));
      },
          (entity) async {
        debugPrint("✅ Comment updated successfully!");
        // Refresh entire comment thread to keep it clean
        await _silentlyRefreshComments(context, videoId!);
      },
    );
  }


  /// 🗑️ Delete a comment
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
      },
          (entity) {
        debugPrint("✅ Comment deleted successfully!");
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }

  /// 👍 Like a comment (with optimistic UI update)
  /// 👍 Like a comment or reply (with optimistic UI update)
  void likeComment(String commentId, String videoId) {
    debugPrint("👍 LikeComment called for commentId=$commentId");

    // Check if the commentId is a top-level comment
    final commentIndex = tubeVideoComments.indexWhere((c) => c.id == commentId);
    if (commentIndex != -1) {
      // Top-level comment
      final comment = tubeVideoComments[commentIndex];
      final wasLiked = comment.isLike;
      final wasDisliked = comment.isDislike;

      // Update local state for top-level comment
      tubeVideoComments[commentIndex] = TubeCommentEntity(
        id: comment.id,
        content: comment.content,
        userId: comment.userId,
        owner: comment.owner,
        video: comment.video,
        likes: wasLiked ? comment.likes - 1 : comment.likes + 1,
        dislikes: wasDisliked ? comment.dislikes - 1 : comment.dislikes,
        allLike: comment.allLike,
        allDislike: comment.allDislike,
        isLike: !wasLiked,
        isDislike: false,
        isMyComment: comment.isMyComment,
        replies: comment.replies,
        createdAt: comment.createdAt,
        updatedAt: comment.updatedAt,
      );

      emit(state.copyWith(
        tubeVideoCommentsData: List.from(tubeVideoComments),
      ));
    } else {
      // Check if the commentId is a reply
      for (int i = 0; i < tubeVideoComments.length; i++) {
        final replyIndex = tubeVideoComments[i].replies.indexWhere((r) => r.id == commentId);
        if (replyIndex != -1) {
          final parentComment = tubeVideoComments[i];
          final reply = parentComment.replies[replyIndex];
          final wasLiked = reply.isLike;
          final wasDisliked = reply.isDislike;

          // Create updated reply as TubeReplyEntity
          final updatedReply = TubeReplyEntity(
            id: reply.id,
            content: reply.content,
            userId: reply.userId,
            owner: reply.owner,
            video: reply.video,
            likes: wasLiked ? reply.likes - 1 : reply.likes + 1,
            dislikes: wasDisliked ? reply.dislikes - 1 : reply.dislikes,
            isLike: !wasLiked,
            isDislike: false,
            isMyComment: reply.isMyComment,
            parentComment: reply.parentComment,
            replies: [], // Replies are not nested, so empty list
            createdAt: reply.createdAt,
            updatedAt: reply.updatedAt,
          );

          // Update the replies list
          final updatedReplies = List<TubeReplyEntity>.from(parentComment.replies);
          updatedReplies[replyIndex] = updatedReply;

          // Update the parent comment
          tubeVideoComments[i] = TubeCommentEntity(
            id: parentComment.id,
            content: parentComment.content,
            userId: parentComment.userId,
            owner: parentComment.owner,
            video: parentComment.video,
            likes: parentComment.likes,
            dislikes: parentComment.dislikes,
            allLike: parentComment.allLike,
            allDislike: parentComment.allDislike,
            isLike: parentComment.isLike,
            isDislike: parentComment.isDislike,
            isMyComment: parentComment.isMyComment,
            replies: updatedReplies,
            createdAt: parentComment.createdAt,
            updatedAt: parentComment.updatedAt,
          );

          emit(state.copyWith(
            tubeVideoCommentsData: List.from(tubeVideoComments),
          ));
          break;
        }
      }
    }

    // Call API
    _likeCommentApi(commentId);
  }

  /// 👎 Dislike a comment or reply (with optimistic UI update)
  void dislikeComment(String commentId, String videoId) {
    debugPrint("👎 DislikeComment called for commentId=$commentId");

    // Check if the commentId is a top-level comment
    final commentIndex = tubeVideoComments.indexWhere((c) => c.id == commentId);
    if (commentIndex != -1) {
      // Top-level comment
      final comment = tubeVideoComments[commentIndex];
      final wasLiked = comment.isLike;
      final wasDisliked = comment.isDislike;

      // Update local state for top-level comment
      tubeVideoComments[commentIndex] = TubeCommentEntity(
        id: comment.id,
        content: comment.content,
        userId: comment.userId,
        owner: comment.owner,
        video: comment.video,
        likes: wasLiked ? comment.likes - 1 : comment.likes,
        dislikes: wasDisliked ? comment.dislikes - 1 : comment.dislikes + 1,
        allLike: comment.allLike,
        allDislike: comment.allDislike,
        isLike: false,
        isDislike: !wasDisliked,
        isMyComment: comment.isMyComment,
        replies: comment.replies,
        createdAt: comment.createdAt,
        updatedAt: comment.updatedAt,
      );

      emit(state.copyWith(
        tubeVideoCommentsData: List.from(tubeVideoComments),
      ));
    } else {
      // Check if the commentId is a reply
      for (int i = 0; i < tubeVideoComments.length; i++) {
        final replyIndex = tubeVideoComments[i].replies.indexWhere((r) => r.id == commentId);
        if (replyIndex != -1) {
          final parentComment = tubeVideoComments[i];
          final reply = parentComment.replies[replyIndex];
          final wasLiked = reply.isLike;
          final wasDisliked = reply.isDislike;

          // Create updated reply as TubeReplyEntity
          final updatedReply = TubeReplyEntity(
            id: reply.id,
            content: reply.content,
            userId: reply.userId,
            owner: reply.owner,
            video: reply.video,
            likes: wasLiked ? reply.likes - 1 : reply.likes,
            dislikes: wasDisliked ? reply.dislikes - 1 : reply.dislikes + 1,
            isLike: false,
            isDislike: !wasDisliked,
            isMyComment: reply.isMyComment,
            parentComment: reply.parentComment,
            replies: [], // Replies are not nested, so empty list
            createdAt: reply.createdAt,
            updatedAt: reply.updatedAt,
          );

          // Update the replies list
          final updatedReplies = List<TubeReplyEntity>.from(parentComment.replies);
          updatedReplies[replyIndex] = updatedReply;

          // Update the parent comment
          tubeVideoComments[i] = TubeCommentEntity(
            id: parentComment.id,
            content: parentComment.content,
            userId: parentComment.userId,
            owner: parentComment.owner,
            video: parentComment.video,
            likes: parentComment.likes,
            dislikes: parentComment.dislikes,
            allLike: parentComment.allLike,
            allDislike: parentComment.allDislike,
            isLike: parentComment.isLike,
            isDislike: parentComment.isDislike,
            isMyComment: parentComment.isMyComment,
            replies: updatedReplies,
            createdAt: parentComment.createdAt,
            updatedAt: parentComment.updatedAt,
          );

          emit(state.copyWith(
            tubeVideoCommentsData: List.from(tubeVideoComments),
          ));
          break;
        }
      }
    }

    // Call API
    _dislikeCommentApi(commentId);
  }
  Future<void> _dislikeCommentApi(String commentId) async {
    final response = await dislikeTubeCommentUseCase(
      FavoriteTubeParams(id: commentId),
    );

    response.fold(
          (failure) => debugPrint("❌ Failed to dislike comment"),
          (entity) => debugPrint("✅ Comment disliked successfully!"),
    );
  }
  Future<void> _likeCommentApi(String commentId) async {
    final response = await likeTubeCommentUseCase(
      FavoriteTubeParams(id: commentId),
    );

    response.fold(
          (failure) => debugPrint("❌ Failed to like comment"),
          (entity) => debugPrint("✅ Comment liked successfully!"),
    );
  }

/*
  // In TubeCubit
// Toggle the expanded state of a comment's replies
// In TubeCubit
  void toggleCommentReplies(String commentId) {
    final currentState = state;
    final expandedComments =
        Map<String, bool>.from(currentState.expandedComments);
    expandedComments[commentId] = !(expandedComments[commentId] ?? false);
    emit(currentState.copyWith(expandedComments: expandedComments));
  }

  void addReplyToComment(String parentCommentId, TubeCommentEntity reply) {
    final currentState = state;
    // You might need to update your comments list here to include the new reply
    // This depends on how you're storing comments in your state
    emit(currentState.copyWith(lastRepliedCommentId: parentCommentId));
  }

  /// 💬 Create a new comment on a video
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
        // Silent failure, no state change
      },
      (entity) async {
        debugPrint("✅ Comment created successfully!");

        // If it's a reply, ensure parent is expanded
        Map<String, bool> newExpandedComments =
            Map.from(state.expandedComments);
        if (parentCommentId != null) {
          newExpandedComments[parentCommentId] = true;
        }

        // 🔹 Refresh from backend to get latest comments & replies
        await _silentlyRefreshComments(context, videoId);

        // 🔹 Emit updated expansion state
        emit(state.copyWith(
          expandedComments: newExpandedComments,
          lastRepliedCommentId: parentCommentId,
        ));
      },
    );
  }

  /// 🔄 Refresh comments without duplication or loading indicators
  Future<void> _silentlyRefreshComments(
      BuildContext context, String videoId) async {
    try {
      final response = await getTubeVideoCommentsUseCase(
        GetRelatedTubeVideosParams(
          id: videoId,
          page: 1,
          limit: pageSize,
        ),
      );

      response.fold(
        (failure) {
          debugPrint("❌ Silent refresh failed");
          // Silent fail: don't emit an error state
        },
        (entity) {
          final TubeVideoCommentsDataEntity? commentsData = entity.data;
          final List<TubeCommentEntity> newComments =
              commentsData?.comments ?? [];

          // 🚨 Overwrite (not append) existing list to avoid duplicates
          tubeVideoComments = List<TubeCommentEntity>.from(newComments);

          // Pagination handling
          hasMoreTubeVideoComments = newComments.length >= pageSize;
          currentPageTubeVideoComments = hasMoreTubeVideoComments ? 2 : 1;

          // Emit clean, non-duplicated state
          emit(state.copyWith(
            status: StateStatus.success,
            tubeVideoCommentsData:
                List<TubeCommentEntity>.from(tubeVideoComments),
          ));

          debugPrint(
              "✅ Comments silently refreshed: ${tubeVideoComments.length}");
        },
      );
    } catch (e) {
      debugPrint("❌ Error in silent refresh: $e");
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

    final response = await likeTubeCommentUseCase(
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

    final response = await dislikeTubeCommentUseCase(
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
*/
  // ========================================
  // 🎬 VIDEO MANAGEMENT
  // ========================================

  /// 👍 Like a video with optimistic UI update
  Future<void> likeTubeVideo(String videoId) async {
    debugPrint("👍 LikeTubeVideo called for videoId=$videoId");

    // Find current video state
    final targetVideo = _findVideoInAllLists(videoId);
    if (targetVideo == null) return;

    final bool wasLiked = targetVideo.isLike ?? false;
    final bool wasDisliked = targetVideo.isDislike ?? false;

    // Optimistically update UI
    _updateVideoInAllLists(
      videoId,
      isLike: !wasLiked, // Toggle like
      isDislike: false,  // Remove dislike if it was there
      likes: wasLiked
          ? (targetVideo.likes ?? 0) - 1  // Remove like
          : (targetVideo.likes ?? 0) + 1, // Add like
      dislikes: wasDisliked
          ? (targetVideo.dislikes ?? 0) - 1  // Remove previous dislike
          : targetVideo.dislikes,
    );

    // Make API call
    final response = await likeTubeVideoUseCase(
      FavoriteTubeParams(id: videoId),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to like video");
        // Revert optimistic update on failure
        _updateVideoInAllLists(
          videoId,
          isLike: wasLiked,
          isDislike: wasDisliked,
          likes: targetVideo.likes,
          dislikes: targetVideo.dislikes,
        );
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
          (entity) {
        debugPrint("✅ Video liked successfully!");
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }

  /// 👎 Dislike a video with optimistic UI update
  Future<void> dislikeTubeVideo(String videoId) async {
    debugPrint("👎 DislikeTubeVideo called for videoId=$videoId");

    // Find current video state
    final targetVideo = _findVideoInAllLists(videoId);
    if (targetVideo == null) return;

    final bool wasLiked = targetVideo.isLike ?? false;
    final bool wasDisliked = targetVideo.isDislike ?? false;

    // Optimistically update UI
    _updateVideoInAllLists(
      videoId,
      isLike: false,  // Remove like if it was there
      isDislike: !wasDisliked, // Toggle dislike
      likes: wasLiked
          ? (targetVideo.likes ?? 0) - 1  // Remove previous like
          : targetVideo.likes,
      dislikes: wasDisliked
          ? (targetVideo.dislikes ?? 0) - 1  // Remove dislike
          : (targetVideo.dislikes ?? 0) + 1, // Add dislike
    );

    // Make API call
    final response = await dislikeTubeVideoUseCase(
      FavoriteTubeParams(id: videoId),
    );

    response.fold(
          (failure) {
        debugPrint("❌ Failed to dislike video");
        // Revert optimistic update on failure
        _updateVideoInAllLists(
          videoId,
          isLike: wasLiked,
          isDislike: wasDisliked,
          likes: targetVideo.likes,
          dislikes: targetVideo.dislikes,
        );
        emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
          (entity) {
        debugPrint("✅ Video disliked successfully!");
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }

  /// Helper: Find video in all lists
  GetAllTubeVideosEntity? _findVideoInAllLists(String videoId) {
    // Check all lists
    final lists = [
      allTubeVideos,
      favoriteTubeVideos,
      searchTubeVideos,
      relatedTubeVideos,
    ];

    for (final list in lists) {
      final video = list.firstWhere(
            (v) => v.id == videoId,
        orElse: () => GetAllTubeVideosEntity(),
      );
      if (video.id != null) return video;
    }

    // Check current video
    if (state.currentVideo?.id == videoId) {
      return state.currentVideo;
    }

    return null;
  }

  /// Helper: Update video in all lists
  void _updateVideoInAllLists(
      String videoId, {
        bool? isLike,
        bool? isDislike,
        int? likes,
        int? dislikes,
        bool? isSubscribed,
        int? subscriberCount,
      }) {
    // Update allTubeVideos
    allTubeVideos = allTubeVideos.map((v) {
      if (v.id == videoId) {
        return v.copyWith(
          isLike: isLike,
          isDislike: isDislike,
          likes: likes,
          dislikes: dislikes,
          isSubscribed: isSubscribed,
          subscriberCount: subscriberCount,
        );
      }
      return v;
    }).toList();

    // Update favoriteTubeVideos
    favoriteTubeVideos = favoriteTubeVideos.map((v) {
      if (v.id == videoId) {
        return v.copyWith(
          isLike: isLike,
          isDislike: isDislike,
          likes: likes,
          dislikes: dislikes,
          isSubscribed: isSubscribed,
          subscriberCount: subscriberCount,
        );
      }
      return v;
    }).toList();

    // Update searchTubeVideos
    searchTubeVideos = searchTubeVideos.map((v) {
      if (v.id == videoId) {
        return v.copyWith(
          isLike: isLike,
          isDislike: isDislike,
          likes: likes,
          dislikes: dislikes,
          isSubscribed: isSubscribed,
          subscriberCount: subscriberCount,
        );
      }
      return v;
    }).toList();

    // Update relatedTubeVideos
    relatedTubeVideos = relatedTubeVideos.map((v) {
      if (v.id == videoId) {
        return v.copyWith(
          isLike: isLike,
          isDislike: isDislike,
          likes: likes,
          dislikes: dislikes,
          isSubscribed: isSubscribed,
          subscriberCount: subscriberCount,
        );
      }
      return v;
    }).toList();

    // Update current video if it matches
    GetAllTubeVideosEntity? updatedCurrentVideo = state.currentVideo;
    if (state.currentVideo?.id == videoId) {
      updatedCurrentVideo = state.currentVideo!.copyWith(
        isLike: isLike,
        isDislike: isDislike,
        likes: likes,
        dislikes: dislikes,
        isSubscribed: isSubscribed,
        subscriberCount: subscriberCount,
      );
    }

    // Emit updated state
    emit(state.copyWith(
      getAllTubeVideosData: allTubeVideos,
      getFavoriteTubeVideosData: favoriteTubeVideos,
      searchTubeVideosData: searchTubeVideos,
      relatedTubeVideosData: relatedTubeVideos,
      currentVideo: updatedCurrentVideo,
    ));
  }

  /// ➕ Subscribe to a channel
  Future<void> subscribeToChannel(String channelId, String videoId) async {
    debugPrint("➕ Subscribe called for channelId=$channelId");

    final targetVideo = _findVideoInAllLists(videoId);
    if (targetVideo == null) return;

    final bool wasSubscribed = targetVideo.isSubscribed ?? false;

    // Optimistically update UI
    _updateVideoInAllLists(
      videoId,
      isSubscribed: !wasSubscribed,
      subscriberCount: wasSubscribed
          ? (targetVideo.subscriberCount ?? 0) - 1
          : (targetVideo.subscriberCount ?? 0) + 1,
    );

    // TODO: Replace with your actual subscribe use case
    // final response = await subscribeToChannelUseCase(
    //   SubscribeParams(channelId: channelId),
    // );

    // Simulate API call for now
    await Future.delayed(Duration(milliseconds: 500));

    debugPrint("✅ Subscription toggled successfully!");
  }

  List<TubeCommentEntity> tubeVideoComments = [];
  bool hasMoreTubeVideoComments = true;
  int currentPageTubeVideoComments = 1;
  bool isTubeVideoCommentsLoadingMore = false;
  bool isTubeVideoCommentsInitialLoading = false;
  String currentTubeVideoId = '';

// 🔹 Load Initial Tube Video Comments
  Future<void> loadInitialTubeVideoComments(
      BuildContext context,
      String videoId,
      ) async {
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

    // ✅ Get userId from UserCubit via service locator
    final userCubit = serviceLocator<UserCubit>();
    final userId = userCubit.isLoggedIn ? userCubit.state.data?.id : null;

    final response = await getTubeVideoCommentsUseCase(
      GetTubeCommentsParams(
        id: currentTubeVideoId,
        page: currentPageTubeVideoComments,
        limit: pageSize,
        userId: userId, // ✅ Optional user ID
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
        final TubeVideoCommentsDataEntity? commentsData = entity.data;
        final List<TubeCommentEntity> newComments = commentsData?.comments ?? [];

        debugPrint("📥 Received ${newComments.length} comments");

        if (currentPageTubeVideoComments == 1) {
          tubeVideoComments = List<TubeCommentEntity>.from(newComments);
        } else {
          tubeVideoComments.addAll(newComments);
        }

        // ✅ Pagination control
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
  Future<void> loadInitialRelatedTubeVideos(String videoId) async {
    debugPrint(
        "🚀 CUBIT: loadInitialRelatedTubeVideos() called with videoId=$videoId");

    isRelatedTubeInitialLoading = true;
    relatedTubeVideos.clear();
    currentPageRelatedTubeVideos = 1;
    hasMoreRelatedTubeVideos = true;
    currentRelatedTubeId = videoId;

    emit(state.copyWith(
      status: StateStatus.loading,
      relatedTubeVideosData: [], // 👈 make sure TubeState supports this field
    ));

    await getRelatedTubeVideos();

    isRelatedTubeInitialLoading = false;
  }

// 🔁 Pagination / Load More Related Videos
  Future<void> getRelatedTubeVideos() async {
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
  Future<void> loadInitialSearchTubeVideos(
      BuildContext context, String query) async {
    debugPrint(
        "🚀 CUBIT: loadInitialSearchTubeVideos() called with query=$query");

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
          favoriteTubeVideos =
              favoriteTubeVideos.where((v) => v.id != videoId).toList();
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
      GetAllTubeVideosParams(
          page: currentPageFavoriteTubeVideos, limit: pageSize),
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
  // 📦 Pagination Fields
  List<GetAllTubeVideosEntity> allTubeVideos = [];
  bool hasMoreTubeVideos = true;
  int currentPageTubeVideos = 1;
  bool isTubeVideosLoadingMore = false;
  bool isTubeVideosInitialLoading = false;
  final int pageSize = 10;

// Optional userId

  /// ⚡ Initial Load
  Future<void> loadInitialAllTubeVideos({String? userId}) async {
    debugPrint("🚀 CUBIT: loadInitialAllTubeVideos(userId: $userId)");

    isTubeVideosInitialLoading = true;
    allTubeVideos.clear();
    currentPageTubeVideos = 1;
    hasMoreTubeVideos = true;

    emit(state.copyWith(
      status: StateStatus.loading,
      getAllTubeVideosData: [],
    ));

    await getAllTubeVideos(); // ✅ Triggers first page
    isTubeVideosInitialLoading = false;
  }

  /// ⚡ Load More (Pagination)
  Future<void> getAllTubeVideos() async {
    if (!hasMoreTubeVideos || isTubeVideosLoadingMore) return;

    isTubeVideosLoadingMore = true;
    debugPrint("📥 Loading videos | Page: $currentPageTubeVideos | userId: $currentUserId");

    // Show loading for the first page
    if (currentPageTubeVideos == 1) {
      emit(state.copyWith(status: StateStatus.loading));
    }

    // ✅ Pass userId only if it’s available
    final response = await getAllTubeVideosUseCase(
      GetAllTubeVideosParams(
        page: currentPageTubeVideos,
        limit: pageSize,
        userId: currentUserId, // Optional param
      ),
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

        // ✅ Check if more data exists
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
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.error)),
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
            if (state.currentVideo == null || currentVideoList.isEmpty)
              return false;
            final currentIndex = currentVideoList
                .indexWhere((v) => v.id == state.currentVideo!.id);
            return currentIndex > 0;
          },
          hasNext: () {
            if (state.currentVideo == null || currentVideoList.isEmpty)
              return false;
            final currentIndex = currentVideoList
                .indexWhere((v) => v.id == state.currentVideo!.id);
            return currentIndex >= 0 &&
                currentIndex < currentVideoList.length - 1;
          },
          videoUrl: video.videoUrl!,
        ),
        allowedScreenSleep: false,
        showOptions: true,
        allowPlaybackSpeedChanging: true,
      );

      videoPlayerController.addListener(() {
        if (videoPlayerController.value.isPlaying != state.isPlaying ||
            videoPlayerController.value.position !=
                state.lastPlaybackPosition) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            emit(state.copyWith(
              isPlaying: videoPlayerController.value.isPlaying,
              lastPlaybackPosition:
                  videoPlayerController.value.position, // Track position
            ));
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
        areControllersInitialized: true,
        lastPlaybackPosition: Duration.zero, // Start from beginning
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

  void playVideo(GetAllTubeVideosEntity video,
      {List<GetAllTubeVideosEntity>? videoList}) async {
    final wasMinimized = state.isMinimized;

    // Update currentVideoList with the provided videoList or use existing one
    if (videoList != null && videoList.isNotEmpty) {
      currentVideoList = List.from(videoList);
    } else if (currentVideoList.isEmpty) {
      currentVideoList =
          allTubeVideos.isNotEmpty ? allTubeVideos : favoriteTubeVideos;
    }

    // Check if the video is the same as the current one and controllers are initialized
    final isSameVideo = state.currentVideo?.id == video.id &&
        state.areControllersInitialized &&
        state.videoPlayerController != null &&
        state.chewieController != null;

    if (isSameVideo) {
      // If the same video is selected, reuse controllers and maintain playback position
      emit(state.copyWith(
        isLoading: false,
        isMinimized: false, // Maximize the player
        lastPlaybackPosition:
            state.videoPlayerController!.value.position, // Preserve position
      ));
      if (state.isPlaying) {
        await state.videoPlayerController!.play();
      }
      return;
    }

    // Otherwise, dispose existing controllers and initialize new ones
    emit(state.copyWith(
      isLoading: true,
      chewieController: null,
      videoPlayerController: null,
      currentVideo: null,
      lastPlaybackPosition: null,
      areControllersInitialized: false,
    ));

    _disposeControllers();

    await Future.delayed(const Duration(
        milliseconds: 100)); // Tiny delay for smoother transition

    await _initializeController(video);

    // 🔥 CRITICAL: Load related videos for the new video
    await loadInitialRelatedTubeVideos(video.id!);

    if (wasMinimized) {
      emit(state.copyWith(isMinimized: true));
    }
  }

  void togglePlayPause() {
    if (state.chewieController != null &&
        state.videoPlayerController != null &&
        !state.isLoading) {
      if (state.isPlaying) {
        state.chewieController!.pause();
      } else {
        state.chewieController!.play();
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        emit(state.copyWith(
            isPlaying: state.videoPlayerController!.value.isPlaying));
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
    _disposeControllers(); // Dispose controllers completely
    emit(state.copyWith(
      currentVideo: null,
      // Clear current video
      videoPlayerController: null,
      chewieController: null,
      isMinimized: false,
      isPlaying: false,
      isLoading: false,
      areControllersInitialized: false,
      lastPlaybackPosition: null,
      // Clear last playback position
      clearCurrentVideo: true,
      clearControllers: true,
    ));
    _retryCount = 0;
  }

  void playNextVideo() {
    if (state.currentVideo == null ||
        state.isLoading ||
        currentVideoList.isEmpty) return;

    final currentIndex =
        currentVideoList.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex >= 0 && currentIndex < currentVideoList.length - 1) {
      final nextVideo = currentVideoList[currentIndex + 1];
      playVideo(nextVideo, videoList: currentVideoList);
    }
  }

  void playPreviousVideo() {
    if (state.currentVideo == null ||
        state.isLoading ||
        currentVideoList.isEmpty) return;

    final currentIndex =
        currentVideoList.indexWhere((v) => v.id == state.currentVideo!.id);
    if (currentIndex > 0) {
      final previousVideo = currentVideoList[currentIndex - 1];
      playVideo(previousVideo, videoList: currentVideoList);
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
        areControllersInitialized: false,
        lastPlaybackPosition: null,
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
