import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/data/data_source/privacy_data_source.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/communication_privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/connection_privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/exclusion_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/media_privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/only_with_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/remove_response_allowed_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/remove_response_forbidden_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/search_users_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/update_personal_privacy_entity.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/repository/privacy_repository.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/fetch_exclusion_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/remove_allowed_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/search_users_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_communication_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_connection_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_except_from_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_media_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_only_with_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_personal_privacy_use_case.dart';

import '../../domain/entities/except_from_entity.dart';
import '../../domain/entities/personal_privacy_entity.dart';

class PrivacyRepositoryImpl extends PrivacyRepository {
  final PrivacyDataSource _privacyDataSource;

  PrivacyRepositoryImpl(this._privacyDataSource);
  @override
  Future<Either<Failure, PersonalPrivacyEntity>> fetchDataPersonalPrivacy() {
    return _privacyDataSource.fetchDataPersonalPrivacy();
  }



  @override
  Future<Either<Failure, ConnectionPrivacyEntity>> fetchDataConnectionPrivacy() {
    return _privacyDataSource.fetchDataConnectionPrivacy();
  }

  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity>> updateDataPersonalPrivacy(UpdatePersonalPrivacyParams params) {
    return _privacyDataSource.updateDataPersonalPrivacy(params);
  }

  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity>> updateDataConnectionPrivacy(UpdateConnectionPrivacyParams params) {
    return _privacyDataSource.updateDataConnectionPrivacy(params);
  }

  @override
  Future<Either<Failure, CommunicationPrivacyEntity>> fetchDataCommunicationPrivacy() {
    return _privacyDataSource.fetchDataCommunicationPrivacy();
  }

  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity>> updateDataCommunicationPrivacy(UpdateCommunicationPrivacyParams params) {
    return _privacyDataSource.updateDataCommunicationPrivacy(params);
  }

  @override
  Future<Either<Failure, List<SearchUsersEntity>>> searchUsers({required SearchUserPrivacyParams params}) {
    return _privacyDataSource.searchUsers(params: params);
  }

  @override
  Future<Either<Failure, OnlyWithEntity>> updateOnlyWithPrivacy(UpdateOnlyWithPrivacyParams params) {
    return _privacyDataSource.updateOnlyWithPrivacy(params);

  }

  @override
  Future<Either<Failure, ExceptFromEntity>> updateExceptFromPrivacy(UpdateExceptFromPrivacyParams params) {
    return _privacyDataSource.updateExceptFromPrivacy(params);
  }

  @override
  Future<Either<Failure, MediaPrivacyEntity>> fetchDataMediaPrivacy() {
    return _privacyDataSource.fetchDataMediaPrivacy();
  }

  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity>> updateDataMediaPrivacy(UpdateMediaPrivacyParams params) {
    return _privacyDataSource.updateDataMediaPrivacy(params);
  }

  @override
  Future<Either<Failure, ExclusionEntity>> fetchDataExclusionPrivacy({required ExclusionParams params}) {
    return _privacyDataSource.fetchDataExclusionPrivacy(params: params);
  }

  @override
  Future<Either<Failure, RemoveDataEntity>> removeAllowed(RemoveAllowedParams params) {
    return _privacyDataSource.removeAllowed(params);
  }

  @override
  Future<Either<Failure, RemoveForbiddenDataEntity>> removeForbidden(RemoveAllowedParams params) {
    return _privacyDataSource.removeForbidden(params);
  }
}
