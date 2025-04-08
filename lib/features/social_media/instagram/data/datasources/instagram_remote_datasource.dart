import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/followers_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/following_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/instagram_post_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/reel_instagram_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/user_tag_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/followers_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/following_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reel_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/user_tag_entity.dart';
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

    return response.fold((l) {
      return Left(l);
    }, (response) {
      // final dataPosts = InstagramPostDataModel.fromJson(data);
      return Right(InstagramPostDataModel.fromJson(response['data']));
    });
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
}
