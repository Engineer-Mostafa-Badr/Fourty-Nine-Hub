

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class RequestDocumentUseCase extends UseCase<bool, List<String>> {
  final TwitterRepo _repo;
  RequestDocumentUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(List<String> params) async {
    return await _repo.requestDocument(params: params);
  }
}

