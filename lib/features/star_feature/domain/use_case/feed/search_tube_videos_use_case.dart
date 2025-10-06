import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../entity/star_entity.dart';
import '../../repository/star_repository.dart';

/// UseCase for searching tube videos
class SearchTubeVideosUseCase {
  final StarRepository repository;

  SearchTubeVideosUseCase(this.repository);

  Future<Either<Failure, List<StarEntity>>> call(String query) async {
    return await repository.searchTubeVideos(query);
  }
}
