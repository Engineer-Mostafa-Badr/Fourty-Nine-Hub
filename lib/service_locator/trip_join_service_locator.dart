import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/google_api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/interceptors/subscription_interceptor.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/data/data_source/add_new_pick_me_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/data/repo/add_new_pick_me_repo_imp.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/domain/repo/add_new_pick_me_repo.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/domain/use_cases/add_new_pick_me_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/presentation/cubits/cubit/add_new_pick_me_trip_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/remote_data_source/fetch_location_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/remote_data_source/trip_join_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/repo/trip_join_google_api_repo_imp.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/repo/trip_join_repo_imp.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/repo/trip_join_google_api_repo.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/repo/trip_join_repo.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_car_brand_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_car_model_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_car_year_type_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_location_cordinates_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_price_distance_usecase.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/publish_trip_join_usecase.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/data/data_source/fetch_my_all_pick_me_remote_data_source.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/data/repo/fetch_my_pick_me_repo_imp.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/domain/repo/fetch_my_pick_me_repo.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/domain/use_cases/fetch_my_pick_me_use_case.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/presentation/cubits/fetch_my_pick_me_trips/cubit/fetch_my_pick_me_trips_cubit.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/data/data_source/get_requests_pick_me_remote_data_source.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/data/repo/get_requests_pick_me_repo_imp.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/domain/repo/get_requests_pick_me_repo.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/domain/use_case/get_requests_pick_me_use_case.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/presentation/cubits/cubit/get_requests_pick_me_cubit.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/data/datasource/trip_join_request_history_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/data/repo/trip_join_request_history_repo_impl.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/repo/trip_join_request_history_repo.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/usecases/delet_trip_usecase.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/usecases/fetch_ty_trip_join_ads_usecase.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/usecases/get_request_usecase.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/data/data_source/view_all_pick_me_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/data/repo/view_all_pick_me_repo_imp.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/repo/view_all_pick_me_repo.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/usecases/view_all_pick_me_usecase.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/data/datasource/remote_datasource/view_all_trip_join_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/data/repos/view_all_trip_join_repo_imp.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/repos/view_all_trip_join_repo.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/request_trip_join_usecase.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/view_all_trip_join_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class TripJoinServiceLocator {
  //! google api db injection
  static void execute({required GetIt serviceLocator}) {
    serviceLocator.registerLazySingleton<Dio>(
      () => Dio()
        ..interceptors.addAll([
          SubscriptionInterceptor(),
          if (kDebugMode)
            PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseBody: true,
              responseHeader: false,
              error: true,
              compact: true,
              maxWidth: 90,
            )
        ]),
      instanceName: 'dioGoogleApi',
    );

    serviceLocator.registerLazySingleton<GoogleApiConsumer>(
      () =>
          GoogleApiConsumer(dio: serviceLocator(instanceName: 'dioGoogleApi')),
    );

    serviceLocator.registerLazySingleton<FetchLocationRemoteDataSource>(
      () =>
          FetchLocationRemoteDataSourceImp(googleApiConsumer: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<TripJoinGoogleApiRepo>(
      () => TripJoinGoogleApiRepoImp(
          fetchLocationRemoteDataSource: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<FetchLocationCordinatesUseCase>(
      () => FetchLocationCordinatesUseCase(
          tripJoinGoogleApiRepo: serviceLocator()),
    );

    //! add new trip join db injection
    serviceLocator.registerLazySingleton<TripJoinRemoteDataSource>(
      () => TripJoinRemoteDataSourceImp(apiConsumer: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<TripJoinRepo>(
      () => TripJoinRepoImp(tripJoinRemoteDataSource: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<FetchPriceDistanceUsecase>(
      () => FetchPriceDistanceUsecase(tripJoinRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<FetchCarBrandUseCase>(
      () => FetchCarBrandUseCase(tripJoinRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<FetchCarModelUseCase>(
      () => FetchCarModelUseCase(tripJoinRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<FetchCarYearTypeUseCase>(
      () => FetchCarYearTypeUseCase(tripJoinRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<PublishTripJoinUseCase>(
      () => PublishTripJoinUseCase(tripJoinRepo: serviceLocator()),
    );

    //! view all trip join db injection
    // serviceLocator.registerLazySingleton<ViewAllTripJoinRemoteDataSource>(
    //   () => ViewAllTripJoinRemoteDataSourceImp(apiConsumer: serviceLocator()),
    // );
    // serviceLocator.registerLazySingleton<ViewAllTripJoinRepo>(
    //   () =>
    //       ViewAllTripJoinRepoImp(viewripJoinRemoteDataSource: serviceLocator()),
    // );
    serviceLocator.registerLazySingleton<ViewAllTripJoinUseCase>(
      () => ViewAllTripJoinUseCase(viewAllTripJoinRepo: serviceLocator()),
    );

    //! request trip join
    serviceLocator.registerLazySingleton<RequstTripJoinUseCase>(
      () => RequstTripJoinUseCase(viewAllTripJoinRepo: serviceLocator()),
    );

    //! get my trip join ads
    serviceLocator
        .registerLazySingleton<TripJoinRequestHistoryRemoteDataSource>(
      () => TripJoinRequestHistoryRemoteDataSourceImp(
          apiConsumer: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<TripJoinRequestHistoryRepo>(
      () => TripJoinRequestHistoryRepoImp(
          tripJoinRequestHistoryRemoteDataSource: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<FetchMyTripJoinAdsUseCase>(
      () => FetchMyTripJoinAdsUseCase(
          tripJoinRequestHistoryRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<DeleteTripUseCase>(
      () => DeleteTripUseCase(tripJoinRequestHistoryRepo: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<GetRequestUsecase>(
      () => GetRequestUsecase(tripJoinRequestHistoryRepo: serviceLocator()),
    );

    //! get all pick me
    serviceLocator.registerLazySingleton<ViewAllPickMeRemoteDataSource>(
      () => ViewAllPickMeRemoteDataSourceImp(apiConsumer: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<ViewAllPickMeRepo>(
      () =>
          ViewAllPickMeRepoImp(viewAllPickMeRemoteDataSource: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<ViewAllPickMeUseCase>(
      () => ViewAllPickMeUseCase(viewAllPickMeRepo: serviceLocator()),
    );

    serviceLocator.registerLazySingleton<AddNewPickMeRemoteDatasource>(
      () => AddNewPickMeRemoteDatasourceImp(apiConsumer: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<AddNewPickMeRepo>(
      () => AddNewPickMeRepoImp(addNewPickMeRemoteDatasource: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<AddNewPickMeUsecase>(
      () => AddNewPickMeUsecase(addNewPickMeRepo: serviceLocator()),
    );

    serviceLocator.registerFactory<AddNewPickMeTripCubit>(
      () => AddNewPickMeTripCubit(serviceLocator(),serviceLocator(),serviceLocator()),
    );

    //____________FetchMyPickMe_______________//

    serviceLocator.registerLazySingleton<FetchMyAllPickMeRemoteDataSource>(
      () => FetchMyAllPickMeRemoteDataSourceImp(apiConsumer: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<FetchMyPickMeRepo>(
      () => FetchMyPickMeRepoImp(
          fetchMyAllPickMeRemoteDataSource: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<FetchMyPickMeUseCase>(
      () => FetchMyPickMeUseCase(fetchMyPickMeRepo: serviceLocator()),
    );

    serviceLocator.registerFactory<FetchMyPickMeTripsCubit>(
      () => FetchMyPickMeTripsCubit(fetchMyPickMeUseCase: serviceLocator()),
    );

    //_________get_requests_pickMe//

    serviceLocator.registerLazySingleton<GetRequestsPickMeRemoteDataSource>(
      () => GetRequestsPickMeRemoteDataSourceImp(apiConsumer: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<GetRequestsPickMeRepo>(
      () => GetRequestsPickMeRepoImp(
          getRequestsPickMeRemoteDataSource: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<GetRequestsPickMeUseCase>(
      () => GetRequestsPickMeUseCase(getRequestsPickMeRepo: serviceLocator()),
    );

    serviceLocator.registerFactory<GetRequestsPickMeCubit>(
      () => GetRequestsPickMeCubit(getRequestsPickMeUseCase: serviceLocator()),
    );
  }
}
