import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/place_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/friends-followers_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../entities/activity_entity.dart';
import '../entities/feeling_entity.dart';

abstract class CreatePostRepo {
  Future<Either<Failure, List<FeelingEntity>>> getFeelingsList(PaginationParams params);
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesList();
  Future<Either<Failure, bool>> postData({required Map<String, dynamic> data});
  Future<Either<Failure, List<PostUserEntity>>> getFriendsFollowers(
      {required FriendsFollowersParams params});
  Future<Either<Failure, List<PlaceEntity>>> getPlaces(
      {required FriendsFollowersParams params});
  Future<Either<Failure, bool>> createTwitterPost(
      {required CreateTwitterPostParams params});
}
