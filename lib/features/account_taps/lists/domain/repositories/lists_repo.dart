import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/error/failure.dart';

abstract class ListsRepo {
  Future<Either<Failure, List<UserFriendEntity>>> getFriendsList({required TwitterFeedParams params});
  Future<Either<Failure, List<UserFriendEntity>>> getFollowers({required TwitterFeedParams params});
  Future<Either<Failure, List<UserFriendEntity>>> getFreindRequests({required TwitterFeedParams params});
  Future<Either<Failure, List<UserFriendEntity>>> getBlockedUsers({required TwitterFeedParams params});
}
