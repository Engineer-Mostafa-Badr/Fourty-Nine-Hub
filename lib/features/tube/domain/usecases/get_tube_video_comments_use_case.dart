import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/get_tube_video_commnets_entity.dart';
import '../repositories/tube_repo.dart';

class GetTubeVideoCommentsUseCase
    extends UseCase<TubeVideoCommentsEntity, GetTubeCommentsParams> {
  final TubeRepository _repo;

  GetTubeVideoCommentsUseCase(this._repo);

  @override
  Future<Either<Failure, TubeVideoCommentsEntity>> call(
      GetTubeCommentsParams params) async {
    return await _repo.getTubeVideoComments(params: params);
  }
}

class GetTubeCommentsParams {
  final int page;
  final int limit;
  final String? userId; // ✅ Optional field
  final String id;

  GetTubeCommentsParams({
    required this.id,
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
