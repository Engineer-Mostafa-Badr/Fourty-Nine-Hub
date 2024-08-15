import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class PostReactUseCase extends UseCase<bool, PostReactParams> {
  final SocialPostsRepo _repo;
  PostReactUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(PostReactParams params) async {
    return await _repo.reactOnPost(params: params);
  }
}

class PostReactParams {
  final String postId;
  final String react;
  PostReactParams({
    required this.postId,
    required this.react,
  });
  Map<String, dynamic> toJson() => {
        'react': react,
      };
}
