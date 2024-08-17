import 'package:fourtyninehub/features/shipping/create_shipping_request/data/datasources/images_data_source.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/datasources/shipping_data_source.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/images_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/images_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:get_it/get_it.dart';

class ShippingServiceLocatior {
  static Future<void> execute({required GetIt serviceLocator}) async {
    //dataSource
    serviceLocator.registerLazySingleton(
      () => ShippingDataSource(api: serviceLocator()),
    );
    serviceLocator.registerLazySingleton(
      () => ImagesDataSource(api: serviceLocator()),
    );
    //Cubit
    serviceLocator.registerFactory(
      () => ShippingCubit(repository: serviceLocator(), imageRepository: serviceLocator()),
    );
    serviceLocator.registerFactory(
      () => ImagesCubit(repository: serviceLocator()),
    );
    //Repo
    serviceLocator.registerLazySingleton(
      () => ShippingRepository(
          dataSource: serviceLocator(), repository: serviceLocator()),
    );
    serviceLocator.registerLazySingleton(
      () => ImagesRepository(
          dataSource: serviceLocator()),
    );
  }
}
