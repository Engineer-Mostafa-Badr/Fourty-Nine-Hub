import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/repositories/create_post_repo.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../twitter/domain/repositories/twitter_repo.dart';

class FriendsFollowersUseCase extends UseCase<List<PostUserEntity>, FriendsFollowersParams> {
  final CreatePostRepo _repo;
  FriendsFollowersUseCase(this._repo);
  @override
  Future<Either<Failure, List<PostUserEntity>>> call(FriendsFollowersParams params) async {
    return await _repo.getFriendsFollowers(params: params);
  }
}

class FriendsFollowersParams {
  final String search;
  final int limit;
  final int page;
  FriendsFollowersParams({
    required this.search,
    required this.limit,
    required this.page,
  });
  Map<String, dynamic> toJson() => {
        'String': String,
        'limit': limit,
  'page':'page'
      };
}
