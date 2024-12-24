import 'package:fourtyninehub/features/carpool/add_new_route/data/data_source/add_new_route_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/data_source/verify_otp_complete_seat_driver_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/repo/add_new_route_carpool_repo_imp.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/repo/add_new_route_carpool_repo.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/usecases/get_price_carpool_usecase.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/verify_complet_driver/cubit/verify_complete_driver_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/accept_trip/cubit/accept_trip_for_driver_cubit.dart';
import 'package:get_it/get_it.dart';

class CarpoolServiceLocator {
  static void execute({required GetIt serviceLocator}) {
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
    serviceLocator.registerFactory<AcceptTripForDriverCubit>(
      () => AcceptTripForDriverCubit(serviceLocator()),
    );
    serviceLocator.registerFactory<VerifyCompleteDriverCubit>(
      () => VerifyCompleteDriverCubit(
          verifyOtpCompleteSeatDriverRemoteDataSource: serviceLocator()),
    );
    serviceLocator
        .registerLazySingleton<VerifyOtpCompleteSeatDriverRemoteDataSource>(
      () => VerifyOtpCompleteSeatDriverRemoteDataSourceImp(
          apiConsumer: serviceLocator()),
    );
  }
}
