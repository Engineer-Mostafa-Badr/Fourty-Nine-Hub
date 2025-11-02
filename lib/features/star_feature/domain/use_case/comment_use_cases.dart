// lib/features/star_feature/domain/use_case/comment_use_cases.dart
import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/star_repository.dart';
import '../../data/model/comment_model.dart';

// Create Comment Use Case
class CreateCommentParams {
  final String content;
  final String videoId;
  final String? parentCommentId;

  CreateCommentParams({
    required this.content,
    required this.videoId,
    this.parentCommentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'videoId': videoId,
      if (parentCommentId != null) 'parentCommentId': parentCommentId,
    };
  }
}

class CreateCommentUseCase extends UseCase<String, CreateCommentParams> {
  final StarRepository _repository;

  CreateCommentUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(CreateCommentParams params) async {
    return await _repository.createComment(params);
  }
}

// Get Comments Use Case
class GetCommentsParams {
  final String videoId;
  final int page;
  final int limit;

  GetCommentsParams({
    required this.videoId,
    this.page = 1,
    this.limit = 20,
  });
}

class GetCommentsUseCase
    extends UseCase<CommentsListResponse, GetCommentsParams> {
  final StarRepository _repository;

  GetCommentsUseCase(this._repository);

  @override
  Future<Either<Failure, CommentsListResponse>> call(
      GetCommentsParams params) async {
    return await _repository.getVideoComments(params);
  }
}

// Update Comment Use Case
class UpdateCommentParams {
  final String commentId;
  final String content;

  UpdateCommentParams({
    required this.commentId,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}

class UpdateCommentUseCase extends UseCase<String, UpdateCommentParams> {
  final StarRepository _repository;

  UpdateCommentUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(UpdateCommentParams params) async {
    return await _repository.updateComment(params);
  }
}

// Delete Comment Use Case
class DeleteCommentUseCase extends UseCase<String, String> {
  final StarRepository _repository;

  DeleteCommentUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(String commentId) async {
    return await _repository.deleteComment(commentId);
  }
}

// Like Comment Use Case
class LikeCommentUseCase extends UseCase<String, String> {
  final StarRepository _repository;

  LikeCommentUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(String commentId) async {
    return await _repository.likeComment(commentId);
  }
}

// Dislike Comment Use Case
class DislikeCommentUseCase extends UseCase<String, String> {
  final StarRepository _repository;

  DislikeCommentUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(String commentId) async {
    return await _repository.dislikeComment(commentId);
  }
}
