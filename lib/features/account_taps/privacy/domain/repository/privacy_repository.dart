import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';

import '../entities/connection_privacy_entity.dart';
import '../entities/personal_privacy_entity.dart';
import '../useCase/update_privacy_use_case.dart';

abstract class PrivacyRepository {
  Future<Either<Failure, PersonalPrivacyEntity >> fetchDataPersonalPrivacy();
  Future<Either<Failure, ConnectionPrivacyEntity >> fetchDataConnectionPrivacy();

  Future<Either<Failure, PrivacyEntity>> updateDataPrivacy(
      UpdatePrivacyParams params);
}
