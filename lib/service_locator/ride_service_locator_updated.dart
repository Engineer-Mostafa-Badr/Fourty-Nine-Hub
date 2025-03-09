import 'package:fourtyninehub/features/RideFeature/data/repositories/ride_repository_imp.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_brands_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_car_colors_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_governorates.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_models_usecase.dart';
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
            () => RideRemoteDataSourceImplementation(
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
    serviceLocator.registerLazySingleton<GetRideCategoriesUseCase>(() => GetRideCategoriesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetShippingCategoriesUsecase>(() => GetShippingCategoriesUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideGovernoratesUseCase>(() => GetRideGovernoratesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideBrandsUseCase>(() => GetRideBrandsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideModelsUseCase>(() => GetRideModelsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideCarColorsUseCase>(() => GetRideCarColorsUseCase(serviceLocator()));

    // ---------------------------------- cubits ----------------------------------

    serviceLocator.registerLazySingleton<RideCubit>(() => RideCubit(serviceLocator(), serviceLocator(),serviceLocator(),serviceLocator(),serviceLocator(),serviceLocator(),));
  }
}
