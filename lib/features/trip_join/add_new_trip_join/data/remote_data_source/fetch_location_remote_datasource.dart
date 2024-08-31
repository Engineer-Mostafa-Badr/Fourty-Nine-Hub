// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/api/google_api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/models/location_model/location_model.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/location_entity.dart';
import 'package:fourtyninehub/res/style/const.dart';

abstract class FetchLocationRemoteDataSource {
  Future<Either<Failure, LocationEntity>> fetchLocationCordinations(
      {required String address});
}

class FetchLocationRemoteDataSourceImp
    implements FetchLocationRemoteDataSource {
  final GoogleApiConsumer googleApiConsumer;
  FetchLocationRemoteDataSourceImp({
    required this.googleApiConsumer,
  });
  @override
  Future<Either<Failure, LocationEntity>> fetchLocationCordinations({
    required String address,
  }) async {
    final response = await googleApiConsumer.get(
      EndPoints.geocodingUrl,
      queryParameters: {
        'address': address,
        'key': UIConst.googleGeocodingApiKey,
        'language': 'en',
      },
    );
    return response.fold(
      (failure) => Left(failure),
      (response) {
        log(LocationModel.fromMap(response).toString());
        return Right(LocationModel.fromMap(response));
      },
    );
  }
}
