import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/get_all_tube_videos_entity.dart';
import '../repositories/tube_repo.dart';

class GetRelatedTubeVideosUseCase
    extends UseCase<List<GetAllTubeVideosEntity>, GetRelatedTubeVideosParams> {
  final TubeRepository _repo;

  GetRelatedTubeVideosUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> call(
      GetRelatedTubeVideosParams params) async {
    return await _repo.getRelatedTubeVideos(params: params);
  }
}

class GetRelatedTubeVideosParams {
  final String id;
  final int page;
  final int limit;

  GetRelatedTubeVideosParams({
    required this.id,
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toJson() => {"page": page, "limit": limit};
}
