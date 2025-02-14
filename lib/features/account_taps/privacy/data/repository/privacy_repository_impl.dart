import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/data/data_source/privacy_data_source.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/connection_privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_privacy_use_case.dart';

import '../../domain/entities/personal_privacy_entity.dart';

class PrivacyRepositoryImpl extends PrivacyRepository {
  final PrivacyDataSource _privacyDataSource;

  PrivacyRepositoryImpl(this._privacyDataSource);
  @override
  Future<Either<Failure, PersonalPrivacyEntity>> fetchDataPersonalPrivacy() {
    return _privacyDataSource.fetchDataPersonalPrivacy();
  }

  @override
  Future<Either<Failure, PrivacyEntity>> updateDataPrivacy(
      UpdatePrivacyParams params) {
    return _privacyDataSource.updateDataPrivacy(params);
  }

  @override
  Future<Either<Failure, ConnectionPrivacyEntity>> fetchDataConnectionPrivacy() {
    return _privacyDataSource.fetchDataConnectionPrivacy();
  }
}
