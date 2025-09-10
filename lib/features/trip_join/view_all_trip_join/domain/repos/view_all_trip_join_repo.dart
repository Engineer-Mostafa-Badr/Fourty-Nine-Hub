import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/error/failure.dart';
import '../entities/trip_join_card_entity.dart';
import '../../../../RideFeature/domain/entities/ride_brand_entity.dart';
import '../../../../RideFeature/domain/entities/ride_model_entity.dart';
import '../entities/available_trip_join_entity.dart';
import '../entities/delete_my_trip_join_entity.dart';
import '../entities/expected_price_entity.dart';
import '../entities/get_request_count_entity.dart';
import '../entities/my_ads_trip_join_entity.dart';
import '../entities/request_trip_join_entity.dart';
import '../usecases/create_trip_join_offer_use_case.dart';
import '../usecases/delete_my_trip_join_use_case.dart';
import '../usecases/get_car_brand_use_case.dart';
import '../usecases/get_expected_price_use_case.dart';


abstract class ViewAllTripJoinRepo {
  Future<Either<Failure, List<TripJoinCardEntity>>> getAllTripJion({
    required String subCategory,
    required PaginationParams paginationParams,
  });
  Future<Either<Failure, bool>> requestTripJoin({
    required String addId,
    required String mobile,
    required String subCategory,
    required String url,
    bool premuimRequest = false,
  });

  Future<Either<Failure, List<RideBrandEntity>>> getRideBrands(CarBrandParams params);
  Future<Either<Failure, List<RideModelEntity>>> getRideModels(CarBrandParams params);
  Future<Either<Failure, List<AvailableTripJoinEntity>>> getAvailableTripJoin(CarBrandParams params);
  Future<Either<Failure, List<GetRequestTripJoinEntity>>> getRequestTripJoin(CarBrandParams params);
  Future<Either<Failure, ExpectedPriceTripEntity>> getExpectedPrice(ExpectedPriceTripParams params);
  Future<Either<Failure, DeleteMyTripJoinEntity>> createTripJoinOffer(CreateTripJoinParams params);
  Future<Either<Failure, MyAdsTripJoinEntity>> getMyAdsTripJoin(CarBrandParams params);
  Future<Either<Failure, DeleteMyTripJoinEntity >> deleteMyTripJoin(DeleteMyTripParams params);
  Future<Either<Failure, DeleteMyTripJoinEntity >> applyViewTripJoin(DeleteMyTripParams params);
  Future<Either<Failure, DeleteMyTripJoinEntity >> applyReadRequestTripJoin(DeleteMyTripParams params);
  Future<Either<Failure, GetRequestCountEntity >> getRequestCountTripJoin();

}
