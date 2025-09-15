import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_driver_ratings_usecase.dart';

import '../features/RideFeature/data/repositories/ride_repository_imp.dart';
import '../features/RideFeature/domain/repositories/ride_repository.dart';
import '../features/RideFeature/domain/usecases/accept_offer_by_client_use_case.dart';
import '../features/RideFeature/domain/usecases/add_car_brand_usecase.dart';
import '../features/RideFeature/domain/usecases/add_car_model_usecase.dart';
import '../features/RideFeature/domain/usecases/accept_shipping_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/cancel_pending_trip_by_client_use_case.dart';
import '../features/RideFeature/domain/usecases/cancel_trip_by_client.dart';
import '../features/RideFeature/domain/usecases/cancel_shipping_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/check_real_amount_enough_usecase.dart';
import '../features/RideFeature/domain/usecases/click_global_use_case.dart';
import '../features/RideFeature/domain/usecases/client_trips/listen_to_offer_update_client_shipping_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/get_all_activity_trips.dart';
import '../features/RideFeature/domain/usecases/get_all_completed_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/get_all_history_trips_usecase.dart';
import '../features/RideFeature/domain/usecases/get_all_running_trips_usecase.dart';
import '../features/RideFeature/domain/usecases/get_client_accepted_shipping_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/get_client_offer_shipping_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/get_client_past_shipping_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/get_client_pending_shipping_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/get_cost_per_km_use_case.dart';
import '../features/RideFeature/domain/usecases/get_loading_info_usecase.dart';
import '../features/RideFeature/domain/usecases/get_location_from_address_use_case.dart';
import '../features/RideFeature/domain/usecases/get_ride_expexted_price_usecase.dart';
import '../features/RideFeature/domain/usecases/get_ride_governorates.dart';
import '../features/RideFeature/domain/usecases/get_driver_picture_optional.dart';
import '../features/RideFeature/domain/usecases/get_ride_brands_usecase.dart';
import '../features/RideFeature/domain/usecases/get_ride_car_colors_usecase.dart';
import '../features/RideFeature/domain/usecases/get_ride_driver_information.dart';
import '../features/RideFeature/domain/usecases/get_ride_models_usecase.dart';
import '../features/RideFeature/domain/usecases/get_ride_non_tracking_models_usecase.dart';
import '../features/RideFeature/domain/usecases/get_ride_shipping_models_usecase.dart';
import '../features/RideFeature/domain/usecases/get_shipping_categories_usecase.dart';
import '../features/RideFeature/domain/usecases/listen_to_ride_offers_use_case.dart';
import '../features/RideFeature/domain/usecases/loading_register_usecase.dart';
import '../features/RideFeature/domain/usecases/make_request_trip_usecase.dart';
import '../features/RideFeature/domain/usecases/recording_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/refuse_shipping_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/register_ride_not_special_usecase.dart';
import '../features/RideFeature/domain/usecases/register_ride_special_usecase.dart';
import '../features/RideFeature/domain/usecases/request_trip_usecase.dart';
import '../features/RideFeature/domain/usecases/retrieve_client_latest_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/update_trip_auto_accept_by_client_use_case.dart';
import '../features/RideFeature/domain/usecases/update_socket_location_usecase.dart';
import '../features/RideFeature/domain/usecases/update_trip_price_use_case.dart';
import '../features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import '../features/RideFeature/presentation/controllers/ride_register/ride_register_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/RideFeature/data/datasources/ride_local_data_source.dart';
import '../features/RideFeature/data/datasources/ride_remote_data_source.dart';
import '../features/RideFeature/data/datasources/shipping_remote_data_source.dart';
import '../features/RideFeature/data/repositories/shipping_repository_imp.dart';
import '../features/RideFeature/domain/repositories/shipping_repository.dart';
import '../features/RideFeature/domain/usecases/accept_non_track_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/cancel_non_track_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/client_trips/add_rate_with_client_use_case.dart';
import '../features/RideFeature/domain/usecases/client_trips/get_client_all_rating_use_case.dart';
import '../features/RideFeature/domain/usecases/client_trips/get_driver_all_rating_use_case.dart';
import '../features/RideFeature/domain/usecases/client_trips/listen_to_offer_update_client_untracked_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/client_trips/update_client_rate_non_socket_use_case.dart';
import '../features/RideFeature/domain/usecases/create_loading_trip_usecase.dart';
import '../features/RideFeature/domain/usecases/create_non_track_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/get_available_map_country_usecase.dart';
import '../features/RideFeature/domain/usecases/get_client_accepted_untracked_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/get_client_offer_untracked_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/get_client_offers_usecase.dart';
import '../features/RideFeature/domain/usecases/get_client_past_untracked_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/get_client_pending_untracked_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/get_loading_offers_usecase.dart';
import '../features/RideFeature/domain/usecases/get_ride_categories_usecase.dart';
import '../features/RideFeature/domain/usecases/make_loading_request_trip_usecase.dart';
import '../features/RideFeature/domain/usecases/make_non_tracking_request_trip_usecase.dart';
import '../features/RideFeature/domain/usecases/partial_payment_in_trip.dart';
import '../features/RideFeature/domain/usecases/rating_driver_by_client.dart';
import '../features/RideFeature/domain/usecases/refuse_non_track_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/send_ok_iam_coming_message_usecase.dart';
import '../features/RideFeature/presentation/controllers/client_trips_cubit/client_trips_cubit.dart';

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
    serviceLocator.registerLazySingleton<GetAllHistoryTripsUseCase>(() =>
        GetAllHistoryTripsUseCase(serviceLocator()));
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
    serviceLocator.registerLazySingleton<MakeNonTrackingRequestTripUsecase>(() =>
        MakeNonTrackingRequestTripUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateSocketLocationUseCase>(() =>
        UpdateSocketLocationUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetClientOffersUsecase>(() =>
        GetClientOffersUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToRideOffersUseCase>(() =>
        ListenToRideOffersUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<AcceptOfferByClientUseCase>(() =>
        AcceptOfferByClientUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateTripAutoAcceptByClientUseCase>(() =>
        UpdateTripAutoAcceptByClientUseCase(repository: serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateTripPriceUseCase>(() =>
        UpdateTripPriceUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ClickUseCase>(() =>
        ClickUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<MakeLoadingRequestTripUsecase>(() =>
        MakeLoadingRequestTripUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetLoadingOffersUsecase>(() =>
        GetLoadingOffersUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateNonTrackTripUseCase>(() =>
        CreateNonTrackTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetClientPendingUntrackedTripsUseCase>(() =>
        GetClientPendingUntrackedTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CancelNonTrackTripUseCase>(() =>
        CancelNonTrackTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetClientAcceptedUntrackedTripsUseCase>(() =>
        GetClientAcceptedUntrackedTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetClientOfferUntrackedTripsUseCase>(() =>
        GetClientOfferUntrackedTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<AcceptNonTrackTripUseCase>(() =>
        AcceptNonTrackTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<RefuseNonTrackTripUseCase>(() =>
        RefuseNonTrackTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetClientPastUntrackedTripsUseCase>(() =>
        GetClientPastUntrackedTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<SendOkIamComingMessageUseCase>(() =>
        SendOkIamComingMessageUseCase(repository: serviceLocator()));

    serviceLocator.registerLazySingleton<RatingDriverByClientUseCase>(() =>
        RatingDriverByClientUseCase(repository: serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToOfferUpdateUntrackedTripUseCase>(() =>
        ListenToOfferUpdateUntrackedTripUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<AddCarModelUseCase>(() =>
        AddCarModelUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<AddCarBrandUseCase>(() =>
        AddCarBrandUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideNonTrackingModelsUseCase>(() =>
        GetRideNonTrackingModelsUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<GetRideShippingModelsUseCase>(() =>
        GetRideShippingModelsUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<GetClientPendingShippingTripsUseCase>(() =>
        GetClientPendingShippingTripsUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<CancelShippingTripUseCase>(() =>
        CancelShippingTripUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<GetClientAcceptedShippingTripsUseCase>(() =>
        GetClientAcceptedShippingTripsUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<GetClientOfferShippingTripsUseCase>(() =>
        GetClientOfferShippingTripsUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToOfferUpdateShippingTripUseCase>(() =>
        ListenToOfferUpdateShippingTripUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<RefuseShippingTripUseCase>(() =>
        RefuseShippingTripUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<AcceptShippingTripUseCase>(() =>
        AcceptShippingTripUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<GetClientPastShippingTripsUseCase>(() =>
        GetClientPastShippingTripsUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<AddRateWithClientUseCase>(() =>
        AddRateWithClientUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateClientRateNonSocketUseCase>(() =>
        UpdateClientRateNonSocketUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<GetDriverAllRatingUseCase>(() =>
        GetDriverAllRatingUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<GetClientAllRatingUseCase>(() =>
        GetClientAllRatingUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<CancelTripByClientUseCase>(() =>
        CancelTripByClientUseCase ( serviceLocator()));
    serviceLocator.registerLazySingleton<GetAvailableMapCountryUseCase>(() =>
        GetAvailableMapCountryUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<PartialPaymentInTripUseCase>(() =>
        PartialPaymentInTripUseCase( serviceLocator()));
    serviceLocator.registerLazySingleton<GetDriverRatingsUseCase>(() =>
        GetDriverRatingsUseCase( serviceLocator()));
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
    // serviceLocator.registerLazySingleton<CheckTripEndCubit>(() => CheckTripEndCubit(
    //       serviceLocator(),
    //     ));
    serviceLocator.registerFactory<RideRegisterCubit>(() => RideRegisterCubit(
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
    serviceLocator.registerFactory<ClientTripsCubit>(() => ClientTripsCubit(
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
          serviceLocator(),
        ));
  }
}
