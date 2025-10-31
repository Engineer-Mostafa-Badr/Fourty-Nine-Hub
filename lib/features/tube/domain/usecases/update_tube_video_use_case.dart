import 'package:dartz/dartz.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/add_favorite_tube_entity.dart';
import '../repositories/tube_repo.dart';

class UpdateTubeVideoUseCase extends UseCase<AddFavoriteTubeEntity , UpdateTubeVideo> {
  final TubeRepository _repo;

  UpdateTubeVideoUseCase(this._repo);
  @override
  Future<Either<Failure, AddFavoriteTubeEntity >> call(UpdateTubeVideo params) async {
    return await _repo.updateTubeVideo(params: params);
  }

}

class UpdateTubeVideo {
  final String videoId;
  final String? title;
  final String? description;
  final String? thumbnail;

  UpdateTubeVideo({
    required this.videoId,
    this.title,
    this.description,
    this.thumbnail,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (title != null && title!.isNotEmpty) data['title'] = title;
    if (description != null && description!.isNotEmpty) data['description'] = description;
    if (thumbnail != null && thumbnail!.isNotEmpty) data['thumbnail'] = thumbnail;

    return data;
  }
}
