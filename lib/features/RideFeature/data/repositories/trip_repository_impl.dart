import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trips_response_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/create_driver_rating_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/update_settings_dashboard_usecase.dart';

import '../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import '../datasources/dashboard_remote_data_source.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;

  TripRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TripsResponseEntity>> getAvailableTrips(AvailableRideTripsUseCaseParams params) async {
    final tripsResponseModel = await remoteDataSource.getAvailableTrips(params);
    return tripsResponseModel;
  }

  @override
  Future<Either<Failure, TripsResponseEntity>> getPastTrips(String type) async {
    final tripsResponseModel = await remoteDataSource.getPastTrips(type);
    return tripsResponseModel;
  }
  
  @override
  Future<Either<Failure, SettingsDashboardEntityResponse>> getSettings() async{
    final settingsResponseModel = await remoteDataSource.getSettings();
    return settingsResponseModel;
  }

  @override
  Future<Either<Failure, bool>> updateSettings(UpdateSettingsDashboardUsecaseParam params) async{
    return await remoteDataSource.updateSettings(params);
  }

  @override
  Future<Either<Failure, bool>> createNewOffer(CreateNewOfferDashboardUsecaseParam params) async{
    return await remoteDataSource.createNewOffer(params);
  }

  @override
  Future<Either<Failure, bool>> createDriverRating(CreateUpdateDriverRatingUsecaseParam params) async{
   return await remoteDataSource.createDriverRating(params);
  }
  @override
  Future<Either<Failure, bool>> updateDriverRating(CreateUpdateDriverRatingUsecaseParam params) async{
   return await remoteDataSource.updateDriverRating(params);
  }

}
