import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/entity/comment_entity.dart';
import '../../../domain/entity/star_entity.dart';
import '../../../domain/entity/viewer_entity.dart';

part 'video_details_state.dart';

class VideoDetailsCubit extends Cubit<VideoDetailsState> {
  final String mediaUrl;
  final StarEntity talent;
  final VoidCallback? onBack;
  late VideoPlayerController _videoController;

  VideoDetailsCubit({
    required this.mediaUrl,
    required this.talent,
    this.onBack,
  }) : super(VideoDetailsInitial());

  // Initialize the video and load data
  Future<void> initialize() async {
    emit(VideoDetailsLoading());

    try {
      await _initializeVideo();
      final viewers = _generateMockViewers();
      final comments = _generateMockComments();

      emit(VideoDetailsLoaded(
        videoController: _videoController,
        isInitialized: true,
        isPlaying: true,
        isMuted: true,
        viewers: viewers,
        comments: comments,
        talent: talent,
      ));
    } catch (e) {
      emit(VideoDetailsError(message: 'Failed to initialize video: $e'));
    }
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.network(mediaUrl);

    await _videoController.initialize();
    _videoController.setVolume(0); // Start muted
    _videoController.play();
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

  // Add new comment
  void addComment(String content) {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;

      final newComment = CommentEntity(
        id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
        username: '@Me',
        profileImage: '',
        content: content,
        timeAgo: 'Just now',
        likes: 0,
        isLiked: false,
        createdAt: DateTime.now(),
      );

      final updatedComments = [newComment, ...currentState.comments];

      emit(currentState.copyWith(comments: updatedComments));
    }
  }

  // Like/unlike comment
  void likeComment(String commentId) {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;

      final commentIndex =
          currentState.comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final comment = currentState.comments[commentIndex];
        final updatedComment = comment.copyWith(
          isLiked: !comment.isLiked,
          likes: comment.isLiked ? comment.likes - 1 : comment.likes + 1,
        );

        final updatedComments = List<CommentEntity>.from(currentState.comments);
        updatedComments[commentIndex] = updatedComment;

        emit(currentState.copyWith(comments: updatedComments));
      }
    }
  }

  // Reply to comment
  void replyToComment(String parentCommentId, String replyContent) {
    if (state is VideoDetailsLoaded) {
      final currentState = state as VideoDetailsLoaded;

      final parentCommentIndex =
          currentState.comments.indexWhere((c) => c.id == parentCommentId);
      if (parentCommentIndex != -1) {
        final replyComment = CommentEntity(
          id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
          username: '@Me',
          profileImage: '',
          content: replyContent,
          timeAgo: 'Just now',
          likes: 0,
          isLiked: false,
          createdAt: DateTime.now(),
          parentCommentId: parentCommentId,
          isReply: true,
        );

        final updatedComments = List<CommentEntity>.from(currentState.comments);
        updatedComments.insert(parentCommentIndex + 1, replyComment);

        emit(currentState.copyWith(comments: updatedComments));
      }
    }
  }

  // Generate mock viewers data
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

  // Generate mock comments data
  List<CommentEntity> _generateMockComments() {
    return [
      CommentEntity(
        id: 'comment_1',
        username: '@Ahmed',
        profileImage: '',
        content: 'Heart Touching Nasheed',
        timeAgo: '1 Month Ago',
        likes: 4,
        isLiked: false,
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
      CommentEntity(
        id: 'comment_2',
        username: '@Mohamed',
        profileImage: '',
        content: 'Beautiful voice and melody',
        timeAgo: '2 Weeks Ago',
        likes: 2,
        isLiked: false,
        createdAt: DateTime.now().subtract(Duration(days: 14)),
      ),
      CommentEntity(
        id: 'comment_3',
        username: '@Ali',
        profileImage: '',
        content: 'This brings peace to my heart',
        timeAgo: '1 Week Ago',
        likes: 6,
        isLiked: false,
        createdAt: DateTime.now().subtract(Duration(days: 7)),
      ),
    ];
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
