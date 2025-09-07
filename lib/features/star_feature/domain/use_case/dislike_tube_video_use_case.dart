import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/star_repository.dart';

class DislikeTubeVideoUseCase extends UseCase<bool, String> {
  final StarRepository _starRepository;

  DislikeTubeVideoUseCase(this._starRepository);

  @override
  Future<Either<Failure, bool>> call(String videoId) async {
    return await _starRepository.dislikeTubeVideo(videoId);
  }
}