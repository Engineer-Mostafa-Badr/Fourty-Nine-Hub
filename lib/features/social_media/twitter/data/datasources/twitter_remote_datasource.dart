import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/constants/constants.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_comment_reply_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_post_comment_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_post_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/request_document_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';

import '../../../../../core/error/failure.dart';

abstract class TwitterRemoteDataSource {
  Future<Either<Failure, List<TwitterPostEntity>>> getFeed(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<TwitterPostEntity>>> getGlobalFeed(
      {required TwitterFeedParams params});
  Future<Either<Failure, TwitterPostEntity>> getTwitterPost(
      {required String postId});
  Future<Either<Failure, List<TwitterPostEntity>>> getUserPosts(
      {required GetUserTweetsParams params});

  Future<Either<Failure, bool>> reactOnPost({required params});
  Future<Either<Failure, bool>> reactOnComment({required params});
  Future<Either<Failure, bool>> deleteComment({required String commentId});
  Future<Either<Failure, bool>> editComment(
      {required TwitterPostCommentParams params});
  Future<Either<Failure, bool>> sharePost({required params});
  Future<Either<Failure, bool>> addReport(
      {required TwitterReportParams params});
  Future<Either<Failure, TwitterPostCommentEntity>> commentOnTwitterPost(
      {required TwitterPostCommentParams params});
  Future<Either<Failure, TwitterCommentReplyEntity>> replyOnComment(
      {required TwitterCommentReplyParams params});
  Future<Either<Failure, List<TwitterPostCommentEntity>>> getPostComments(
      {required PostCommentsParams params});
  Future<Either<Failure, List<TwitterCommentReplyEntity>>> getCommentReplies(
      {required PostCommentsParams params});

  Future<Either<Failure, bool>> deletePost({required String postId});
  Future<Either<Failure, bool>> hidePost({required String postId});
  Future<Either<Failure, bool>> requestDocument(
      {required TwitterDocumentationParams params});
}

class TwitterRemoteDataSourceImpl implements TwitterRemoteDataSource {
  final ApiConsumer _apiConsumer;
  TwitterRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<TwitterPostEntity>>> getFeed(
      {required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(
        "${EndPoints.getTwitterFeedPosts}?page=${params.page}&limit=${params.limit}&subCategory=66a3583454e6e337915514db");

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => TwitterPostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<TwitterPostEntity>>> getGlobalFeed(
      {required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(
      "${EndPoints.getTwitterFeedPosts}/general?page=${params.page}&limit=${params.limit}&subCategory=66a3583454e6e337915514db",
    );

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => TwitterPostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, TwitterPostEntity>> getTwitterPost(
      {required String postId}) async {
    final response = await _apiConsumer.get(
        "/twitter/post/$postId?subCategory=${Constants.twitterSubCategory}");

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final model = TwitterPostModel.fromJson(data['data'][0]);
      return Right(model);
    });
  }

  @override
  Future<Either<Failure, List<TwitterPostEntity>>> getUserPosts(
      {required GetUserTweetsParams params}) async {
    print("object");
    final response = await _apiConsumer.get(EndPoints.userTweets(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => TwitterPostModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> reactOnPost({required params}) async {
    final response = await _apiConsumer.post(
        EndPoints.reactOnTwitterPost(params.postId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> reactOnComment({required params}) async {
    final response = await _apiConsumer.post(
        EndPoints.reactOnTwitterComment(params.commentId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> sharePost({required params}) async {
    final response =
        await _apiConsumer.post(EndPoints.shareTwitterPost(params));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, TwitterPostCommentEntity>> commentOnTwitterPost(
      {required TwitterPostCommentParams params}) async {
    final response = await _apiConsumer.post(
        EndPoints.commentOnTwitterPost(params.postId),
        data: params.toJson());
    return response.fold((l) => Left(l),
        (data) => Right(TwitterPostCommentModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, TwitterCommentReplyEntity>> replyOnComment(
      {required TwitterCommentReplyParams params}) async {
    final response = await _apiConsumer
        .post(EndPoints.commentOnTwitterPost(params.postId), data: {
      'content': params.content,
      'reply': params.reply,
      // 'subCategory':'66a3583454e6e337915514db'
    });
    return response.fold((l) => Left(l),
        (data) => Right(TwitterCommentReplyModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, List<TwitterPostCommentEntity>>> getPostComments(
      {required PostCommentsParams params}) async {
    final response =
        await _apiConsumer.get(EndPoints.getTwitterPostComments(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['comments'] as List)
            .map((e) => TwitterPostCommentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<TwitterCommentReplyEntity>>> getCommentReplies(
      {required PostCommentsParams params}) async {
    final response =
        await _apiConsumer.get(EndPoints.getTwitterCommentReplies(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['replies'] as List)
            .map((e) => TwitterCommentReplyModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> deletePost({required String postId}) async {
    final response =
        await _apiConsumer.delete(EndPoints.deleteTwitterPost(postId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> hidePost({required String postId}) async {
    final response = await _apiConsumer.put(EndPoints.hideTwitterPost(postId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> addReport(
      {required TwitterReportParams params}) async {
    final response = await _apiConsumer.post(
        EndPoints.report(subCategoryId: params.categoryId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> requestDocument(
      {required TwitterDocumentationParams params}) async {
    final response = await _apiConsumer.post(EndPoints.documentRequest,
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> deleteComment(
      {required String commentId}) async {
    final response = await _apiConsumer.delete(
      EndPoints.deleteTwitterComment(commentId),
    );
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> editComment(
      {required TwitterPostCommentParams params}) async {
    final response = await _apiConsumer.put(
        EndPoints.editTwitterComment(params.postId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }
}
