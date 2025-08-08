import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

import '../repositories/stories_repository.dart';

class UpdateStoryPrivacyUseCase
    extends UseCase<bool, UpdateStoryPrivacyParams> {
  final StoriesRepository _repository;

  UpdateStoryPrivacyUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(UpdateStoryPrivacyParams params) {
    return _repository.updatePrivacy(params);
  }
}

class UpdateStoryPrivacyParams {
  final String privacyType;
  final List<String>? users;

  UpdateStoryPrivacyParams({required this.privacyType, required this.users});

  //toJson
  Map<String, dynamic> toJson() => {
        'privacyType': privacyType,
        'users': users,
      };
}
