// ignore_for_file: unused_import

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_brand_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_car_model_model.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/data/models/trip_join_card_model/trip_join_card_model.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart';
import '../../../../../RideFeature/domain/entities/ride_brand_entity.dart';
import '../../../../../RideFeature/domain/entities/ride_model_entity.dart';
import '../../../../../ride/RideRequest/data/models/params/expected_price_params.dart';
import '../../../../../ride/RideRequest/domain/entity/expected_price_entity.dart';
import '../../../domain/entities/available_trip_join_entity.dart';
import '../../../domain/entities/delete_my_trip_join_entity.dart';
import '../../../domain/entities/expected_price_entity.dart';
import '../../../domain/entities/my_ads_trip_join_entity.dart';
import '../../../domain/entities/request_trip_join_entity.dart';
import '../../../domain/usecases/delete_my_trip_join_use_case.dart';
import '../../../domain/usecases/get_car_brand_use_case.dart';
import '../../../domain/usecases/get_expected_price_use_case.dart';
import '../../models/trip_join_card_model/available_trip_join_model.dart';
import '../../models/trip_join_card_model/delete_my_trip_join_model.dart';
import '../../models/trip_join_card_model/expected_price_model.dart';
import '../../models/trip_join_card_model/my_ads_trip_join_model.dart';
import '../../models/trip_join_card_model/request_trip_join_model.dart' as model;

abstract class ViewAllTripJoinRemoteDataSource {
  Future<Either<Failure, List<TripJoinCardEntity>>> fetchAllTripJoin({
    required String subCategory,
    required PaginationParams paginationParams,
  });
  Future<Either<Failure, bool>> requestTripJoin(
      {required String addId,
      required String mobile,
      required String subCategory,
      required String url,
      bool premuimRequest = false});

  Future<Either<Failure, List<RideBrandEntity>>> getRideBrands(CarBrandParams params);
  Future<Either<Failure, List<RideModelEntity>>> getRideModels(CarBrandParams params);
  Future<Either<Failure, ExpectedPriceTripEntity>> getExpectedPrice(ExpectedPriceTripParams params);
  Future<Either<Failure, List<TripJoinEntity>>> getAvailableTripJoin(CarBrandParams params);
  Future<Either<Failure, RequestTripJoinEntity>> getRequestTripJoin(CarBrandParams params);
  Future<Either<Failure, MyAdsTripJoinEntity>> getMyAdsTripJoin(CarBrandParams params);
  Future<Either<Failure, DeleteMyTripJoinEntity >> deleteMyTripJoin(DeleteMyTripParams params);
  Future<Either<Failure, DeleteMyTripJoinEntity >> applyViewTripJoin(DeleteMyTripParams params);
  Future<Either<Failure, DeleteMyTripJoinEntity >> applyReadRequestTripJoin(DeleteMyTripParams params);

}

class ViewAllTripJoinRemoteDataSourceImp
    implements ViewAllTripJoinRemoteDataSource {
  final ApiConsumer apiConsumer;

  ViewAllTripJoinRemoteDataSourceImp({required this.apiConsumer});
  @override
  Future<Either<Failure, List<TripJoinCardEntity>>> fetchAllTripJoin({
    required String subCategory,
    required PaginationParams paginationParams,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.getAllTripJoin,
      queryParameters: {
        'subCategory': subCategory,
        'page': paginationParams.page,
        'limit': paginationParams.limit,
      },
    );

    return response.fold(
      (failure) {
        // pr(failure);
        return Left(failure);
      },
      (data) {
        List rawData = data['data']['updatedTrips'];
        if (rawData.isEmpty) {
          // pr('No data found');
          return const Right([]);
        }
        List<TripJoinCardEntity> allCards = rawData.map<TripJoinCardEntity>(
          (e) {
            final tripJoinCardModel = TripJoinCardModel.fromJson(e);
            tripJoinCardModel.subscribedPremium =
                data['data']['subscribedPremium'] as bool?;
            return tripJoinCardModel;
          },
        ).toList();
        // pr(allCards, 'trip join remote datasource');
        return Right(allCards);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> requestTripJoin(
      {required String addId,
      required String subCategory,
      required String url,
      required String mobile,
      bool premuimRequest = false}) async {
    print("premuimRequest ==================== $premuimRequest \n");
    final response = await apiConsumer.post(
      EndPoints.makeTripJoinRequest(addId, subCategory, url),
      data: {
        'phone': mobile,
        'isPremium': premuimRequest,
      },
    );

    return response.fold(
      (failure) {
        // pr(failure);
        return Left(failure);
      },
      (data) {
        // pr('request completed successfully');
        return const Right(true);
      },
    );
  }

  @override
  Future<Either<Failure, List<RideBrandEntity>>> getRideBrands(CarBrandParams params) async{
    final url =
        "${EndPoints.getAllCarBrand}?page=${params.page}&limit=${params.limit}";

    final response = await apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsData = (data['data']['carBrands'] as List)
            .map((e) => RideBrandModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, List<RideModelEntity>>> getRideModels(CarBrandParams params) async{
    final url =
        "${EndPoints.getAllCarModel}${params.id}/models?page=${params.page}&limit=${params.limit}";

    final response = await apiConsumer.get(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsData = (data['data']['carModels'] as List)
            .map((e) => RideCarModelModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
  }

  @override
  Future<Either<Failure, ExpectedPriceTripEntity>> getExpectedPrice(ExpectedPriceTripParams params) async {
    final url = EndPoints.getTripExpectedPrice;

    final body = {
      "startLocation": params.startLocation,
      "targetLocation": params.targetLocation,
    };

    final response = await apiConsumer.get(url, data: body);  // Use POST and body

    return response.fold(
          (l) => Left(l),
          (data) {
        final expectedPriceData = data['data'];
        final entity = ExpectedPriceTripModel.fromJson(expectedPriceData);
        return Right(entity);
      },
    );
  }

  @override
  Future<Either<Failure, List<TripJoinEntity>>> getAvailableTripJoin(CarBrandParams params) async{
    final url =
        "${EndPoints.getAvailableTripJoin}?subCategory=62ea00e269ea29c91dfc390c&page=${params.page}&limit=${params.limit}";

    final response = await apiConsumer.get(url);


    return response.fold(
          (l) => Left(l),
          (data) {
        final tripsData = (data['data']['Trips'] as List)
            .map((e) => TripJoinModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(tripsData);
      },
    );
    // return response.fold(
    //       (l) => Left(l),
    //       (data) {
    //     final expectedPriceData = data['data'];
    //     final entity = TripJoinModel.fromJson(expectedPriceData);
    //     return Right(entity);
    //   },
    // );
    // return response.fold(
    //       (l) => Left(l),
    //       (data) {
    //     final tripsData = (data['data']as List)
    //         .map((e) => AvailableTripJoinModel.fromJson(e as Map<String, dynamic>))
    //         .toList();
    //     return Right(tripsData);
    //   },
    // );
  }

  @override
  Future<Either<Failure, RequestTripJoinEntity>> getRequestTripJoin(CarBrandParams params) async{
    final url =
        "${EndPoints.getRequestTripJoin}?page=${params.page}&limit=${params.limit}";

    final response = await apiConsumer.get(url);


    return response.fold(
          (l) => Left(l),
          (data) {
        final expectedPriceData = data;
        final entity = RequestTripJoinModel.fromJson(expectedPriceData);
        return Right(entity);
      },
    );
  }

  @override
  Future<Either<Failure, MyAdsTripJoinEntity>> getMyAdsTripJoin(CarBrandParams params)async {
    final url =
        "${EndPoints.getMyAdsTripJoin}?subCategory=62ea00e269ea29c91dfc390c&"
        "page=${params.page}&limit=${params.limit}";


    final response = await apiConsumer.get(url);


    return response.fold(
          (l) => Left(l),
          (data) {
        final expectedPriceData = data;
        final entity = MyAdsTripJoinModel.fromJson(expectedPriceData);
        return Right(entity);
      },
    );
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> deleteMyTripJoin(DeleteMyTripParams params) async{
    final url = "${EndPoints.deleteMyAdsTripJoin}${params.tripId}";

    final response = await apiConsumer.delete(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripData = DeleteMyTripJoinModel.fromJson(data);
        return Right(tripData);
      },
    );
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> applyViewTripJoin(DeleteMyTripParams params) async{
    final url = "${EndPoints.applyViewTripJoin}${params.tripId}";

    final response = await apiConsumer.patch(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripData = DeleteMyTripJoinModel.fromJson(data);
        return Right(tripData);
      },
    );
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> applyReadRequestTripJoin(DeleteMyTripParams params)async {
    final url = "${EndPoints.applyReadRequestTripJoin}${params.tripId}";

    final response = await apiConsumer.patch(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        final tripData = DeleteMyTripJoinModel.fromJson(data);
        return Right(tripData);
      },
    );
  }





}
