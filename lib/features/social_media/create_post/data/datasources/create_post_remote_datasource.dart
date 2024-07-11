import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/models/activity_model.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/res/assets/jsons.dart';
import '../../../../../core/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../models/feeling_model.dart';

abstract class CreatePostRemoteDataSource {
  Future<Either<Failure, List<FeelingEntity>>> getFeelingsList();
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesList();
  Future<Either<Failure, bool>> postData({required Map<String, dynamic> data});
}

class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final JsonParser _jsonParser;
  final ApiConsumer _apiConsumer;
  CreatePostRemoteDataSourceImpl(this._jsonParser, this._apiConsumer);
  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesList() async {
    final response = await _jsonParser.get(Jsons.activities);
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['items'] as List)
            .map((e) => ActivityModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<FeelingEntity>>> getFeelingsList() async {
    final response = await _jsonParser.get(Jsons.feelings);
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['items'] as List)
            .map((e) => FeelingModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> postData(
      {required Map<String, dynamic> data}) async {
    print('say hi');
    final response =
        await _apiConsumer.post(EndPoints.createFacebookPost, data: data);
    return response.fold(
        (l) => Left(l), (data) => Right(data['status'] as bool));
  }
}
