import '../features/requests_history/presentation/cubit/get_shipping_request_cubit.dart';
import '../features/shipping/create_shipping_request/data/datasources/images_data_source.dart';
import '../features/shipping/create_shipping_request/data/datasources/shipping_data_source.dart';
import '../features/shipping/create_shipping_request/data/repositories/images_repository.dart';
import '../features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/accept_decline_trip_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/create_trip_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/delete_driver_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/driverStatistics_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/favorite_main_cateogry_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/favorite_shipping_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/get_all_request_by_my_trip_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/get_all_trip_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/get_driver_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/get_driver_dashboard_data.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/get_my_trip_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/images_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import '../features/shipping/create_shipping_request/presentation/cubit/update_driver_cubit.dart';
import 'package:get_it/get_it.dart';

class ShippingServiceLocatior {
  static Future<void> execute({required GetIt serviceLocator}) async {
    //dataSource
    serviceLocator.registerLazySingleton(
      () => ShippingDataSource(
          api: serviceLocator(), cacheService: serviceLocator()),
    );
    serviceLocator.registerLazySingleton(
      () => ImagesDataSource(api: serviceLocator()),
    );

    //Cubit
    serviceLocator.registerFactory(
      () => ShippingCubit(
          repository: serviceLocator(),
          imageRepository: serviceLocator(),
          cacheService: serviceLocator()),
    );
    serviceLocator.registerFactory(
      () => FavoriteShippingCubit(repository: serviceLocator()),
    );

    serviceLocator.registerFactory(
      () => AcceptDeclineTripCubit(repository: serviceLocator()),
    );
    serviceLocator.registerFactory(
      () => FavoriteMainCateogryCubit(repository: serviceLocator()),
    );
    serviceLocator.registerFactory(
      () => GetShippingRequestCubit(repository: serviceLocator())
        ..getAllRequest(),
    );
    serviceLocator.registerFactory(
      () => GetMyTripCubit(repository: serviceLocator())..getMyTrip(),
    );
    serviceLocator.registerFactory(
      () => DeleteDriverCubit(repository: serviceLocator()),
    );
    serviceLocator.registerFactory(
      () => GetAllRequestByMyTripCubit(repository: serviceLocator())
        ..getAllRequest(),
    );
    serviceLocator.registerFactory(
      () => CreateTripCubit(repository: serviceLocator()),
    );
    serviceLocator.registerFactory(
      () => GetDriverCubit(repository: serviceLocator())..getDriverData(),
    );
    serviceLocator.registerFactory(
      () => DriverStatisticsCubit(repository: serviceLocator()),
    );

    serviceLocator.registerFactory(
      () => GetDriverDashboardData(repository: serviceLocator()),
    );
    serviceLocator.registerFactory(
      () => UpdateDriverCubit(repository: serviceLocator()),
    );
    serviceLocator.registerFactory(
      () => ImagesCubit(repository: serviceLocator()),
    );
    serviceLocator.registerFactory(
      () => GetAllTripCubit(repository: serviceLocator())..getAllTrips(),
    );
    serviceLocator.registerFactory(
      () => TripCubit(repository: serviceLocator()),
    );
    serviceLocator.registerFactory(
      () => CallMessageCubit(repository: serviceLocator()),
    );
    //Repo
    serviceLocator.registerLazySingleton(
      () => ShippingRepository(
          dataSource: serviceLocator(), repository: serviceLocator()),
    );
    serviceLocator.registerLazySingleton(
      () => ImagesRepository(dataSource: serviceLocator()),
    );
  }
}
