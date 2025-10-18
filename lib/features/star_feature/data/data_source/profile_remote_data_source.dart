import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entity/profile_entity.dart';
import '../model/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getMyProfile();
  Future<ProfileModel> getProfileById(String profileId);
  Future<String> updateProfile(UpdateProfileParams params);
  Future<Either<Failure, List<ProfileEntity>>> searchProfiles(
      SearchProfileParams params);
  Future<String> subscribeToChannel(String profileId);
  Future<String> unsubscribeFromChannel(String profileId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProfileRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<ProfileModel> getMyProfile() async {
    final response = await apiConsumer.get(EndPoints.getMyProfile);

    return response.fold(
      (failure) => throw failure,
      (data) => ProfileModel.fromJson(data['data']),
    );
  }

  @override
  Future<ProfileModel> getProfileById(String profileId) async {
    final response =
        await apiConsumer.get(EndPoints.getTubeProfileById(profileId));

    return response.fold(
      (failure) => throw failure,
      (data) => ProfileModel.fromJson(data['data']),
    );
  }

  @override
  Future<String> updateProfile(UpdateProfileParams params) async {
    final response = await apiConsumer.put(
      EndPoints.updateProfile,
      data: params.toJson(),
    );

    return response.fold(
      (failure) => throw failure,
      (data) => data['data'] as String,
    );
  }

  @override
  Future<Either<Failure, List<ProfileEntity>>> searchProfiles(
      SearchProfileParams params) async {
    final response = await apiConsumer.get(
      EndPoints.searchProfiles(params),
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        final profiles = response['data']['profiles'] as List;
        return Right(
            profiles.map((profile) => ProfileModel.fromJson(profile)).toList());
      },
    );
  }

  @override
  Future<String> subscribeToChannel(String profileId) async {
    final response = await apiConsumer.post(
      EndPoints.subscribeToChannel(profileId),
    );

    return response.fold(
      (failure) => throw failure,
      (data) => data['message'] as String,
    );
  }

  // NEW: Unsubscribe from channel
  @override
  Future<String> unsubscribeFromChannel(String profileId) async {
    final response = await apiConsumer.post(
      EndPoints.unsubscribeFromChannel(profileId),
    );

    return response.fold(
      (failure) => throw failure,
      (data) => data['message'] as String,
    );
  }
}
