import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/get_all_tube_videos_entity.dart';
import '../repositories/tube_repo.dart';
import 'get_all_tube_videos_use_case.dart';


class GetHistoryTubeVideosUseCase extends UseCase<List<GetAllTubeVideosEntity  >, GetAllTubeVideosParams> {
  final TubeRepository _repo;

  GetHistoryTubeVideosUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> call(GetAllTubeVideosParams params) async {
    return await _repo.getHistoryTubeVideos(params:params);
  }
}

