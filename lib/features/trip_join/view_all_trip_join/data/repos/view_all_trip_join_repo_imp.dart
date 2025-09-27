import "package:dartz/dartz.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/create_pick_me_offer_use_case.dart";
import "package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/create_pick_me_request_use_case.dart";
import "../../../../../common/models/public/pagination_params.dart";
import "../../../../../core/error/failure.dart";
import "../../../../RideFeature/domain/entities/ride_brand_entity.dart";
import "../../../../RideFeature/domain/entities/ride_model_entity.dart";
import "../datasource/remote_datasource/view_all_trip_join_remote_datasource.dart";
import "../../domain/entities/available_trip_join_entity.dart";
import "../../domain/entities/delete_my_trip_join_entity.dart";
import "../../domain/entities/get_request_count_entity.dart";
import "../../domain/entities/my_ads_trip_join_entity.dart";
import "../../domain/entities/request_trip_join_entity.dart";
import "../../domain/entities/trip_join_card_entity.dart";
import "../../domain/repos/view_all_trip_join_repo.dart";
import "../../domain/usecases/create_trip_join_offer_use_case.dart";
import "../../domain/usecases/delete_my_trip_join_use_case.dart";
import "../../domain/usecases/get_car_brand_use_case.dart";

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
  Future<Either<Failure, List<AvailableTripJoinEntity>>> getAvailablePickMe(CarBrandParams params) {
    return viewripJoinRemoteDataSource.getAvailablePickMe(params);
  }

  @override
  Future<Either<Failure,  List<GetRequestTripJoinEntity>>> getRequestTripJoin(CarBrandParams params) {
    return viewripJoinRemoteDataSource.getRequestTripJoin(params);
  }

  @override
  Future<Either<Failure,  List<GetRequestTripJoinEntity>>> getRequestPickMe(CarBrandParams params) {
    return viewripJoinRemoteDataSource.getRequestPickMe(params);
  }

  @override
  Future<Either<Failure, MyAdsTripJoinEntity>> getMyAdsTripJoin(CarBrandParams params) {
    return viewripJoinRemoteDataSource.getMyAdsTripJoin(params);
  }

  @override
  Future<Either<Failure, MyAdsTripJoinEntity>> getMyAdsPickMe(CarBrandParams params) {
    return viewripJoinRemoteDataSource.getMyAdsPickMe(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> deleteMyTripJoin(DeleteMyTripParams params) {
    return viewripJoinRemoteDataSource.deleteMyTripJoin(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> deleteMyPickMe(String params) {
    return viewripJoinRemoteDataSource.deleteMyPickMe(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> applyViewTripJoin(DeleteMyTripParams params) {
    return viewripJoinRemoteDataSource.applyViewTripJoin(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> applyViewPickMe(DeleteMyTripParams params) {
    return viewripJoinRemoteDataSource.applyViewPickMe(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> createPickMeRequest(CreateRequestParams params) {
    return viewripJoinRemoteDataSource.createPickMeRequest(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> createTripJoinRequest(CreateRequestParams params) {
    return viewripJoinRemoteDataSource.createTripJoinRequest(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> applyReadRequestTripJoin(DeleteMyTripParams params) {
    return viewripJoinRemoteDataSource.applyReadRequestTripJoin(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> applyReadRequestPickMe(DeleteMyTripParams params) {
    return viewripJoinRemoteDataSource.applyReadRequestPickMe(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> createTripJoinOffer(CreateTripJoinParams params) {
    return viewripJoinRemoteDataSource.createTripJoinOffer(params);
  }

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> createPickMeOffer(CreatePickMeParams params) {
    return viewripJoinRemoteDataSource.createPickMeOffer(params);
  }

  @override
  Future<Either<Failure, GetRequestCountEntity>> getRequestCountTripJoin() {
    return viewripJoinRemoteDataSource.getRequestCountTripJoin();
  }

  @override
  Future<Either<Failure, GetRequestCountEntity>> getRequestCountPickMe() {
    return viewripJoinRemoteDataSource.getRequestCountPickMe();
  }
}
