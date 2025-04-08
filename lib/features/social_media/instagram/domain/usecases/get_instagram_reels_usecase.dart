import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reel_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetInstagramReelsUseCase
    extends UseCase<ReelInstagramDataEntity, TwitterFeedParams> {
  final InstagramRepo _repo;
  GetInstagramReelsUseCase(this._repo);
  @override
  Future<Either<Failure, ReelInstagramDataEntity>> call(
      TwitterFeedParams params) async {
    return await _repo.getReels(params: params);
  }
}
