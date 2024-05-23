import 'package:fourtyninehub/features/RideRequest/data/datasources/remote_data_source.dart';
import 'package:fourtyninehub/features/RideRequest/data/repositories/ride_request_repo_impl.dart';
import 'package:fourtyninehub/features/RideRequest/domain/usecases/request/get_expected_price_use_case.dart';
import 'package:fourtyninehub/features/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/RideRequest/domain/repositories/ride_request_repo.dart';
import '../features/RideRequest/domain/usecases/request/get_near_by_places_usecase.dart';

class RideServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<RideRemoteDataSource>(
        () => RideRemoteDataSourceImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<RideRequestRepo>(
        () => RideRequestRepoImpl(serviceLocator()));

    serviceLocator.registerFactory<RiderequestCubit>(() => RiderequestCubit(
          serviceLocator(),
          serviceLocator(),
        ));

    serviceLocator.registerFactory<GetNearByPlacesUseCase>(
        () => GetNearByPlacesUseCase(serviceLocator()));
    serviceLocator.registerFactory<GetExpectedPriceUseCase>(
        () => GetExpectedPriceUseCase(serviceLocator()));
  }
}
