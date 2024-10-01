import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';

import '../useCase/update_privacy_use_case.dart';

abstract class PrivacyRepository {
  Future<Either<Failure, PrivacyEntity>> fetchDataPrivacy();
  Future<Either<Failure, PrivacyEntity>> updateDataPrivacy(
      UpdatePrivacyParams params);
}
