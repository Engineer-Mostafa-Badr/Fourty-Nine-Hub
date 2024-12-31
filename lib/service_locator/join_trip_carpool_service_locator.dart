import 'package:fourtyninehub/features/carpool/add_new_route/data/data_source/get_lat_long_from_address_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/cubit/dest_get_lat_and_long_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/get_lat_and_long_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/data/data_source/get_all_trips_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/data/repo/get_all_trips_repo_imp.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/repo/get_all_trips_repo.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/use_case/get_all_trips_usecase.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_available_trips_for_drivers/cubit/get_available_trips_for_drivers_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/data/data_source/create_carpool_remote_datasource.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/data/repo/create_carpool_repo_imp.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/domain/repo/create_carpool_repo.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/domain/usecases/create_carpool_usecase.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/presentation/cubits/cubit/create_car_pool_cubit.dart';
import 'package:fourtyninehub/features/carpool/join_trip/data/data_source/join_trip_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/join_trip/data/repo/join_trip_carpool_repo_imp.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/repo/join_trip_carpool_repo.dart';
import 'package:fourtyninehub/features/carpool/join_trip/domain/usecases/join_trip_carpool_usecase.dart';
import 'package:fourtyninehub/features/carpool/join_trip/presentation/cubits/cubit/join_trip_car_pool_cubit.dart';
import 'package:get_it/get_it.dart';

class JoinTripCarpoolServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    //concrete class return implementation class
    serviceLocator.registerLazySingleton<JoinTripRemoteDataSource>(
      () => JoinTripRemoteDataSourceImp(
        apiConsumer: serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<JoinTripCarpoolRepo>(
      () => JoinTripCarpoolRepoImp(
        joinTripRemoteDataSource: serviceLocator(),
      ),
    );
    serviceLocator.registerFactory(
        () => JoinTripCarpoolUsecase(joinTripCarpoolRepo: serviceLocator()));

    serviceLocator.registerFactory<JoinTripCarPoolCubit>(
        () => JoinTripCarPoolCubit(joinTripCarpoolUsecase: serviceLocator()));

    //Create Car pool endPoint//
    serviceLocator.registerLazySingleton<CreateCarpoolRemoteDatasource>(
      () => CreateCarpoolRemoteDatasourceImp(
        apiConsumer: serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<CreateCarpoolRepo>(
      () => CreateCarpoolRepoImp(
        createCarpoolRemoteDatasource: serviceLocator(),
      ),
    );
    //usecases
    serviceLocator.registerFactory(
        () => CreateCarpoolUsecase(createCarpoolRepo: serviceLocator()));

    serviceLocator.registerLazySingleton<CreateCarPoolCubit>(
        () => CreateCarPoolCubit(createCarpoolUsecase: serviceLocator()));

    //all Trips Car pool endPoint//
    serviceLocator.registerLazySingleton<GetAllTripsRemoteDataSource>(
      () => GetAllTripsRemoteDataSourceImpl(),
    );
    serviceLocator.registerFactory<GetAvailableTripsForDriversCubit>(
        () => GetAvailableTripsForDriversCubit());

    serviceLocator.registerLazySingleton<GetAllTripsRepo>(
      () => GetAllTripsRepoImp(
        serviceLocator(),
      ),
    );
    //usecases
    serviceLocator.registerFactory(() => GetAllTripsUseCase(serviceLocator()));

    serviceLocator.registerFactory<GetAllTripsCubit>(
        () => GetAllTripsCubit(apiConsumer: serviceLocator()));

    //Get Currency//
    serviceLocator.registerFactory<GetCurrencyCubit>(
        () => GetCurrencyCubit(serviceLocator()));

    //getLatAndLong
    serviceLocator.registerFactory<GetLatAndLongCubit>(() => GetLatAndLongCubit(
        getLatLongFromAddressRemoteDataSource: serviceLocator()));
    serviceLocator.registerFactory<DestGetLatAndLongCubit>(() =>
        DestGetLatAndLongCubit(
            getLatLongFromAddressRemoteDataSource: serviceLocator()));

    serviceLocator.registerLazySingleton<GetLatLongFromAddressRemoteDataSource>(
        () => GetLatLongFromAddressRemoteDataSourceImp(
            apiConsumer: serviceLocator()));
  }
}
