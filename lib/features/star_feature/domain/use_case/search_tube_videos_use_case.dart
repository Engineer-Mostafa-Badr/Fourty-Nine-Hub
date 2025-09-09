import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/tube_video_models.dart';
import '../repository/star_repository.dart';

class SearchTubeVideosParams {
  final String query;

  SearchTubeVideosParams({required this.query});
}

class SearchTubeVideosUseCase extends UseCase<List<TubeVideoModel>, SearchTubeVideosParams> {
  final StarRepository _starRepository;

  SearchTubeVideosUseCase(this._starRepository);

  @override
  Future<Either<Failure, List<TubeVideoModel>>> call(SearchTubeVideosParams params) async {
    return await _starRepository.searchTubeVideos(params.query);
  }
}