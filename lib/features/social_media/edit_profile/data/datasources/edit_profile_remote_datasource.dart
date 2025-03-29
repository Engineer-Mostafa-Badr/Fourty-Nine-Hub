import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/domain/entities/edit_profile_entity.dart';

import '../../../../health_feature/create_doctor/data/models/governrate_model.dart';
import '../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';

abstract class EditProfileRemoteDataSource {
  Future<Either<Failure, bool>> editProfile(
      {required EditProfileEntity params});
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();

}

class EditProfileRemoteDataSourceImpl implements EditProfileRemoteDataSource {
  final JsonParser _jsonParser;
  final ApiConsumer _apiConsumer;
  EditProfileRemoteDataSourceImpl(this._jsonParser, this._apiConsumer);

  @override
  Future<Either<Failure, bool>> editProfile(
      {required EditProfileEntity params}) async {
    final response =
        await _apiConsumer.put(EndPoints.editProfile, data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getGovernorates,
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data'] as List)
            .map((e) => GovernorateModel.fromJson(e))
            .toList());
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

}
