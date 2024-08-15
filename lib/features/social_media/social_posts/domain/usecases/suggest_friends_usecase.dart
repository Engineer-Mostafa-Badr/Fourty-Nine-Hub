import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class SuggestedFriendsUseCase
    extends UseCase<List<SuggestUserEntity>, SuggestedFriendsParams> {
  final SocialPostsRepo _repo;
  SuggestedFriendsUseCase(this._repo);
  @override
  Future<Either<Failure, List<SuggestUserEntity>>> call(
      SuggestedFriendsParams params) async {
    return await _repo.suggestedFriends(params: params);
  }
}

class SuggestedFriendsParams {
  final int limit;
  final int page;
  SuggestedFriendsParams({
    required this.limit,
    required this.page,
  });
  Map<String, dynamic> toJson() => {
        'limit': limit,
        'page': page,
      };
}
