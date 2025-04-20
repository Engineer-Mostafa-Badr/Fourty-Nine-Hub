import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class AddCommentUseCase extends UseCase<bool, AddCommentParams> {
  final InstagramRepo _repo;
  AddCommentUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(AddCommentParams params) async {
    return await _repo.addComment(params);
  }
}

class AddCommentParams {
  final String postId;
  final String contentComment;

  AddCommentParams({
    required this.postId,
    required this.contentComment,
  });
}
