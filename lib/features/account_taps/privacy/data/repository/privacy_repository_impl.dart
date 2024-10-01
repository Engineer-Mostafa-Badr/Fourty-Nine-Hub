import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/data/data_source/privacy_data_source.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_privacy_use_case.dart';

class PrivacyRepositoryImpl extends PrivacyRepository {
  final PrivacyDataSource _privacyDataSource;

  PrivacyRepositoryImpl(this._privacyDataSource);
  @override
  Future<Either<Failure, PrivacyEntity>> fetchDataPrivacy() {
    return _privacyDataSource.fetchDataPrivacy();
  }

  @override
  Future<Either<Failure, PrivacyEntity>> updateDataPrivacy(
      UpdatePrivacyParams params) {
    return _privacyDataSource.updateDataPrivacy(params);
  }
}
