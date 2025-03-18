import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class TwitterPostReactUseCase extends UseCase<bool, TwitterPostReactParams> {
  final TwitterRepo _repo;
  TwitterPostReactUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(TwitterPostReactParams params) async {
    return await _repo.reactOnPost(params: params);
  }
}

class TwitterPostReactParams {
  final String postId;
  final String react;
  TwitterPostReactParams({
    required this.postId,
    required this.react,
  });
  Map<String, dynamic> toJson() =>
      {'react': react, 'subCategory': '66a3583454e6e337915514db'};
}
