import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/account_taps/privacy/data/models/privacy_model.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/communication_privacy_entity.dart';
import '../../domain/entities/connection_privacy_entity.dart';
import '../../domain/entities/except_from_entity.dart';
import '../../domain/entities/exclusion_entity.dart';
import '../../domain/entities/media_privacy_entity.dart';
import '../../domain/entities/only_with_entity.dart';
import '../../domain/entities/personal_privacy_entity.dart';
import '../../domain/entities/privacy_entity.dart';
import '../../domain/entities/remove_response_allowed_entity.dart';
import '../../domain/entities/remove_response_forbidden_entity.dart';
import '../../domain/entities/search_users_entity.dart';
import '../../domain/entities/update_personal_privacy_entity.dart';
import '../../domain/useCase/fetch_exclusion_privacy_use_case.dart';
import '../../domain/useCase/remove_allowed_use_case.dart';
import '../../domain/useCase/search_users_privacy_use_case.dart';
import '../../domain/useCase/update_communication_privacy_use_case.dart';
import '../../domain/useCase/update_connection_privacy_use_case.dart';
import '../../domain/useCase/update_except_from_privacy_use_case.dart';
import '../../domain/useCase/update_media_privacy_use_case.dart';
import '../../domain/useCase/update_only_with_privacy_use_case.dart';
import '../../domain/useCase/update_personal_privacy_use_case.dart';
import '../models/communication_privacy_model.dart';
import '../models/connection_privacy_model.dart';
import '../models/except_from_model.dart';
import '../models/exclusion_model.dart';
import '../models/media_privacy_model.dart';
import '../models/only_with_model.dart';
import '../models/personal_privacy_model.dart';
import '../models/remove_allowed_response_model.dart';
import '../models/remove_forbidden_response_model.dart';
import '../models/search_users_model.dart';
import '../models/update_personal_privacy_model.dart';

abstract class PrivacyDataSource {
  Future<Either<Failure, PersonalPrivacyEntity >> fetchDataPersonalPrivacy();
  Future<Either<Failure, ConnectionPrivacyEntity >> fetchDataConnectionPrivacy();
  Future<Either<Failure, CommunicationPrivacyEntity >> fetchDataCommunicationPrivacy();
  Future<Either<Failure, MediaPrivacyEntity >> fetchDataMediaPrivacy();

  Future<Either<Failure, List<SearchUsersEntity> >> searchUsers({required SearchUserPrivacyParams params});


  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> updateDataPersonalPrivacy(
      UpdatePersonalPrivacyParams params);
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> updateDataConnectionPrivacy(
      UpdateConnectionPrivacyParams params);

  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> updateDataCommunicationPrivacy(
      UpdateCommunicationPrivacyParams params);
  Future<Either<Failure, OnlyWithEntity >> updateOnlyWithPrivacy(
      UpdateOnlyWithPrivacyParams params);
  Future<Either<Failure, ExceptFromEntity >> updateExceptFromPrivacy(
      UpdateExceptFromPrivacyParams params);
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity >> updateDataMediaPrivacy(
      UpdateMediaPrivacyParams params);
  Future<Either<Failure, ExclusionEntity >> fetchDataExclusionPrivacy({required ExclusionParams params});


  Future<Either<Failure, RemoveDataEntity >> removeAllowed(
      RemoveAllowedParams params);
  Future<Either<Failure, RemoveForbiddenDataEntity >> removeForbidden(
      RemoveAllowedParams params);
}

class PrivacyDataSourceImpl extends PrivacyDataSource {
  final ApiConsumer _apiConsumer;

  PrivacyDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, PersonalPrivacyEntity>> fetchDataPersonalPrivacy() async {
    var response = await _apiConsumer.get(EndPoints.privacy);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(PersonalPrivacyModel.fromJson(response['data'])),
    );
  }


  @override
  Future<Either<Failure, ConnectionPrivacyEntity>> fetchDataConnectionPrivacy() async{
    var response = await _apiConsumer.get(EndPoints.privacyConnection);

    return response.fold(
          (failure) => Left(failure),
          (response) => Right(ConnectionPrivacyModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity>> updateDataPersonalPrivacy(UpdatePersonalPrivacyParams params) async{
    var response = await _apiConsumer.put(
      EndPoints.privacy,
      data: params.toJson(),
    );
    return response.fold(
          (failure) => Left(failure),
          (response) => Right(UpdatePersonalPrivacyDataModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity>> updateDataConnectionPrivacy(UpdateConnectionPrivacyParams params)async {
    var response = await _apiConsumer.put(
      EndPoints.privacyConnection,
      data: params.toJson(),
    );
    return response.fold(
          (failure) => Left(failure),
          (response) => Right(UpdatePersonalPrivacyDataModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, CommunicationPrivacyEntity>> fetchDataCommunicationPrivacy()async {
    var response = await _apiConsumer.get(EndPoints.privacyCommunication);

    return response.fold(
          (failure) => Left(failure),
          (response) => Right(CommunicationPrivacyModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity>> updateDataCommunicationPrivacy(UpdateCommunicationPrivacyParams params)async {
    var response = await _apiConsumer.put(
      EndPoints.privacyCommunication,
      data: params.toJson(),
    );
    return response.fold(
          (failure) => Left(failure),
          (response) => Right(UpdatePersonalPrivacyDataModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, List<SearchUsersEntity>>> searchUsers({required SearchUserPrivacyParams params}) async{
    final url = "${EndPoints.searchUserPrivacy}${params.searchKeyWord}";



    final response = await _apiConsumer.get(
      url,
    );

    return response.fold(
          (l) => Left(l),
          (data) {
        final restaurantList = (data['data'] as List)
            .map((e) => SearchUsersModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(restaurantList);
      },
    );
  }

  @override
  Future<Either<Failure, OnlyWithEntity>> updateOnlyWithPrivacy(UpdateOnlyWithPrivacyParams params) async{
    var response = await _apiConsumer.put(
      EndPoints.onlyWithPrivacy,
      data: params.toJson(),
    );
    return response.fold(
          (failure) => Left(failure),
          (response) => Right(OnlyWithModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, ExceptFromEntity>> updateExceptFromPrivacy(UpdateExceptFromPrivacyParams params)async {
    var response = await _apiConsumer.put(
      EndPoints.exceptFromPrivacy,
      data: params.toJson(),
    );
    return response.fold(
          (failure) => Left(failure),
          (response) => Right(ExceptFromModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, MediaPrivacyEntity>> fetchDataMediaPrivacy() async{
    var response = await _apiConsumer.get(EndPoints.privacyMedia);

    return response.fold(
          (failure) => Left(failure),
          (response) => Right(MediaPrivacyModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, UpdatePersonalPrivacyDataEntity>> updateDataMediaPrivacy(UpdateMediaPrivacyParams params)async {
    var response = await _apiConsumer.put(
      EndPoints.privacyMedia,
      data: params.toJson(),
    );
    return response.fold(
          (failure) => Left(failure),
          (response) => Right(UpdatePersonalPrivacyDataModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, ExclusionEntity>> fetchDataExclusionPrivacy({required ExclusionParams params}) async {
    var response = await _apiConsumer.get("${EndPoints.exclusionPrivacy}${params.feature}");

    // Debugging the raw response to verify its structure
    print("API Response: $response");

    return response.fold(
          (failure) => Left(failure),
          (response) {
        // Log the response to ensure correct structure
        print("Parsed Response: ${response.toString()}");
        return Right(ExclusionModel.fromJson(response));
      },
    );
  }

  @override
  Future<Either<Failure, RemoveDataEntity>> removeAllowed(RemoveAllowedParams params) async{
    var response = await _apiConsumer.delete(
      EndPoints.removeAllowedPrivacy,
      data: params.toJson(),
    );
    return response.fold(
          (failure) => Left(failure),
          (response) => Right(RemoveDataModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, RemoveForbiddenDataEntity>> removeForbidden(RemoveAllowedParams params)async {
    var response = await _apiConsumer.delete(
      EndPoints.removeForbiddenPrivacy,
      data: params.toJson(),
    );
    return response.fold(
          (failure) => Left(failure),
          (response) => Right(RemoveForbiddenDataModel.fromJson(response['data'])),
    );
  }


}
