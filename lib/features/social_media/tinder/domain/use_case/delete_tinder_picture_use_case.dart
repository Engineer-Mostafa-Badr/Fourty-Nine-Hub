import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';



class DeleteTinderPictureUseCase extends UseCase<bool, String> {
  final TinderRepository _repository;

  DeleteTinderPictureUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.deletePictures(params);
  }
}

