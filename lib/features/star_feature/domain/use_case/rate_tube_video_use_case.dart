import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/star_repository.dart';

class RateTubeVideoParams {
  final String videoId;
  final double rate;

  RateTubeVideoParams({required this.videoId, required this.rate});
}

class RateTubeVideoUseCase extends UseCase<bool, RateTubeVideoParams> {
  final StarRepository _starRepository;

  RateTubeVideoUseCase(this._starRepository);

  @override
  Future<Either<Failure, bool>> call(RateTubeVideoParams params) async {
    return await _starRepository.rateTubeVideo(params.videoId, params.rate);
  }
}