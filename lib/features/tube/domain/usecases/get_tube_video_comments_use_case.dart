import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/get_tube_video_commnets_entity.dart';
import '../repositories/tube_repo.dart';
import 'get_related_tube_videos_use_case.dart';

class GetTubeVideoCommentsUseCase extends UseCase<TubeVideoCommentsEntity, GetRelatedTubeVideosParams> {
  final TubeRepository _repo;

  GetTubeVideoCommentsUseCase(this._repo);

  @override
  Future<Either<Failure, TubeVideoCommentsEntity>> call(
      GetRelatedTubeVideosParams params) async {
    return await _repo.getTubeVideoComments(params: params);
  }
}
