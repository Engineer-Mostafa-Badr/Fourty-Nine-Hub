import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/comment_instagram_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/followers_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/following_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/instagram_post_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/reel_instagram_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/user_tag_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/comment_instagram_data_entiry.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/followers_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/following_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reel_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/user_tag_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/add_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/delete_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_user_media_usecase.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/post_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/error/failure.dart';

abstract class InstagramRemoteDataSource {
  Future<Either<Failure, List<PostEntity>>> getFeed(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getUserMedia(
      {required InstagramUserMediaParams params});
  Future<Either<Failure, List<PostEntity>>> getGlobalFeed(
      {required TwitterFeedParams params});
  Future<Either<Failure, ReelInstagramDataEntity>> getReels(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getUserReels(
      {required UserReelsParams params});
  Future<Either<Failure, List<PostEntity>>> getSavedReels(
      {required TwitterFeedParams params});

  Future<Either<Failure, List<FollowersEntity>>> getAllFollowers(
      TwitterFeedParams params);

  Future<Either<Failure, List<FollowingEntity>>> getAllFollowing(
      TwitterFeedParams params);
  Future<Either<Failure, InstagramPostDataModel>> getPosts(
      PaginationParams params);
  Future<Either<Failure, List<UserTagEntity>>> getUserTag(String username);

  Future<Either<Failure, CommentInstagramDataEntiry>> getComment(String postId);

  Future<Either<Failure, bool>> addComment(AddCommentParams params);

  Future<Either<Failure, bool>> deleteComment(DeleteCommentParams params);
}

class InstagramRemoteDataSourceImpl implements InstagramRemoteDataSource {
  final ApiConsumer _apiConsumer;
  InstagramRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<PostEntity>>> getFeed(
      {required TwitterFeedParams params}) async {
    final response =
        await _apiConsumer.get(EndPoints.getInstagramPosts(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserMedia(
      {required InstagramUserMediaParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getUserMedia(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getGlobalFeed(
      {required TwitterFeedParams params}) async {
    final response =
        await _apiConsumer.get(EndPoints.getInstagramGlobalPosts(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, ReelInstagramDataEntity>> getReels(
      {required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getReels(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final responseData = ReelInstagramDataModel.fromJson(data['data']);
      return Right(responseData);
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserReels(
      {required UserReelsParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getUserReels(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['reels']['reels'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getSavedReels(
      {required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getSavedReels(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['reels'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<FollowersEntity>>> getAllFollowers(
      TwitterFeedParams params) async {
    final response = await _apiConsumer.get(EndPoints.followers(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['followers'] as List)
          .map((e) => FollowersModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<FollowingEntity>>> getAllFollowing(
      TwitterFeedParams params) async {
    final response = await _apiConsumer.get(EndPoints.following(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data'] as List)
          .map((e) => FollowingModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, InstagramPostDataModel>> getPosts(
      PaginationParams params) async {
    final response =
        await _apiConsumer.get(EndPoints.getPostsInstagram(params));

    try {
      return response.fold((l) {
        return Left(l);
      }, (response) {
        // final dataPosts = InstagramPostDataModel.fromJson(data);
        return Right(InstagramPostDataModel.fromJson(response['data']));
      });
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, List<UserTagEntity>>> getUserTag(
      String username) async {
    final response = await _apiConsumer.get(
      EndPoints.getUserTag,
      data: {
        "username": username,
      },
    );

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['tags'] as List)
          .map((e) => UserTagModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, CommentInstagramDataEntiry>> getComment(
      String postId) async {
    final response = await _apiConsumer.get(
      EndPoints.getCommentInstagram(postId),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          final responseData = CommentInstagramDataModel.fromJson(data['data']);
          return Right(responseData);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> addComment(AddCommentParams params) async {
    final response = await _apiConsumer.post(
        EndPoints.addCommentInstagram(params.postId),
        data: {"content": params.contentComment});

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          return const Right(true);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteComment(
      DeleteCommentParams params) async {
    final response = await _apiConsumer.delete(
      EndPoints.deleteCommentInstagram(params.postId, params.commentId),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          return const Right(true);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }
}
