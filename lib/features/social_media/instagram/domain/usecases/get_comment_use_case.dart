import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/comment_instagram_data_entiry.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetCommentUseCase extends UseCase<CommentInstagramDataEntiry, String> {
  final InstagramRepo _repo;
  GetCommentUseCase(this._repo);
  @override
  Future<Either<Failure, CommentInstagramDataEntiry>> call(
      String params) async {
    return await _repo.getComment(params);
  }
}
