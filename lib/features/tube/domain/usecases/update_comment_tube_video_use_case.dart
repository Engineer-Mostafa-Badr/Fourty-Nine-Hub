import 'package:dartz/dartz.dart';


import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/add_favorite_tube_entity.dart';
import '../repositories/tube_repo.dart';

class UpdateCommentTubeVideoUseCase extends UseCase<AddFavoriteTubeEntity , UpdateCommentTubeParams> {
  final TubeRepository _repo;

  UpdateCommentTubeVideoUseCase(this._repo);
  @override
  Future<Either<Failure, AddFavoriteTubeEntity >> call(UpdateCommentTubeParams params) async {
    return await _repo.updateCommentTube(params: params);
  }

}

class UpdateCommentTubeParams {
  final String content;
  final String commentId;


  UpdateCommentTubeParams({
    required this.content,
    required this.commentId,

  });

  Map<String, dynamic> toJson() => {
    'content': content,
  };
}

