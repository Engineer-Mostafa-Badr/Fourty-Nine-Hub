import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';

import '../entities/personal_privacy_entity.dart';

class FetchPersonalPrivacyUseCase extends UseCase<PersonalPrivacyEntity , NoParams> {
  final PrivacyRepository _privacyRepository;

  FetchPersonalPrivacyUseCase(this._privacyRepository);
  @override
  Future<Either<Failure, PersonalPrivacyEntity >> call(NoParams params) async {
    return await _privacyRepository.fetchDataPersonalPrivacy();
  }
}
