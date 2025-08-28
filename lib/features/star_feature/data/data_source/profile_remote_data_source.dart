import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../domain/entity/profile_entity.dart';
import '../model/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getMyProfile();
  Future<String> updateProfile(UpdateProfileParams params);
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
}