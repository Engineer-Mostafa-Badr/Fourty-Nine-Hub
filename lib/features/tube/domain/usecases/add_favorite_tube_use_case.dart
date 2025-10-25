import 'package:dartz/dartz.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/add_favorite_tube_entity.dart';
import '../repositories/tube_repo.dart';

class AddFavoriteTubeUseCase extends UseCase<AddFavoriteTubeEntity , FavoriteTubeParams> {
  final TubeRepository _repo;

  AddFavoriteTubeUseCase(this._repo);
  @override
  Future<Either<Failure, AddFavoriteTubeEntity >> call(FavoriteTubeParams params) async {
    return await _repo.addFavoriteTube(params: params);
  }

}

class FavoriteTubeParams {
  final String id;

  FavoriteTubeParams({required this.id});


}



