import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/activity_trip_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/completed_trips_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/get_location_from_address_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/history_trip_for_rider_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/history_trip_for_user_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/running_trips_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trip_for_rider_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trip_for_user_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/accept_trip_by_driver_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_client.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_rider.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/complete_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_activity_trips.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_completed_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_history_trips_for_rider_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_running_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_location_from_address_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/partial_payment_in_trip.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/recording_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/rider_in_start_location_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/start_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_driver_location_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_trip_price_from_client_use_case.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';

abstract class RideRemoteDataSource {
  ////////////////////Nasr////////////////////
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId);

  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId);

  Future<Either<Failure, bool>> updateDriverLocation(UpdateDriverLocationUseCaseParams params);

  Future<Either<Failure, List<RunningTripsEntity>>> getAllRunningTrips(GetAllRunningTripsUseCaseParams params);

  Future<Either<Failure, List<CompletedTripsEntity>>> getAllCompletedTrips(GetAllCompletedTripsUseCaseParams params);

  Future<Either<Failure, GetLocationFromAddressEntity>> getLocationFromAddress(GetLocationFromAddressUseCaseParams params);

  Future<Either<Failure, bool>> acceptTripByDriver(AcceptTripByDriverUseCaseParams params);

  Future<Either<Failure, bool>> riderInStartLocation(RiderInStartLocationUseCaseParams params);

  Future<Either<Failure, bool>> startTrip(StartTripUseCaseParams params);

  Future<Either<Failure, bool>> partialPaymentInTrip(PartialPaymentInTripUseCaseParams params);

  Future<Either<Failure, bool>> completeTrip(CompleteTripUseCaseParams params);

  Future<Either<Failure, bool>> cancelTripByRider(CancelTripByRiderUseCaseParams params);

  Future<Either<Failure, bool>> cancelTripByClient(CancelTripByClientUseCaseParams params);

  Future<Either<Failure, bool>> recordingTrip(RecordingTripUseCaseParams params);

  Future<Either<Failure, bool>> updateTripPriceFromClient(UpdateTripPriceFromClientUseCaseParams params);

  Future<Either<Failure, ActivityTripEntity>> getAllActivityTrips(GetAllActivityTripsUseCaseParams params);

  Future<Either<Failure, List<HistoryTripForUserEntity>>> getAllHistoryTripsForUser();

  Future<Either<Failure, List<HistoryTripForRiderEntity>>> getAllHistoryTripsForRider(GetAllHistoryTripsForRiderUseCaseParams params);
}

class RideRemoteDataSourceImplementation
    implements RideRemoteDataSource {
  final ApiConsumer _apiConsumer;

  RideRemoteDataSourceImplementation(this._apiConsumer);

  ////////////////////Nasr////////////////////
  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(
      String userId) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getRideCategories(userId),
      );

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel = RideCategoryModelUpdated
            .fromJson(data['data']);
        return Right(rideCategoryModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(
      String userId) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getShippingCategories(userId),
      );

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel = RideCategoryModelUpdated
            .fromJson(data['data']);
        return Right(rideCategoryModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateDriverLocation(
      UpdateDriverLocationUseCaseParams params) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.updateDriverLocation(),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RunningTripsEntity>>> getAllRunningTrips(
      GetAllRunningTripsUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getAllRunningTrips(limit: params.limit, page: params.page),
      );

      return response.fold((failure) => Left(failure), (data) {
        List<RunningTripsModel> runningTrips = [];
        for (var trip in data['data']['trips']) {
          runningTrips.add(RunningTripsModel.fromJson(trip));
        }
        return Right(runningTrips);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CompletedTripsEntity>>> getAllCompletedTrips(
      GetAllCompletedTripsUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getAllCompletedTrips(limit: params.limit, page: params.page),
      );

      return response.fold((failure) => Left(failure), (data) {
        List<CompletedTripsModel> completedTrips = [];
        for (var trip in data['data']['trips']) {
          completedTrips.add(CompletedTripsModel.fromJson(trip));
        }
        return Right(completedTrips);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetLocationFromAddressEntity>> getLocationFromAddress(
      GetLocationFromAddressUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getLocationFromAddress(),
        data: params.toJson(),
      );

      return response.fold((failure) => Left(failure), (data) {
        return Right(GetLocationFromAddressModel.fromJson(data['data']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> acceptTripByDriver(
      AcceptTripByDriverUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.acceptTripByDriver(params.tripId),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> riderInStartLocation(
      RiderInStartLocationUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.rideInStartLocation(params.id),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> startTrip(StartTripUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.startTrip(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> partialPaymentInTrip(
      PartialPaymentInTripUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.partialPaymentInTrip(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> completeTrip(
      CompleteTripUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.completeTripForRide(params.tripId),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelTripByRider(
      CancelTripByRiderUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.cancelTripByRider(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelTripByClient(
      CancelTripByClientUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.cancelTripByClient(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> recordingTrip(
      RecordingTripUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.recordingTrip(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateTripPriceFromClient(
      UpdateTripPriceFromClientUseCaseParams params) async {
    try {
      final response = await _apiConsumer.put(
        EndPoints.updateTripPriceFromClient(params.tripId),
        data: params.toJson(),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActivityTripEntity>> getAllActivityTrips(
      GetAllActivityTripsUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getAllActivityTrips(limit: params.limit, page: params.page),
      );
      return response.fold((failure) => Left(failure), (data) {
        return Right(ActivityTripModel.fromJson(data['data']));
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HistoryTripForUserEntity>>> getAllHistoryTripsForUser() async{

    try {
      final response = await _apiConsumer.get(
        EndPoints.getAllHistoryTripsForUser(),
      );
      return response.fold((failure) => Left(failure), (data) {
        List<HistoryTripForUserModel> historyTripsForUser = [];
        for (var trip in data['data']['trips']) {
          historyTripsForUser.add(HistoryTripForUserModel.fromJson(trip));
        }
        return Right(historyTripsForUser);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HistoryTripForRiderEntity>>> getAllHistoryTripsForRider(GetAllHistoryTripsForRiderUseCaseParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getAllHistoryTripsForRider(
          limit: params.limit,
          page: params.page,
        ),
      );
      return response.fold((failure) => Left(failure), (data) {
        List<HistoryTripForRiderModel> historyTripsForRider = [];
        for (var trip in data['data']['trips']) {
          historyTripsForRider.add(HistoryTripForRiderModel.fromJson(trip));
        }
        return Right(historyTripsForRider);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

