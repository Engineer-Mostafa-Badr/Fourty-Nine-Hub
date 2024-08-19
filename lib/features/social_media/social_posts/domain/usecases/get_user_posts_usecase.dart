import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetUserPostsUseCase extends UseCase<List<PostEntity>, UserPostsParams> {
  final SocialPostsRepo _repo;
  GetUserPostsUseCase(this._repo);
  @override
  Future<Either<Failure, List<PostEntity>>> call(UserPostsParams params) async {
    return await _repo.getUserPosts(params: params);
  }
}

class UserPostsParams{
  final int page;
  final int limit;
  final String userId;
  UserPostsParams({
    required this.page,
    required this.limit,
    required this.userId,
  });
  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
  };
}
