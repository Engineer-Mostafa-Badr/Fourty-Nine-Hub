import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetUserTweetsUseCase
    extends UseCase<List<TwitterPostEntity>, GetUserTweetsParams> {
  final TwitterRepo _repo;
  GetUserTweetsUseCase(this._repo);
  @override
  Future<Either<Failure, List<TwitterPostEntity>>> call(
      GetUserTweetsParams params) async {
    return await _repo.getUserPosts(params: params);
  }
}

class GetUserTweetsParams {
  final int page;
  final String userId;

  GetUserTweetsParams({required this.page, required this.userId});
  Map<String, dynamic> toJson() => {
        'page': page,
        'userId': userId,
      };
}
