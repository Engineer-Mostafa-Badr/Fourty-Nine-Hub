import 'package:dartz/dartz.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/add_favorite_tube_entity.dart';
import '../repositories/tube_repo.dart';

class RateTubeVideoUseCase extends UseCase<AddFavoriteTubeEntity , RateTubeVideoParams> {
  final TubeRepository _repo;

  RateTubeVideoUseCase(this._repo);
  @override
  Future<Either<Failure, AddFavoriteTubeEntity >> call(RateTubeVideoParams params) async {
    return await _repo.rateTubeVideo(params: params);
  }

}

class RateTubeVideoParams {
  final String videoId;
  final num rate;


  RateTubeVideoParams({
    required this.videoId,
    required this.rate,

  });

  Map<String, dynamic> toJson() => {
    'videoId': videoId,
    'rate': rate,
  };
}

