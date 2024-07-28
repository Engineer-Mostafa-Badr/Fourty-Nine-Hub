import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetTwitterFeedUseCase extends UseCase<List<TwitterPostEntity>, TwitterFeedParams> {
  final TwitterRepo _repo;
  GetTwitterFeedUseCase(this._repo);
  @override
  Future<Either<Failure, List<TwitterPostEntity>>> call( TwitterFeedParams params) async {
    return await _repo.getFeed(params: params);
  }
}

class TwitterFeedParams {
  final int page;
  final int limit;
  TwitterFeedParams({
    required this.page,
    required this.limit,
  });
  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
  };
}
