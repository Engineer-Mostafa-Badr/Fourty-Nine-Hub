import 'package:fourtyninehub/features/carpool/add_new_route/data/data_source/add_new_route_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/repo/add_new_route_carpool_repo_imp.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/repo/add_new_route_carpool_repo.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/usecases/get_price_carpool_usecase.dart';
import 'package:get_it/get_it.dart';

class CarpoolServiceLocator {
  static void execute({required GetIt serviceLocator}) {
    //! add new carpool route
    serviceLocator.registerLazySingleton<AddNewRouteRemoteDataSource>(
      () => AddNewRouteRemoteDataSourceImp(apiConsumer: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<AddNewRouteCarpoolRepo>(
      () => AddNewRouteCarpoolRepoImp(
          addNewRouteRemoteDataSource: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<GetPriceCarpoolUsecase>(
      () => GetPriceCarpoolUsecase(addNewRouteCarpoolRepo: serviceLocator()),
    );
  }
}
