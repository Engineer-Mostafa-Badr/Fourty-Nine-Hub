import 'package:fourtyninehub/features/ride/RideRequest/data/datasources/remote_data_source.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/repositories/ride_request_repo_impl.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_car_types_use_case.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_expected_price_use_case.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/ride/history_ride/data/datasources/remote_data_source.dart';
import 'package:fourtyninehub/features/ride/history_ride/data/repositories/history_ride_repo_impl.dart';
import 'package:fourtyninehub/features/ride/history_ride/domain/usecases/get_history_ride_use_case.dart';
import 'package:fourtyninehub/features/ride/trip_details/data/datasources/remote_data_source.dart';
import 'package:fourtyninehub/features/ride/trip_details/domain/usecases/get_cancel_reason_use_case.dart';
import 'package:fourtyninehub/features/ride/trip_details/domain/usecases/get_trip_details_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/ride/RideRequest/domain/repositories/ride_request_repo.dart';
import '../features/ride/RideRequest/domain/usecases/request/get_near_by_places_usecase.dart';
import '../features/register/driver_register/presentation/cubit/driver_register_cubit.dart';
import '../features/ride/history_ride/domain/repositories/history_ride_repo.dart';
import '../features/ride/history_ride/presentation/cubit/history_ride_cubit.dart';
import '../features/ride/trip_details/data/repositories/trip_details_repo_impl.dart';
import '../features/ride/trip_details/domain/repositories/trip_details_repo.dart';
import '../features/ride/trip_details/presentation/cubit/trip_details_cubit.dart';

class RideServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    // datasource
    serviceLocator.registerLazySingleton<RideRemoteDataSource>(
        () => RideRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<HistoryRideRemoteDataSource>(
        () => HistoryRideRemoteDataSourceImpl(serviceLocator()));

serviceLocator.registerLazySingleton<TripDetailsRemoteDataSource>(
        () => TripDetailsRemoteDataSourceImpl(serviceLocator()));
    // repo
    serviceLocator.registerLazySingleton<RideRequestRepo>(
        () => RideRequestRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<HistoryRideRepo>(
        () => HistoryRideRepoImpl(serviceLocator()));

 serviceLocator.registerLazySingleton<TripDetailsRepo>(
        () => TripDetailsRepoImpl(serviceLocator()));
    // cubit
    serviceLocator.registerFactory<RiderequestCubit>(() => RiderequestCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        )..loadData());
    serviceLocator.registerFactory<HistoryRideCubit>(() => HistoryRideCubit(
          serviceLocator(),
        )..loadData());
 serviceLocator.registerFactory<TripDetailsCubit>(() => TripDetailsCubit(
          serviceLocator(),
          serviceLocator(),
        )..loadData());
    serviceLocator
        .registerFactory<DriverRegisterCubit>(() => DriverRegisterCubit(
              serviceLocator(),
              serviceLocator(),
            )..loadData());

    // usecases
 serviceLocator.registerFactory<GetTripDetailsUseCase>(
        () => GetTripDetailsUseCase(serviceLocator()));
     serviceLocator.registerFactory<GetCancelReasonUseCase>(
        () => GetCancelReasonUseCase(serviceLocator()));
    
    serviceLocator.registerFactory<GetHistoryRideUseCase>(
        () => GetHistoryRideUseCase(serviceLocator()));
    serviceLocator.registerFactory<GetNearByPlacesUseCase>(
        () => GetNearByPlacesUseCase(serviceLocator()));
    serviceLocator.registerFactory<GetExpectedPriceUseCase>(
        () => GetExpectedPriceUseCase(serviceLocator()));
    serviceLocator.registerFactory<GetCarTypesUseCase>(
        () => GetCarTypesUseCase(serviceLocator()));
    serviceLocator.registerFactory<GetSubCategoriesUseCase>(
        () => GetSubCategoriesUseCase(serviceLocator()));
  }
}
