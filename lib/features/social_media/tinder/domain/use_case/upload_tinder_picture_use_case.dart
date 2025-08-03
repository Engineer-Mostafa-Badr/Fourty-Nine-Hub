import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/tinder_repository.dart';

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
