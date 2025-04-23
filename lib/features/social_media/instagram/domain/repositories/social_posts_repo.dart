import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/instagram_post_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/comment_instagram_data_entiry.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/create_post_request_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/data_suggest_follow_instagram_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/followers_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/following_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/profile_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reel_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reels_specific_user_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/single_post_instagram_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/user_tag_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/add_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/create_post_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/delete_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_profile_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_reels_specific_user_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_user_media_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_suggest_follow_instagram_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_tag_use_case.dart';
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
  Future<Either<Failure, ReelInstagramDataEntity>> getReels(
      {required TwitterFeedParams params});
  Future<Either<Failure, ReelsSpecificUserDataEntity>> getReelsSpecificUser(
      {required GetInstagramReelsSpecificUserParams params});
  Future<Either<Failure, List<PostEntity>>> getSavedReels(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getUserReels(
      {required UserReelsParams params});

  Future<Either<Failure, List<FollowersEntity>>> getAllFollowers(
      TwitterFeedParams params);

  Future<Either<Failure, List<FollowingEntity>>> getAllFollowing(
      TwitterFeedParams params);

  Future<Either<Failure, InstagramPostDataModel>> getPosts(
      PaginationParams params);

  Future<Either<Failure, List<UserTagEntity>>> getUserTag(
      GetUserTagParams username);

  Future<Either<Failure, CommentInstagramDataEntiry>> getComment(String postId);

  Future<Either<Failure, bool>> addComment(AddCommentParams params);

  Future<Either<Failure, bool>> deleteComment(DeleteCommentParams params);

  Future<Either<Failure, List<CreatePostRequestEntity>>> createRequestPost(
      CreatePostRequestInstagramParams params);

  Future<Either<Failure, ProfileInstagramDataEntity>> getInstagramProfile(
      GetInstagramProfileParams params);

  Future<Either<Failure, SinglePostInstagramEntity>> getSinglePostInstagram(
      String postId);

  Future<Either<Failure, DataSuggestFollowInstagramEntity>>
      getSuggestFollowInstagram(GetSuggestFollowInstagramParams params);
}
