import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';

import '../../data/models/tinder_person_model.dart';


class GetTinderProfileUseCase extends UseCase<ProfileUserModel, String> {
  final TinderRepository _repository;

  GetTinderProfileUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileUserModel>> call(String params) {
    return _repository.getUserProfile(params);
  }
}

