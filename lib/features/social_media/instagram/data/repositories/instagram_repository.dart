import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../datasources/instagram_data_source.dart';
import '../models/media_post_request_model.dart';

class InstagramRepository {
  final InstagramDataSource dataSource;

  InstagramRepository({required this.dataSource});

  Future<Either<Failure, Map<String, dynamic>>> getComments({required String postId, required int page, required int limit}) async {
    return dataSource.getComments(postId: postId, page: page, limit: limit);
  }
  Future<Either<Failure, Map<String, dynamic>>> createComment({required String content, required String postId}) async {
    return dataSource.createComment(content: content, postId: postId);
  }
  Future<Either<Failure, Map<String, dynamic>>> updateComment({required String content, required String postId, required String commentId}) async {
    return dataSource.updateComment(content: content, postId: postId, commentId: commentId);
  }
  Future<Either<Failure, Map<String, dynamic>>> likeComment({required String postId, required String commentId}) async {
    return dataSource.likeComment(postId: postId, commentId: commentId);
  }
  Future<Either<Failure, Map<String, dynamic>>> deleteLikeComment({required String postId, required String commentId}) async {
    return dataSource.deleteLikeComment(postId: postId, commentId: commentId);
  }
  Future<Either<Failure, Map<String, dynamic>>> getPosts({required int page, required int limit}) async {
    return dataSource.getPosts(limit: limit, page: page);
  }
  Future<Either<Failure, Map<String, dynamic>>> getPostsById({required String postId}) async {
    return dataSource.getPostsById(postId: postId);
  }
  Future<Either<Failure, Map<String, dynamic>>> getPostTags({required int page, required int limit}) async {
    return dataSource.getPostTags(limit: limit, page: page);
  }
  Future<Either<Failure, Map<String, dynamic>>> getPostFavorite() async {
    return dataSource.getPostFavorite();
  }
  Future<Either<Failure, Map<String, dynamic>>> createPost({required String content, required List<MediaPostRequestModel> media}) async {
    return dataSource.createPost(content: content, media: media);
  }
  Future<Either<Failure, Map<String, dynamic>>> postConfirmWebhook({required List<String> mediaIds}) async {
    return dataSource.postConfirmWebhook(mediaIds: mediaIds);
  }
  Future<Either<Failure, Map<String, dynamic>>> updatePost({required String postId, required String content}) async {
    return dataSource.updatePost(postId: postId, content: content);
  }
  Future<Either<Failure, Map<String, dynamic>>> addToFavorite({required String postId}) async {
    return dataSource.addToFavorite(postId: postId);
  }
  Future<Either<Failure, Map<String, dynamic>>> deletePost({required List<String> postIds}) async {
    return dataSource.deletePost(postIds: postIds);
  }
  Future<Either<Failure, Map<String, dynamic>>> unFavoritePost({required String postId}) async {
    return dataSource.unFavoritePost(postId: postId);
  }
  Future<Either<Failure, Map<String, dynamic>>> likePost({required String postId}) async {
    return dataSource.likePost(postId: postId);
  }
  Future<Either<Failure, Map<String, dynamic>>> followUser({required String userId}) async {
    return dataSource.followUser(userId: userId);
  }
  Future<Either<Failure, Map<String, dynamic>>> unFollow({required String userId}) async {
    return dataSource.unFollow(userId: userId);
  }
}