
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/create_pick_me_offer_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/trip_join/view_all_trip_join/data/datasource/remote_datasource/view_all_trip_join_remote_datasource.dart';
import '../features/trip_join/view_all_trip_join/data/repos/view_all_trip_join_repo_imp.dart';
import '../features/trip_join/view_all_trip_join/domain/repos/view_all_trip_join_repo.dart';
import '../features/trip_join/view_all_trip_join/domain/usecases/apply_read_request_trip_join_use_case.dart';
import '../features/trip_join/view_all_trip_join/domain/usecases/apply_view_trip_join_use_case.dart';
import '../features/trip_join/view_all_trip_join/domain/usecases/create_trip_join_offer_use_case.dart';
import '../features/trip_join/view_all_trip_join/domain/usecases/delete_my_trip_join_use_case.dart';
import '../features/trip_join/view_all_trip_join/domain/usecases/get_available_trip_join_use_case.dart';
import '../features/trip_join/view_all_trip_join/domain/usecases/get_car_brand_use_case.dart';
import '../features/trip_join/view_all_trip_join/domain/usecases/get_car_model_use_case.dart';
import '../features/trip_join/view_all_trip_join/domain/usecases/get_expected_price_use_case.dart';
import '../features/trip_join/view_all_trip_join/domain/usecases/get_my_ads_trip_join_use_case.dart';
import '../features/trip_join/view_all_trip_join/domain/usecases/get_request_count_trip_join_use_case.dart';
import '../features/trip_join/view_all_trip_join/domain/usecases/get_request_trip_join_use_case.dart';
import '../features/trip_join/view_all_trip_join/presentation/cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';

class NewTripJoinServiceLocation {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<ViewAllTripJoinRemoteDataSource>(() =>
        ViewAllTripJoinRemoteDataSourceImp(apiConsumer: serviceLocator(),));


    serviceLocator.registerLazySingleton<ViewAllTripJoinRepo>(
            () => ViewAllTripJoinRepoImp(viewripJoinRemoteDataSource: serviceLocator()));

    serviceLocator.registerLazySingleton<GetCarBrandUseCase>(
            () => GetCarBrandUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetCarModelUseCase>(
            () => GetCarModelUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetExpectedPriceTripUseCase>(
            () => GetExpectedPriceTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAvailableTripJoinUseCase>(
            () => GetAvailableTripJoinUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRequestTripJoinUseCase>(
            () => GetRequestTripJoinUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetMyAdsTripJoinUseCase>(
            () => GetMyAdsTripJoinUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<DeleteMyTripJoinUseCase>(
            () => DeleteMyTripJoinUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<ApplyViewTripJoinUseCase>(
            () => ApplyViewTripJoinUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<ApplyReadRequestTripJoinUseCase>(
            () => ApplyReadRequestTripJoinUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateTripJoinOfferUseCase>(
            () => CreateTripJoinOfferUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRequestCountTripJoinUseCase>(
            () => GetRequestCountTripJoinUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CreatePickMeOfferUseCase>(
            () => CreatePickMeOfferUseCase(serviceLocator()));



    serviceLocator.registerFactory<ViewAllTripJoinCubit>(() =>
        ViewAllTripJoinCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),

        ));
  }
}
