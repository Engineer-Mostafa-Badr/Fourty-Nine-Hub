import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_cubit/captain_share_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/data/datasources/captain_share_remote_data_source.dart';
import 'package:fourtyninehub/features/new_trip_join/data/repositories/captain_share_repository_imp.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_route_use_case.dart';

class CaptainShareServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    // ================================== datasource =============================
    serviceLocator.registerLazySingleton<CaptainShareRemoteDataSource>(
        () => CaptainShareRemoteDataSourceImplementation(
              serviceLocator(),
            ));
    // ================================== repo =============================
    serviceLocator.registerLazySingleton<CaptainShareRepository>(
        () => CaptainShareRepositoryImplementation(
              serviceLocator(),
            ));
    // ================================== usecases =============================
    serviceLocator.registerLazySingleton<CreatePricePerSeatUseCase>(
        () => CreatePricePerSeatUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<CreateRouteUseCase>(
        () => CreateRouteUseCase(
              serviceLocator(),
            ));
    // ================================== cubits =============================
    serviceLocator.registerFactory<CaptainShareCubit>(
        () => CaptainShareCubit(
              serviceLocator(),
              serviceLocator(),
            ));
  }
}
