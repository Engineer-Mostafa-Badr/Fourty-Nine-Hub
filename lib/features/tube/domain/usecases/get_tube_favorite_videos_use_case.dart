import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/tube/domain/usecases/get_all_tube_videos_use_case.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/get_all_tube_videos_entity.dart';
import '../repositories/tube_repo.dart';


class GetTubeFavoriteVideosUseCase extends UseCase<List<GetAllTubeVideosEntity  >, GetAllTubeVideosParams> {
  final TubeRepository _repo;

  GetTubeFavoriteVideosUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> call(GetAllTubeVideosParams params) async {
    return await _repo.getTubeFavoriteVideos(params:params);
  }
}
