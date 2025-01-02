import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';

class UploadTinderPictureUseCase extends UseCase<bool, AddImagesParams> {
  final TinderRepository _repository;

  UploadTinderPictureUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(AddImagesParams params) {
    return _repository.uploadPictures(params);
  }
}

class AddImagesParams {
  List<String>? media;

  AddImagesParams({
    this.media,
  });

  Map<String, dynamic> toJson() => {
        'pictures': media,
      };
}
