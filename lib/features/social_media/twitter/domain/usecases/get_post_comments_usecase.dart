import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetTwitterPostCommentsUseCase extends UseCase<List<TwitterPostCommentEntity>, String> {
  final TwitterRepo _repo;
  GetTwitterPostCommentsUseCase(this._repo);
  @override
  Future<Either<Failure, List<TwitterPostCommentEntity>>> call(String params) async {
    return await _repo.getPostComments(postId: params);
  }
}
