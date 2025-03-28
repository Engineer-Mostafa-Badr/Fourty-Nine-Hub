import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_entity.dart';

import '../entities/communication_privacy_entity.dart';
import '../entities/connection_privacy_entity.dart';
import '../entities/except_from_entity.dart';
import '../entities/exclusion_entity.dart';
import '../entities/media_privacy_entity.dart';
import '../entities/only_with_entity.dart';
import '../entities/personal_privacy_entity.dart';
import '../entities/remove_response_allowed_entity.dart';
import '../entities/remove_response_forbidden_entity.dart';
import '../entities/search_users_entity.dart';
import '../entities/update_personal_privacy_entity.dart';
import '../useCase/fetch_exclusion_privacy_use_case.dart';
import '../useCase/remove_allowed_use_case.dart';
import '../useCase/search_users_privacy_use_case.dart';
import '../useCase/update_communication_privacy_use_case.dart';
import '../useCase/update_connection_privacy_use_case.dart';
import '../useCase/update_except_from_privacy_use_case.dart';
import '../useCase/update_media_privacy_use_case.dart';
import '../useCase/update_only_with_privacy_use_case.dart';
import '../useCase/update_personal_privacy_use_case.dart';

abstract class PrivacyRepository {
  Future<Either<Failure, PersonalPrivacyEntity >> fetchDataPersonalPrivacy();
  Future<Either<Failure, ConnectionPrivacyEntity >> fetchDataConnectionPrivacy();
  Future<Either<Failure, CommunicationPrivacyEntity >> fetchDataCommunicationPrivacy();
  Future<Either<Failure, MediaPrivacyEntity >> fetchDataMediaPrivacy();
  Future<Either<Failure, ExclusionEntity  >> fetchDataExclusionPrivacy({required ExclusionParams params});

  Future<Either<Failure, List<SearchUsersEntity> >> searchUsers({required SearchUserPrivacyParams params});


  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> updateDataPersonalPrivacy(
      UpdatePersonalPrivacyParams params);
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> updateDataConnectionPrivacy(
      UpdateConnectionPrivacyParams params);
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> updateDataCommunicationPrivacy(
      UpdateCommunicationPrivacyParams params);
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> updateDataMediaPrivacy(
      UpdateMediaPrivacyParams params);
  Future<Either<Failure, OnlyWithEntity >> updateOnlyWithPrivacy(
      UpdateOnlyWithPrivacyParams params);
  Future<Either<Failure, ExceptFromEntity >> updateExceptFromPrivacy(
      UpdateExceptFromPrivacyParams params);

  Future<Either<Failure, RemoveDataEntity >> removeAllowed(
      RemoveAllowedParams params);
  Future<Either<Failure, RemoveForbiddenDataEntity >> removeForbidden(
      RemoveAllowedParams params);
}
