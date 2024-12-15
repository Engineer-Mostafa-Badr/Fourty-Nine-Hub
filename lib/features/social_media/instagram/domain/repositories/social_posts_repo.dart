import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/followers_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/following_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_user_media_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/error/failure.dart';

abstract class InstagramRepo {
  Future<Either<Failure, List<PostEntity>>> getFeed(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getUserMedia(
      {required InstagramUserMediaParams params});
  Future<Either<Failure, List<PostEntity>>> getGlobalFeed(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getReels(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getSavedReels(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getUserReels(
      {required UserReelsParams params});

  Future<Either<Failure, List<FollowersEntity>>> getAllFollowers(TwitterFeedParams params);

  Future<Either<Failure, List<FollowingEntity>>> getAllFollowing(TwitterFeedParams params);
}
