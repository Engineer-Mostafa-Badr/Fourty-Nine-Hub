import 'package:fourtyninehub/features/RideFeature/data/repositories/ride_repository_imp.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/accept_offer_by_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_pending_trip_by_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/check_real_amount_enough_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_activity_trips.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_completed_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_running_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_cost_per_km_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_loading_info_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_location_from_address_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_expexted_price_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_governorates.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_driver_picture_optional.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_brands_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_car_colors_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_driver_information.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_models_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_shipping_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/listen_to_ride_offers_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/loading_register_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/make_request_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/recording_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/register_ride_not_special_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/register_ride_special_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/request_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/retrieve_client_latest_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_trip_auto_accept_by_client_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/RideFeature/data/datasources/ride_local_data_source.dart';
import '../features/RideFeature/data/datasources/ride_remote_data_source.dart';
import '../features/RideFeature/data/datasources/shipping_remote_data_source.dart';
import '../features/RideFeature/data/repositories/shipping_repository_imp.dart';
import '../features/RideFeature/domain/repositories/shipping_repository.dart';
import '../features/RideFeature/domain/usecases/create_loading_trip_usecase.dart';
import '../features/RideFeature/domain/usecases/get_ride_categories_usecase.dart';

class RideServiceLocatorUpdated {
  static void execute({required GetIt serviceLocator}) {
    // ---------------------------------- data sources ----------------------------------
    serviceLocator.registerLazySingleton<RideRemoteDataSource>(() => RideRemoteDataSourceImplementation(
          serviceLocator(),
        ));
    serviceLocator.registerLazySingleton<ShippingRemoteDataSource>(
            () => ShippingRemoteDataSourceImplementation(
          serviceLocator(),
        ));
    // serviceLocator.registerLazySingleton<RideRemoteDataSource>(
    //         () =>
    //         RideRemoteDataSourceImplementation(
    //           serviceLocator(),
    //         ));

    serviceLocator.registerLazySingleton<RideLocalDataSource>(
      () => RideLocalDataSourceImplementation(),
    );

    // ---------------------------------- repositories ----------------------------------
    serviceLocator.registerLazySingleton<RideRepository>(() => RideRepositoryImplementation(serviceLocator()));

    serviceLocator.registerLazySingleton<ShippingRepository>(() =>
        ShippingRepositoryImplementation(serviceLocator()));


    // ---------------------------------- use cases ----------------------------------
    serviceLocator.registerLazySingleton<GetRideCategoriesUseCase>(() => GetRideCategoriesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetShippingCategoriesUsecase>(() => GetShippingCategoriesUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideGovernoratesUseCase>(() => GetRideGovernoratesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideBrandsUseCase>(() => GetRideBrandsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideModelsUseCase>(() => GetRideModelsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideCarColorsUseCase>(() => GetRideCarColorsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<RegisterRideSpecialUseCase>(() => RegisterRideSpecialUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideDriverInfoUseCase>(() => GetRideDriverInfoUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDriverPictureOptionalUseCase>(() => GetDriverPictureOptionalUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateLoadingTripUseCase>(() => CreateLoadingTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetLocationFromAddressUseCase>(() =>
        GetLocationFromAddressUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideExpectedPriceUseCase>(() =>
        GetRideExpectedPriceUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAllCompletedTripsUseCase>(() =>
        GetAllCompletedTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAllRunningTripsUseCase>(() =>
        GetAllRunningTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAllActivityTripsUseCase>(() =>
        GetAllActivityTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CheckRealAmountEnoughUseCase>(() =>
        CheckRealAmountEnoughUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<RequestTripUseCase>(() => RequestTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CancelPendingTripByClientUseCase>(() => CancelPendingTripByClientUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<RetrieveClientLatestTripUseCase>(() => RetrieveClientLatestTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetCostPerKmUseCase>(() =>
        GetCostPerKmUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<RegisterRideNotSpecialUseCase>(() =>
        RegisterRideNotSpecialUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<LoadingRegisterUseCase>(() =>
        LoadingRegisterUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetLoadingInfoUseCase>(() =>
        GetLoadingInfoUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<MakeRequestTripUseCase>(() =>
        MakeRequestTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<RecordingTripUseCase>(() =>
        RecordingTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToRideOffersUseCase>(() =>
        ListenToRideOffersUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<AcceptOfferByClientUseCase>(() =>
        AcceptOfferByClientUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateTripAutoAcceptByClientUseCase>(() =>
        UpdateTripAutoAcceptByClientUseCase(repository: serviceLocator()));


    // ---------------------------------- cubits ----------------------------------

    serviceLocator.registerLazySingleton<RideCubit>(() => RideCubit(
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
          serviceLocator(),
        ));
  }
}
