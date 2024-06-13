import 'package:fourtyninehub/features/requests_history/domain/usecases/get_food_history_usecase.dart';
import 'package:fourtyninehub/features/requests_history/presentation/cubit/request_history_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/datasources/remote_data_source.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/repositories/ride_request_repo_impl.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_car_types_use_case.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_expected_price_use_case.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/data/datasources/driver_dashboard_remote_data_source.dart';
import 'package:fourtyninehub/features/requests_history/data/datasources/request_history_remote_data_source.dart';
import 'package:fourtyninehub/features/requests_history/data/repositories/history_ride_repo_impl.dart';
import 'package:fourtyninehub/features/requests_history/domain/usecases/get_history_ride_use_case.dart';
import 'package:fourtyninehub/features/ride/trip_details/data/datasources/remote_data_source.dart';
import 'package:fourtyninehub/features/ride/trip_details/domain/usecases/get_cancel_reason_use_case.dart';
import 'package:fourtyninehub/features/ride/trip_details/domain/usecases/get_trip_details_use_case.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/datasources/create_shipping_remote_data_source.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/create_shipping_repo_impl.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/domain/usecases/get_shipping_expected_price_usecase.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/domain/usecases/get_shipping_subcategories_usecase.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:get_it/get_it.dart';
import '../features/ride/RideRequest/domain/repositories/ride_request_repo.dart';
import '../features/ride/RideRequest/domain/usecases/request/get_near_by_places_usecase.dart';
import '../features/register/driver_register/presentation/cubit/driver_register_cubit.dart';
import '../features/ride/driver_dashboard/data/repositories/driver_dashboard_repo_impl.dart';
import '../features/ride/driver_dashboard/domain/repositories/driver_dashboard_repo.dart';
import '../features/ride/driver_dashboard/domain/usecases/get_driver_new_trips_usecase.dart';
import '../features/ride/driver_dashboard/domain/usecases/get_driver_statistics_usecase.dart';
import '../features/ride/driver_dashboard/presentation/cubit/driver_dashboard_cubit.dart';
import '../features/requests_history/domain/repositories/history_ride_repo.dart';
import '../features/ride/trip_details/data/repositories/trip_details_repo_impl.dart';
import '../features/ride/trip_details/domain/repositories/trip_details_repo.dart';
import '../features/ride/trip_details/presentation/cubit/trip_details_cubit.dart';
import '../features/shipping/create_shipping_request/domain/repositories/create_shipping_repo.dart';

class RideServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    // datasource
    serviceLocator.registerLazySingleton<RideRemoteDataSource>(
        () => RideRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<RequestHistoryRemoteDataSource>(
        () => RequestHistoryRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateShippingRemoteDataSource>(
        () => CreateShippingRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<TripDetailsRemoteDataSource>(
        () => TripDetailsRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<DriverDashboardRemoteDataSource>(
        () => DriverDashboardRemoteDataSourceImpl(serviceLocator()));

    // repo
    serviceLocator.registerLazySingleton<RideRequestRepo>(
        () => RideRequestRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<RequestHistoryRepo>(
        () => RequestHistoryRepoImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<TripDetailsRepo>(
        () => TripDetailsRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<DriverDashboardRepo>(
        () => DriverDashboardRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateShippingRepo>(
        () => CreateShippingRepoImpl(serviceLocator()));
    // cubit
    serviceLocator.registerFactory<RiderequestCubit>(() => RiderequestCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        )..loadData());
    serviceLocator
        .registerFactory<RequestHistoryCubit>(() => RequestHistoryCubit(
              serviceLocator(),
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

    serviceLocator
        .registerFactory<DriverDashboardCubit>(() => DriverDashboardCubit(
              serviceLocator(),
              serviceLocator(),
            )..loadData());
    // -------------------------- shipping ----------------------------
    serviceLocator.registerFactory<CreateShippingRequestCubit>(
        () => CreateShippingRequestCubit(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            )..loadData());
    // ---------------------------

    serviceLocator.registerFactory<GetDriverStatisticsUseCase>(
        () => GetDriverStatisticsUseCase(serviceLocator()));
    serviceLocator.registerFactory<GetDriverNewTripsUseCase>(
        () => GetDriverNewTripsUseCase(serviceLocator()));

    serviceLocator.registerFactory<GetTripDetailsUseCase>(
        () => GetTripDetailsUseCase(serviceLocator()));
    serviceLocator.registerFactory<GetCancelReasonUseCase>(
        () => GetCancelReasonUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetFoodHistoryUseCase>(
        () => GetFoodHistoryUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetHistoryRideUseCase>(
        () => GetHistoryRideUseCase(serviceLocator()));
    serviceLocator.registerFactory<GetShippingExpectedPriceUseCase>(
        () => GetShippingExpectedPriceUseCase(serviceLocator()));
    serviceLocator.registerFactory<GetShippingSubCategoriesUseCase>(
        () => GetShippingSubCategoriesUseCase(serviceLocator()));
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
