import 'package:dartz/dartz.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/add_favorite_tube_entity.dart';
import '../repositories/tube_repo.dart';

class CreateCommentTubeVideoUseCase extends UseCase<AddFavoriteTubeEntity , CreateCommentTubeParams> {
  final TubeRepository _repo;

  CreateCommentTubeVideoUseCase(this._repo);
  @override
  Future<Either<Failure, AddFavoriteTubeEntity >> call(CreateCommentTubeParams params) async {
    return await _repo.createCommentTube(params: params);
  }

}

class CreateCommentTubeParams {
  final String content;
  final String videoId;
  final String parentCommentId;

  CreateCommentTubeParams({
    required this.content,
    required this.videoId,
    required this.parentCommentId,
  });

  Map<String, dynamic> toJson() => {
    'content': content,
    'videoId': videoId,
    'parentCommentId': parentCommentId.isEmpty ? null : parentCommentId, // Handle empty string
  };
}

