import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/data/models/car_brand_model.dart';
import 'package:fourtyninehub/features/trip_join/data/models/trip_join_model.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/car_brand_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/trip_info_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TripJoinRemoteDataSource {
  Future<Either<Failure, TripInfoEntity>> fetchPriceDistance({
    required LatLng startLocation,
    required LatLng destinationLocation,
  });
  Future<Either<Failure, List<CarBrandEntity>>> fetchCarBrand({required String search});
}

class TripJoinRemoteDataSourceImp implements TripJoinRemoteDataSource {
  final ApiConsumer apiConsumer;

  TripJoinRemoteDataSourceImp({required this.apiConsumer});

  @override
  Future<Either<Failure, TripInfoEntity>> fetchPriceDistance({
    required LatLng startLocation,
    required LatLng destinationLocation,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.tripJoinExpectedPrice,
      data: {
        'startLocation': [startLocation.latitude, startLocation.longitude],
        'targetLocation': [destinationLocation.latitude, destinationLocation.longitude],
      },
    );

    return response.fold(
      (failure) => Left(failure),
      (data) {
        TripInfoModel tripInfoModel = TripInfoModel.fromJson(data['data']);
        log(tripInfoModel.toString());
        return Right(tripInfoModel);
      },
    );
  }

  @override
  Future<Either<Failure, List<CarBrandEntity>>> fetchCarBrand({required String search}) async {
    final response = await apiConsumer.post(
      EndPoints.getCarBrand,
      data: {
        'brand': search,
      },
    );

    return response.fold(
      (failure) => Left(failure),
      (data) {
        List<CarBrandEntity> brands = data['data'].map<CarBrandEntity>((json) => CarBrandModel.fromJson(json)).toList();
        log(brands.toString());
        return Right(brands);
      },
    );
  }
}
