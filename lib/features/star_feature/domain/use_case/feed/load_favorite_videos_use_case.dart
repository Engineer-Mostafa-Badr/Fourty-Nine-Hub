import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../entity/star_entity.dart';
import '../../repository/star_repository.dart';

/// UseCase for loading favorite videos
class LoadFavoriteVideosUseCase {
  final StarRepository repository;

  LoadFavoriteVideosUseCase(this.repository);

  Future<Either<Failure, List<StarEntity>>> call() async {
    return await repository.getFavoriteVideos();
  }
}
