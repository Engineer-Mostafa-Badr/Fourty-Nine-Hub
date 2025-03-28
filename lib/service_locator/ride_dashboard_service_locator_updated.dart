

import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/RideFeature/data/datasources/dashboard_remote_data_source.dart';
import '../features/RideFeature/data/repositories/trip_repository_impl.dart';
import '../features/RideFeature/domain/repositories/trip_repository.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_available_trips_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_past_trips_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_settings_dashboard_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import '../features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';

class RideDashboardServiceLocatorUpdated {
  static void execute({required GetIt serviceLocator}) {
    // ---------------------------------- data sources ----------------------------------
    serviceLocator.registerLazySingleton<TripRemoteDataSource>(() => TripRemoteDataSourceImplementation(
          serviceLocator(),
        ));

    // ---------------------------------- repositories ----------------------------------
    serviceLocator.registerLazySingleton<TripRepository>(() => TripRepositoryImpl(serviceLocator()));


    // ---------------------------------- use cases ----------------------------------
    serviceLocator.registerLazySingleton<GetAvailableTripsUsecase>(() => GetAvailableTripsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetPastTripsUsecase>(() => GetPastTripsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<AvailableRideTripsUseCase>(() => AvailableRideTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetSettingsDashboardUsecase>(() => GetSettingsDashboardUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateSettingsDashboardUsecase>(() => UpdateSettingsDashboardUsecase(serviceLocator()));

    // ---------------------------------- cubits ----------------------------------

    serviceLocator.registerFactory<DashboardsCubit>(() => DashboardsCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
