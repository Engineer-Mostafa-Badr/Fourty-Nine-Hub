import 'package:dartz/dartz.dart';
import 'post_react_usecase.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class CommentReactUseCase extends UseCase<bool, PostReactParams> {
  final SocialPostsRepo _repo;
  CommentReactUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(PostReactParams params) async {
    return await _repo.reactOnComment(params: params);
  }
}
