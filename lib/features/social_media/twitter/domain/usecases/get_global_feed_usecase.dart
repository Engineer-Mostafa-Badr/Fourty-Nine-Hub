import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetTwitterGlobalFeedUseCase extends UseCase<List<TwitterPostEntity>, TwitterFeedParams> {
  final TwitterRepo _repo;
  GetTwitterGlobalFeedUseCase(this._repo);
  @override
  Future<Either<Failure, List<TwitterPostEntity>>> call(TwitterFeedParams params) async {
    return await _repo.getGlobalFeed(params: params);
  }
}

