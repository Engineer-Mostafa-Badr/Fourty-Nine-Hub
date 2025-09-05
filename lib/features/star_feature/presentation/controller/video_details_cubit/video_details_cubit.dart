import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/entity/comment_entity.dart';
import '../../../domain/entity/star_entity.dart';
import '../../../domain/entity/viewer_entity.dart';
import '../../../domain/use_case/comment_use_cases.dart';
import '../../../data/model/comment_model.dart';
import '../../controller/star_cubit/star_cubit.dart';

part 'video_details_state.dart';

class VideoDetailsCubit extends Cubit<VideoDetailsState> {
  final String mediaUrl;
  final StarEntity talent;
  final VoidCallback? onBack;
  final StarCubit starCubit;

  // Comment use cases
  final CreateCommentUseCase _createCommentUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final UpdateCommentUseCase _updateCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;
  final LikeCommentUseCase _likeCommentUseCase;
  final DislikeCommentUseCase _dislikeCommentUseCase;

  late VideoPlayerController _videoController;

  VideoDetailsCubit({
    required this.mediaUrl,
    required this.talent,
    required this.starCubit,
    required CreateCommentUseCase createCommentUseCase,
    required GetCommentsUseCase getCommentsUseCase,
    required UpdateCommentUseCase updateCommentUseCase,
    required DeleteCommentUseCase deleteCommentUseCase,
    required LikeCommentUseCase likeCommentUseCase,
    required DislikeCommentUseCase dislikeCommentUseCase,
    this.onBack,
  })  : _createCommentUseCase = createCommentUseCase,
        _getCommentsUseCase = getCommentsUseCase,
        _updateCommentUseCase = updateCommentUseCase,
        _deleteCommentUseCase = deleteCommentUseCase,
        _likeCommentUseCase = likeCommentUseCase,
        _dislikeCommentUseCase = dislikeCommentUseCase,
        super(VideoDetailsInitial());

  // Initialize the video and load data
  Future<void> initialize() async {
    emit(VideoDetailsLoading());

    try {
      await _initializeVideo();
      final viewers = _generateMockViewers();

      // Load real comments from API
      await _loadComments();

      if (state is VideoDetailsLoaded) {
        final currentState = state as VideoDetailsLoaded;
        emit(currentState.copyWith(
          videoController: _videoController,
          isInitialized: true,
          isPlaying: true,
          isMuted: true,
          viewers: viewers,
          talent: talent,
        ));
      } else {
        // First initialization
        emit(VideoDetailsLoaded(
          videoController: _videoController,
          isInitialized: true,
          isPlaying: true,
          isMuted: true,
          viewers: viewers,
          comments: [],
          talent: talent,
          isLoadingComments: false,
          commentsError: null,
        ));

        // Load comments after initial state
        await _loadComments();
      }
    } catch (e) {
      emit(VideoDetailsError(message: 'Failed to initialize video: $e'));
    }
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.network(mediaUrl);
    await _videoController.initialize();
    _videoController.setVolume(0); // Start muted
    _videoController.play();

    // Increment video view
    starCubit.incrementVideoView(talent.id);
  }

  // Load comments from API
  Future<void> _loadComments({bool refresh = false}) async {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;

      if (!refresh && currentState.comments.isNotEmpty) {
        return; // Already loaded
      }

      emit(currentState.copyWith(isLoadingComments: true, commentsError: null));

      final result = await _getCommentsUseCase(
        GetCommentsParams(videoId: talent.id, page: 1, limit: 20),
      );

      result.fold(
        (failure) {
          emit(currentState.copyWith(
            isLoadingComments: false,
            commentsError: failure.toString(),
          ));
        },
        (commentsResponse) {
          final comments = commentsResponse.comments
              .map((commentModel) => _convertToCommentEntity(commentModel))
              .toList();

          emit(currentState.copyWith(
            comments: comments,
            isLoadingComments: false,
            commentsError: null,
          ));
        },
      );
    }
  }

  // Convert CommentModel to CommentEntity for compatibility
  CommentEntity _convertToCommentEntity(CommentModel commentModel) {
    return CommentEntity(
      id: commentModel.id,
      username: commentModel.username,
      profileImage: commentModel.profileImage,
      content: commentModel.content,
      timeAgo: commentModel.timeAgo,
      likes: commentModel.likes,
      dislikes: commentModel.dislikes,
      isLiked: commentModel.isLiked,
      isDisliked: commentModel.isDisliked,
      createdAt: commentModel.createdAt,
      parentCommentId: commentModel.parentCommentId,
      isReply: commentModel.isReply,
    );
  }

  // Toggle play/pause
  void togglePlayPause() {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;

      if (!currentState.isInitialized) return;

      if (currentState.videoController.value.isPlaying) {
        currentState.videoController.pause();
      } else {
        currentState.videoController.play();
      }

      emit(currentState.copyWith(
        isPlaying: !currentState.isPlaying,
      ));
    }
  }

  // Toggle mute/unmute
  void toggleMute() {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;

      if (!currentState.isInitialized) return;

      final newMuted = !currentState.isMuted;
      currentState.videoController.setVolume(newMuted ? 0 : 1);

      emit(currentState.copyWith(isMuted: newMuted));
    }
  }

  // Add new comment using API
  Future<void> addComment(String content) async {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;

      // Create optimistic comment for immediate UI update
      final optimisticComment = CommentEntity(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        username: '@Me',
        profileImage: '',
        content: content,
        timeAgo: 'Just now',
        likes: 0,
        dislikes: 0,
        isLiked: false,
        isDisliked: false,
        createdAt: DateTime.now(),
      );

      // Update UI immediately
      final updatedComments = [optimisticComment, ...currentState.comments];
      emit(currentState.copyWith(comments: updatedComments));

      // Call API
      final result = await _createCommentUseCase(
        CreateCommentParams(
          content: content,
          videoId: talent.id,
        ),
      );

      result.fold(
        (failure) {
          // Remove optimistic comment on failure
          final revertedComments = currentState.comments
              .where((comment) => comment.id != optimisticComment.id)
              .toList();
          emit(currentState.copyWith(
            comments: revertedComments,
            commentsError: 'Failed to add comment: ${failure.toString()}',
          ));
        },
        (success) {
          // Reload comments to get the real data
          _loadComments(refresh: true);
        },
      );
    }
  }

  // Reply to comment using API
  Future<void> replyToComment(
      String parentCommentId, String replyContent) async {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;

      // Create optimistic reply
      final optimisticReply = CommentEntity(
        id: 'temp_reply_${DateTime.now().millisecondsSinceEpoch}',
        username: '@Me',
        profileImage: '',
        content: replyContent,
        timeAgo: 'Just now',
        likes: 0,
        dislikes: 0,
        isLiked: false,
        isDisliked: false,
        createdAt: DateTime.now(),
        parentCommentId: parentCommentId,
        isReply: true,
      );

      // Find parent comment index and insert reply
      final parentCommentIndex =
          currentState.comments.indexWhere((c) => c.id == parentCommentId);
      if (parentCommentIndex != -1) {
        final updatedComments = List<CommentEntity>.from(currentState.comments);
        updatedComments.insert(parentCommentIndex + 1, optimisticReply);
        emit(currentState.copyWith(comments: updatedComments));

        // Call API
        final result = await _createCommentUseCase(
          CreateCommentParams(
            content: replyContent,
            videoId: talent.id,
            parentCommentId: parentCommentId,
          ),
        );

        result.fold(
          (failure) {
            // Remove optimistic reply on failure
            final revertedComments = currentState.comments
                .where((comment) => comment.id != optimisticReply.id)
                .toList();
            emit(currentState.copyWith(
              comments: revertedComments,
              commentsError: 'Failed to add reply: ${failure.toString()}',
            ));
          },
          (success) {
            // Reload comments to get the real data
            _loadComments(refresh: true);
          },
        );
      }
    }
  }

  // Like/unlike comment using API
  Future<void> likeComment(String commentId) async {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;

      // Optimistic update
      final commentIndex =
          currentState.comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final comment = currentState.comments[commentIndex];
        final wasLiked = comment.isLiked;
        final wasDisliked = comment.isDisliked;

        final updatedComment = comment.copyWith(
          isLiked: !wasLiked,
          isDisliked: false, // Remove dislike if it was disliked
          likes: wasLiked ? comment.likes - 1 : comment.likes + 1,
          dislikes: wasDisliked ? comment.dislikes - 1 : comment.dislikes,
        );

        final updatedComments = List<CommentEntity>.from(currentState.comments);
        updatedComments[commentIndex] = updatedComment;
        emit(currentState.copyWith(comments: updatedComments));

        // Call API
        final result = await _likeCommentUseCase(commentId);

        result.fold(
          (failure) {
            // Revert optimistic update on failure
            final revertedComments =
                List<CommentEntity>.from(currentState.comments);
            revertedComments[commentIndex] = comment;
            emit(currentState.copyWith(
              comments: revertedComments,
              commentsError: 'Failed to like comment: ${failure.toString()}',
            ));
          },
          (success) {
            // Success - keep the optimistic update or reload for accuracy
            _loadComments(refresh: true);
          },
        );
      }
    }
  }

  // Dislike comment using API
  Future<void> dislikeComment(String commentId) async {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;

      // Optimistic update
      final commentIndex =
          currentState.comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final comment = currentState.comments[commentIndex];
        final wasLiked = comment.isLiked;
        final wasDisliked = comment.isDisliked;

        final updatedComment = comment.copyWith(
          isDisliked: !wasDisliked,
          isLiked: false, // Remove like if it was liked
          dislikes: wasDisliked ? comment.dislikes - 1 : comment.dislikes + 1,
          likes: wasLiked ? comment.likes - 1 : comment.likes,
        );

        final updatedComments = List<CommentEntity>.from(currentState.comments);
        updatedComments[commentIndex] = updatedComment;
        emit(currentState.copyWith(comments: updatedComments));

        // Call API
        final result = await _dislikeCommentUseCase(commentId);

        result.fold(
          (failure) {
            // Revert optimistic update on failure
            final revertedComments =
                List<CommentEntity>.from(currentState.comments);
            revertedComments[commentIndex] = comment;
            emit(currentState.copyWith(
              comments: revertedComments,
              commentsError: 'Failed to dislike comment: ${failure.toString()}',
            ));
          },
          (success) {
            // Success - keep the optimistic update or reload for accuracy
            _loadComments(refresh: true);
          },
        );
      }
    }
  }

  // Update comment using API
  Future<void> updateComment(String commentId, String newContent) async {
    final result = await _updateCommentUseCase(
      UpdateCommentParams(commentId: commentId, content: newContent),
    );

    result.fold(
      (failure) {
        if (state is VideoDetailsLoaded) {
          final currentState = state as VideoDetailsLoaded;
          emit(currentState.copyWith(
            commentsError: 'Failed to update comment: ${failure.toString()}',
          ));
        }
      },
      (success) {
        // Reload comments to get updated data
        _loadComments(refresh: true);
      },
    );
  }

  // Delete comment using API
  Future<void> deleteComment(String commentId) async {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;

      // Optimistic update - remove comment immediately
      final updatedComments = currentState.comments
          .where((comment) => comment.id != commentId)
          .toList();
      emit(currentState.copyWith(comments: updatedComments));

      // Call API
      final result = await _deleteCommentUseCase(commentId);

      result.fold(
        (failure) {
          // Reload comments on failure to restore state
          _loadComments(refresh: true);
          emit(currentState.copyWith(
            commentsError: 'Failed to delete comment: ${failure.toString()}',
          ));
        },
        (success) {
          // Success - comment already removed optimistically
          // Optionally reload to ensure consistency
          _loadComments(refresh: true);
        },
      );
    }
  }

  // Refresh comments
  Future<void> refreshComments() async {
    await _loadComments(refresh: true);
  }

  // Generate mock viewers data (keep existing implementation)
  List<ViewerEntity> _generateMockViewers() {
    final viewers = <ViewerEntity>[];
    for (int i = 0; i < 10; i++) {
      viewers.add(ViewerEntity(
        id: 'viewer_$i',
        name: 'Ahmed Mohamed',
        profileImage: '',
        viewTime: DateTime.now().subtract(Duration(minutes: i * 5)),
      ));
    }
    return viewers;
  }

  @override
  Future<void> close() {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;
      currentState.videoController.dispose();
    }
    return super.close();
  }
}
