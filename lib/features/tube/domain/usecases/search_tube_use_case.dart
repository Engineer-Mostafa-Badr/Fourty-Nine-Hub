import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/get_all_tube_videos_entity.dart';
import '../repositories/tube_repo.dart';

class SearchTubeVideoUseCase extends UseCase<List<GetAllTubeVideosEntity >, SearchTubeParams> {
  final TubeRepository _repo;

  SearchTubeVideoUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetAllTubeVideosEntity>>> call(SearchTubeParams params) async {
    return await _repo.searchTubeVideo(params:params);
  }
}
class SearchTubeParams{
  final int page;
  final int limit;
  final String searchQuery;

  SearchTubeParams({required this.page, required this.limit,required this.searchQuery});

  Map<String,dynamic>toJson()=>{
    "page":page,
    "limit":limit
  };

}
