import 'package:dartz/dartz.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/add_favorite_tube_entity.dart';
import '../repositories/tube_repo.dart';

class CreateVideoTubeUseCase extends UseCase<AddFavoriteTubeEntity , CreateTubeVideoParams> {
  final TubeRepository _repo;

  CreateVideoTubeUseCase(this._repo);
  @override
  Future<Either<Failure, AddFavoriteTubeEntity >> call(CreateTubeVideoParams params) async {
    return await _repo.createVideoTube(params: params);
  }

}

class CreateTubeVideoParams {
  final String title;
  final String description;
  final String categoryId;

  CreateTubeVideoParams({
    required this.title,
    required this.description,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category_id': categoryId,
    };
  }
}

