import 'package:fourtyninehub/features/shipping/create_shipping_request/data/datasources/images_data_source.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/datasources/shipping_data_source.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/images_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/favorite_shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_all_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/images_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
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
      () => CreateTripCubit(repository: serviceLocator()),
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
