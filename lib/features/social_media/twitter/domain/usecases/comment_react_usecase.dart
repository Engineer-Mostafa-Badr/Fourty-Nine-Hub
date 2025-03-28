import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class TwitterCommentReactUseCase
    extends UseCase<bool, TwitterCommentReactParams> {
  final TwitterRepo _repo;
  TwitterCommentReactUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(TwitterCommentReactParams params) async {
    return await _repo.reactOnComment(params: params);
  }
}

class TwitterCommentReactParams {
  final String commentId;
  final String react;
  TwitterCommentReactParams({
    required this.commentId,
    required this.react,
  });
  Map<String, dynamic> toJson() => {
        'react': react,
      };
}
