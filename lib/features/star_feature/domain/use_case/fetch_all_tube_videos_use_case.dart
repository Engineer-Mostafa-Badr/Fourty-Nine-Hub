import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/tube_video_models.dart';
import '../repository/star_repository.dart';
import 'fetch_all_star_use_case.dart';

class FetchAllTubeVideosUseCase
    extends UseCase<TubeVideoListResponse, StarPaginationParams> {
  final StarRepository _starRepository;

  FetchAllTubeVideosUseCase(this._starRepository);

  @override
  Future<Either<Failure, TubeVideoListResponse>> call(
      StarPaginationParams params) async {
    return await _starRepository.fetchAllTubeVideos(params);
  }
}