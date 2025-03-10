import 'package:fourtyninehub/features/RideFeature/data/repositories/ride_repository_imp.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_activity_trips.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_completed_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_running_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_location_from_address_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_expexted_price_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_governorates.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_shipping_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/RideFeature/data/datasources/ride_local_data_source.dart';
import '../features/RideFeature/data/datasources/ride_remote_data_source.dart';
import '../features/RideFeature/domain/usecases/get_ride_categories_usecase.dart';

class RideServiceLocatorUpdated {
  static void execute({required GetIt serviceLocator}) {
    // ---------------------------------- data sources ----------------------------------
    serviceLocator.registerLazySingleton<RideRemoteDataSource>(
            () =>
            RideRemoteDataSourceImplementation(
              serviceLocator(),
            ));

    serviceLocator.registerLazySingleton<RideLocalDataSource>(
          () => RideLocalDataSourceImplementation(),
    );

    // ---------------------------------- repositories ----------------------------------
    serviceLocator.registerLazySingleton<RideRepository>(() =>
        RideRepositoryImplementation(serviceLocator()));

    serviceLocator.registerLazySingleton<RideRepositoryImplementation>(() =>
        RideRepositoryImplementation(serviceLocator()));

    // ---------------------------------- use cases ----------------------------------
    serviceLocator.registerLazySingleton<GetRideCategoriesUseCase>(() =>
        GetRideCategoriesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetShippingCategoriesUsecase>(() =>
        GetShippingCategoriesUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideGovernoratesUseCase>(() =>
        GetRideGovernoratesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetLocationFromAddressUseCase>(() =>
        GetLocationFromAddressUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideExpectedPriceUseCase>(() =>
        GetRideExpectedPriceUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAllCompletedTripsUseCase>(() =>
        GetAllCompletedTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAllRunningTripsUseCase>(() =>
        GetAllRunningTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAllActivityTripsUseCase>(() =>
        GetAllActivityTripsUseCase(serviceLocator()));

    // ---------------------------------- cubits ----------------------------------

    serviceLocator.registerLazySingleton<RideCubit>(() =>
        RideCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ),
    );
  }
}
