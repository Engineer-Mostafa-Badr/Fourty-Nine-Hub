import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_privacy_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/followers_model.dart';

import '../repositories/stories_repository.dart';

class UpdateStoryPrivacyUseCase extends UseCase<bool, UpdateStoryPrivacyParams> {
  final StoriesRepository _repository;

  UpdateStoryPrivacyUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(UpdateStoryPrivacyParams params) {
    return _repository.updatePrivacy(params);
  }
}

class UpdateStoryPrivacyParams{
  final String privacyType;
  final List<String>? users;

  UpdateStoryPrivacyParams({required this.privacyType, required this.users});

  //toJson
  Map<String, dynamic> toJson() => {
    'privacyType': privacyType,
    'users': users,
  };
}