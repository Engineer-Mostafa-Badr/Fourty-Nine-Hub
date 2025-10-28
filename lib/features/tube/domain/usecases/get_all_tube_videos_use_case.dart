import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/get_all_tube_videos_entity.dart';
import '../repositories/tube_repo.dart';


class GetAllTubeVideosUseCase extends UseCase<List<GetAllTubeVideosEntity  >, GetAllTubeVideosParams> {
  final TubeRepository _repo;

  GetAllTubeVideosUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> call(GetAllTubeVideosParams params) async {
    return await _repo.getAllTubeVideos(params:params);
  }
}
class GetAllTubeVideosParams {
  final int page;
  final int limit;
  final String? userId; // ✅ Optional field

  GetAllTubeVideosParams({
    required this.page,
    required this.limit,
    this.userId, // ✅ Not required
  });

  Map<String, dynamic> toJson() {
    final data = {
      "page": page,
      "limit": limit,
    };


    return data;
  }
}
