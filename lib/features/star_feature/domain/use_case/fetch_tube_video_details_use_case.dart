import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/star_entity.dart';
import '../repository/star_repository.dart';

class FetchTubeVideoDetailsUseCase
    extends UseCase<StarEntity, String> {
  final StarRepository _starRepository;

  FetchTubeVideoDetailsUseCase(this._starRepository);

  @override
  Future<Either<Failure, StarEntity>> call(String videoId) async {
    return await _starRepository.fetchTubeVideoDetails(videoId);
  }
}