// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/data/models/location_model/location_model.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/location_entity.dart';
import 'package:fourtyninehub/res/style/const.dart';

abstract class FetchLocationRemoteDataSource {
  Future<Either<Failure, LocationEntity>> fetchLocationCordinations({required String address});
}

class FetchLocationRemoteDataSourceImp implements FetchLocationRemoteDataSource {
  final ApiConsumer apiConsumer;
  FetchLocationRemoteDataSourceImp({
    required this.apiConsumer,
  });
  @override
  Future<Either<Failure, LocationEntity>> fetchLocationCordinations({
    required String address,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.geocodingUrl,
      queryParameters: {
        'address': address,
        'key': UIConst.googleGeocodingApiKey,
      },
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(LocationModel.fromMap(response)),
    );
  }
}
