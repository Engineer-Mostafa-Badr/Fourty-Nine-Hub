import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/domain/entities/edit_profile_entity.dart';


abstract class EditProfileRemoteDataSource {
  Future<Either<Failure, UserEntity>> editProfile({required EditProfileEntity params});

}

class EditProfileRemoteDataSourceImpl implements EditProfileRemoteDataSource {
  final JsonParser _jsonParser;
  final ApiConsumer _apiConsumer;
  EditProfileRemoteDataSourceImpl(this._jsonParser, this._apiConsumer);

  @override
  Future<Either<Failure, UserEntity>> editProfile({required EditProfileEntity params}) async{
    final response = await _apiConsumer
        .put(EndPoints.editProfile, data: params.toJson());
    return response.fold(
            (l) => Left(l), (data) => Right(UserModel.fromJson(data['data'])));
  }
}
