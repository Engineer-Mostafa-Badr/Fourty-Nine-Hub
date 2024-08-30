import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/data/models/car_brand_model.dart';
import 'package:fourtyninehub/features/trip_join/data/models/car_type_model.dart';
import 'package:fourtyninehub/features/trip_join/data/models/car_year_type_model.dart';
import 'package:fourtyninehub/features/trip_join/data/models/trip_join_model.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/car_brand_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/car_model_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/car_year_type_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/trip_info_entity.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/trip_join_publish_param.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TripJoinRemoteDataSource {
  Future<Either<Failure, TripInfoEntity>> fetchPriceDistance({
    required LatLng startLocation,
    required LatLng destinationLocation,
  });
  Future<Either<Failure, List<CarBrandEntity>>> fetchCarBrand({required String search});
  Future<Either<Failure, List<CarModelEntity>>> fetchCarModel({required String brand});
  Future<Either<Failure, List<CarYearTypeEntity>>> fetchCarYearType({required String brand, required String model});
  Future<Either<Failure, bool>> publishTripJoin({required TripJoinPublishParam tripJoinPublishParam});
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

  @override
  Future<Either<Failure, List<CarModelEntity>>> fetchCarModel({required String brand}) async {
    final response = await apiConsumer.get(
      EndPoints.getCarModelByBrand,
      queryParameters: {
        'brand': brand,
      },
    );

    return response.fold(
      (failure) => Left(failure),
      (data) {
        List<CarModelEntity> models = data['data'].map<CarModelEntity>((json) => CarTypeModel.fromJson(json)).toList();
        log(models.toString());
        return Right(models);
      },
    );
  }

  @override
  Future<Either<Failure, List<CarYearTypeEntity>>> fetchCarYearType(
      {required String brand, required String model}) async {
    final response = await apiConsumer.get(
      EndPoints.getCarYearType,
      queryParameters: {
        'model': model,
        'brand': brand,
      },
    );
    return response.fold(
      (failure) => Left(failure),
      (data) {
        List<CarYearTypeModel> models =
            data['data'].map<CarYearTypeModel>((json) => CarYearTypeModel.fromJson(json)).toList();
        log(models.toString());
        return Right(models);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> publishTripJoin({required TripJoinPublishParam tripJoinPublishParam}) async {
    final response = await apiConsumer.post(
      EndPoints.publishTripJoin,
      data: tripJoinPublishParam.toJson(),
    );

    return response.fold(
      (failure) {
        // print(' ========= $failure');
        return Left(failure);
      },
      (data) {
        // print(' ========= $data');
        return const Right(true);
      },
    );
  }
}
