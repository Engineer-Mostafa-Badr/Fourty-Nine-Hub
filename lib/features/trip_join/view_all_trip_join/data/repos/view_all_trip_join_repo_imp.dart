import "package:dartz/dartz.dart";
import "package:fourtyninehub/common/models/public/pagination_params.dart";
import "package:fourtyninehub/core/error/failure.dart";
import "package:fourtyninehub/features/RideFeature/domain/entities/ride_brand_entity.dart";
import "package:fourtyninehub/features/RideFeature/domain/entities/ride_model_entity.dart";
import "package:fourtyninehub/features/ride/RideRequest/domain/entity/expected_price_entity.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/data/datasource/remote_datasource/view_all_trip_join_remote_datasource.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/available_trip_join_entity.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/delete_my_trip_join_entity.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/get_request_count_entity.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/my_ads_trip_join_entity.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/request_trip_join_entity.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/trip_join_card_entity.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/repos/view_all_trip_join_repo.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/create_trip_join_offer_use_case.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/delete_my_trip_join_use_case.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/get_car_brand_use_case.dart";

import "../../domain/entities/expected_price_entity.dart";
import "../../domain/usecases/get_expected_price_use_case.dart";

class ViewAllTripJoinRepoImp implements ViewAllTripJoinRepo {
  final ViewAllTripJoinRemoteDataSource viewripJoinRemoteDataSource;

  ViewAllTripJoinRepoImp({required this.viewripJoinRemoteDataSource});
  @override
  Future<Either<Failure, List<TripJoinCardEntity>>> getAllTripJion(
      {required String subCategory,
      required PaginationParams paginationParams}) {
    return viewripJoinRemoteDataSource.fetchAllTripJoin(
      subCategory: subCategory,
      paginationParams: paginationParams,
    );
  }

  @override
  Future<Either<Failure, bool>> requestTripJoin(
      {required String addId,
      required String mobile,
      required String subCategory,
      required String url,
      bool premuimRequest = false}) {
    return viewripJoinRemoteDataSource.requestTripJoin(
      addId: addId,
      subCategory: subCategory,
      url: url,
      mobile: mobile,
      premuimRequest: premuimRequest,
    );
  }

  @override
  Future<Either<Failure, List<RideBrandEntity>>> getRideBrands(CarBrandParams params) {
   return viewripJoinRemoteDataSource.getRideBrands(params);
  }

  @override
  Future<Either<Failure, List<RideModelEntity>>> getRideModels(CarBrandParams params) {
    return viewripJoinRemoteDataSource.getRideModels(params);
  }

  @override
  Future<Either<Failure, ExpectedPriceTripEntity>> getExpectedPrice(ExpectedPriceTripParams params) {
    return viewripJoinRemoteDataSource.getExpectedPrice(params);
  }

  @override
  Future<Either<Failure, List<AvailableTripJoinEntity>>> getAvailableTripJoin(CarBrandParams params) {
    return viewripJoinRemoteDataSource.getAvailableTripJoin(params);
  }

  @override
  Future<Either<Failure,  List<GetRequestTripJoinEntity>>> getRequestTripJoin(CarBrandParams params) {
    return viewripJoinRemoteDataSource.getRequestTripJoin(params);
  }

  @override
  Future<Either<Failure, MyAdsTripJoinEntity>> getMyAdsTripJoin(CarBrandParams params) {
    return viewripJoinRemoteDataSource.getMyAdsTripJoin(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> deleteMyTripJoin(DeleteMyTripParams params) {
    return viewripJoinRemoteDataSource.deleteMyTripJoin(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> applyViewTripJoin(DeleteMyTripParams params) {
    return viewripJoinRemoteDataSource.applyViewTripJoin(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> applyReadRequestTripJoin(DeleteMyTripParams params) {
    return viewripJoinRemoteDataSource.applyReadRequestTripJoin(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> createTripJoinOffer(CreateTripJoinParams params) {
    return viewripJoinRemoteDataSource.createTripJoinOffer(params);
  }

  @override
  Future<Either<Failure, GetRequestCountEntity>> getRequestCountTripJoin() {
    return viewripJoinRemoteDataSource.getRequestCountTripJoin();
  }
}
