import 'package:dartz/dartz.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/add_favorite_tube_entity.dart';
import '../repositories/tube_repo.dart';
import 'add_favorite_tube_use_case.dart';

class RemoveWatchLaterTubeUseCase extends UseCase<AddFavoriteTubeEntity , FavoriteTubeParams> {
  final TubeRepository _repo;

  RemoveWatchLaterTubeUseCase(this._repo);
  @override
  Future<Either<Failure, AddFavoriteTubeEntity >> call(FavoriteTubeParams params) async {
    return await _repo.removeWatchLaterTube(params: params);
  }

}


