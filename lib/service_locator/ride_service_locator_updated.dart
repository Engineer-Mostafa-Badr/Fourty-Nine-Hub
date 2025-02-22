import 'package:fourtyninehub/features/RideFeature/data/repositories/ride_repository_imp.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
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

    // ---------------------------------- cubits ----------------------------------

    serviceLocator.registerLazySingleton<RideCubit>(() => RideCubit(serviceLocator(), serviceLocator(),));
  }
}
