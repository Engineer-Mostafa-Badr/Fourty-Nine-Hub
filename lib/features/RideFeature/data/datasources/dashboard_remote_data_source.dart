import 'package:dartz/dartz.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../domain/usecases/dashboards/create_driver_rating_usecase.dart';
import '../../domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import '../../domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import '../../domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import '../models/dashboards/settings_dashboard_model.dart';
import '../models/dashboards/trips_response_model.dart';

abstract class TripRemoteDataSource {
  Future<Either<Failure, TripsResponseModel>> getAvailableTrips(
      AvailableRideTripsUseCaseParams params);
  Future<Either<Failure, TripsResponseModel>> getPastTrips(String type);
  Future<Either<Failure, SettingsDashboardEntityResponse>> getSettings();
  Future<Either<Failure, bool>> updateSettings(
      UpdateSettingsDashboardUsecaseParam params);
  Future<Either<Failure, bool>> createNewOffer(
      CreateNewOfferDashboardUsecaseParam params);
  Future<Either<Failure, bool>> createNewOfferNonSocket(
      CreateNewOfferDashboardUsecaseParam params);
  Future<Either<Failure, bool>> createDriverRating(
      CreateUpdateDriverRatingUsecaseParam params);
  Future<Either<Failure, bool>> updateDriverRating(
      CreateUpdateDriverRatingUsecaseParam params);
}

class TripRemoteDataSourceImplementation implements TripRemoteDataSource {
  final ApiConsumer _apiConsumer;

  TripRemoteDataSourceImplementation(this._apiConsumer);

  @override
  Future<Either<Failure, TripsResponseModel>> getAvailableTrips(
      AvailableRideTripsUseCaseParams params) async {
    try {
      final response =
          await _apiConsumer.get(EndPoints.getAvailableTrips(params));

      return response.fold((failure) => Left(failure), (data) {
        TripsResponseModel tripsResponseModel =
            TripsResponseModel.fromJson(data);
        return Right(tripsResponseModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TripsResponseModel>> getPastTrips(String type) async {
    try {
      final response = await _apiConsumer.get(EndPoints.getPastTrips(1, type));

      return response.fold((failure) => Left(failure), (data) {
        TripsResponseModel tripsResponseModel =
            TripsResponseModel.fromJson(data);
        return Right(tripsResponseModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SettingsDashboardEntityResponse>> getSettings() async {
    try {
      final response = await _apiConsumer.get(EndPoints.getSettingsDashboard);

      return response.fold((failure) => Left(failure), (data) {
        SettingsDashboardResponseModel settingsResponseModel =
            SettingsDashboardResponseModel.fromJson(data);
        return Right(settingsResponseModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateSettings(
      UpdateSettingsDashboardUsecaseParam params) async {
    try {
      final response = await _apiConsumer.put(EndPoints.getSettingsDashboard,
          data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createNewOffer(
      CreateNewOfferDashboardUsecaseParam params) async {
    try {
      final response = await _apiConsumer
          .post(EndPoints.createNewOffer(params.tripId), data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createNewOfferNonSocket(
      CreateNewOfferDashboardUsecaseParam params) async {
    try {
      final response = await _apiConsumer.post(
          EndPoints.createNewOfferNonSocket(params.tripId),
          data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createDriverRating(
      CreateUpdateDriverRatingUsecaseParam params) async {
    try {
      final response = await _apiConsumer.post(EndPoints.createDriverRating,
          data: params.toJson());

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateDriverRating(
      CreateUpdateDriverRatingUsecaseParam params) async {
    try {
      final response = await _apiConsumer.put(
          EndPoints.updateDriverRating(params.tripId),
          data: params.toJson()['newComment']);

      return response.fold((failure) => Left(failure), (data) {
        return Right(data['status']);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
