import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/media_post_request_model.dart';

class InstagramDataSource {
  final ApiConsumer api;

  InstagramDataSource({required this.api});

  //Comment
  Future<Either<Failure, Map<String, dynamic>>> getComments(
      {required String postId, required int page, required int limit}) {
    return api.get("/inst/posts/$postId/comments?page=$page&limit=$limit");
  }

  Future<Either<Failure, Map<String, dynamic>>> createComment({required String content, required String postId}) {
    return api.post("/inst/posts/$postId/comments", data: {"content": content});
  }

  Future<Either<Failure, Map<String, dynamic>>> updateComment(
      {required String content,
      required String postId,
      required String commentId}) {
    return api.put("/inst/posts/$postId/comments/$commentId",
        data: {"content": content});
  }

  Future<Either<Failure, Map<String, dynamic>>> likeComment(
      {
      required String postId,
      required String commentId}) {
    return api.post("/inst/posts/$postId/comments/$commentId/like",);
  }

  Future<Either<Failure, Map<String, dynamic>>> deleteLikeComment(
      {
      required String postId,
      required String commentId}) {
    return api.delete("/inst/posts/$postId/comments/$commentId/un-like",);
  }

  Future<Either<Failure, Map<String, dynamic>>> deleteComment(
      {required String content,
      required String postId,
      required String commentId}) {
    return api.delete("/inst/posts/$postId/comments/$commentId",
        data: {"content": content});
  }

  //Post
  Future<Either<Failure, Map<String, dynamic>>> getPosts({required int page, required int limit}) {
    return api.get("inst/posts?page=$page&limit=$limit");
  }

  Future<Either<Failure, Map<String, dynamic>>> getPostsById({required String postId}) {
    return api.get("inst/posts/$postId");
  }

  Future<Either<Failure, Map<String, dynamic>>> getPostTags({required int page, required int limit}) {
    return api.get("inst/posts/tags?page=$page&limit=$limit");
  }

  Future<Either<Failure, Map<String, dynamic>>> getPostFavorite() {
    return api.get("inst/posts/favorite");
  }

  Future<Either<Failure, Map<String, dynamic>>> createPost(
      {required String content, required List<MediaPostRequestModel> media}) {
    return api.post(
      "/inst/posts/create-request",
      data: {
        "content": content,
        "media": media.map((e) => e.tojson()).toList()
      },
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> postConfirmWebhook({required List<String> mediaIds}) {
    return api.post(
      "inst/posts/confirm-webhook",
      data: {"mediaIds": mediaIds},
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> updatePost({required String postId, required String content}) {
    return api.put(
      "inst/posts/$postId",
      data: {"content": content},
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> addToFavorite({required String postId}) {
    return api.put("inst/posts/$postId/favorite");
  }

  Future<Either<Failure, Map<String, dynamic>>> deletePost({required List<String> postIds}) {
    return api.delete(
      "inst/posts",
      data: {"postIds": postIds},
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> unFavoritePost({required String postId}) {
    return api.delete("inst/posts/$postId/unfavorite");
  }

  //Like
  Future<Either<Failure, Map<String, dynamic>>> likePost({required String postId}) {
    return api.put("/inst/posts/$postId/like");
  }

  //Follow
  Future<Either<Failure, Map<String, dynamic>>> followUser({required String userId}) {
    return api.post("inst/follows/$userId");
  }
  Future<Either<Failure, Map<String, dynamic>>> unFollow({required String userId}) {
    return api.delete("inst/follows/$userId");
  }
}
