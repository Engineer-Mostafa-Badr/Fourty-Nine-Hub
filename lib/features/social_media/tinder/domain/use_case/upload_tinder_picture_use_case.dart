import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';

import '../../data/models/tinder_person_model.dart';


class UploadTinderPictureUseCase extends UseCase<bool, List<String>> {
  final TinderRepository _repository;

  UploadTinderPictureUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(List<String> params) {
    return _repository.uploadPictures(params);
  }
}

