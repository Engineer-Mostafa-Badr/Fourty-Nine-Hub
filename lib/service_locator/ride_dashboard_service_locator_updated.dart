

import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_remove_offer_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/loading/listen_to_accept_loading_trip_offer_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/loading/listen_to_remove_accepted_loading_trip_offer_use_case.dart';

import '../features/RideFeature/domain/usecases/dashboards/arrived_to_client_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/auto_accept_trip_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/delete_emergency_contact_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/complete_ride_trip_with_price_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/driver_rate_client_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/emergency_support_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/finalize_trip_by_rider.dart.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_emergency_contacts_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_running_trip_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/going_to_client_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/listen_to_accept_offer_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/listen_to_change_trip_price_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/listen_to_client_coming_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/listen_to_end_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/listen_to_new_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/listen_to_partial_payment_driver_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/listen_to_remove_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/listen_to_update_trip_auto_accept_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/start_ride_trip_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/complete_ride_trip_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/watching_trips_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/update_driver_rate_client_usecase.dart';
import 'package:get_it/get_it.dart';

import '../features/RideFeature/data/datasources/dashboard_remote_data_source.dart';
import '../features/RideFeature/data/repositories/trip_repository_impl.dart';
import '../features/RideFeature/domain/repositories/trip_repository.dart';
import '../features/RideFeature/domain/usecases/dashboards/add_rate_with_driver_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/create_driver_rating_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/create_non_track_offer_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_accepted_ride_non_socket_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_available_ride_non_socket_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_available_trips_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_driver_settings_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_past_ride_non_socket_trips_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_past_trips_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/get_settings_dashboard_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/listen_to_accept_untracked_trip_offer_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/listen_to_available_untracked_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/listen_to_remove_untracked_trip_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/loading/create_offer_loading_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/loading/create_rate_with_driver_loading_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/loading/get_accepted_ride_non_socket_loading_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/loading/get_available_ride_non_socket_loading_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/loading/get_driver_setting_loading_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/loading/get_history_ride_non_socket_loading_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/loading/listen_to_available_loading_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/loading/listen_to_remove_loading_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/loading/update_driver_loading_rating_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/loading/update_driver_loading_settings_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/update_driver_rate_non_socket_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/update_driver_rating_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/update_driver_settings_use_case.dart';
import '../features/RideFeature/domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import '../features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import '../features/RideFeature/domain/usecases/cancel_trip_by_rider.dart';
import '../features/RideFeature/domain/usecases/dashboards/add_emergency_contacts_usecase.dart';
import '../features/RideFeature/domain/usecases/dashboards/edit_emergency_contacts_usecase.dart';

class RideDashboardServiceLocatorUpdated {
  static void execute({required GetIt serviceLocator}) {
    // ---------------------------------- data sources ----------------------------------
    serviceLocator.registerLazySingleton<TripRemoteDataSource>(() => TripRemoteDataSourceImplementation(
          serviceLocator(),
        ));

    // ---------------------------------- repositories ----------------------------------
    serviceLocator.registerLazySingleton<TripRepository>(() => TripRepositoryImpl(serviceLocator()));


    // ---------------------------------- use cases ----------------------------------
    serviceLocator.registerLazySingleton<GetAvailableTripsUsecase>(() => GetAvailableTripsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetPastTripsUsecase>(() => GetPastTripsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<AvailableRideTripsUseCase>(() => AvailableRideTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetSettingsDashboardUsecase>(() => GetSettingsDashboardUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateSettingsDashboardUsecase>(() => UpdateSettingsDashboardUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateNewOfferDashboardUsecase>(() => CreateNewOfferDashboardUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateNewOfferNonSocketUsecase>(() => CreateNewOfferNonSocketUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateDriverRatingUsecase>(() => CreateDriverRatingUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateDriverRatingUsecase>(() => UpdateDriverRatingUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToUpdateTripAutoAcceptUseCase>(() => ListenToUpdateTripAutoAcceptUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToUpdateTripPriceUseCase>(() => ListenToUpdateTripPriceUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToAcceptOfferUseCase>(() => ListenToAcceptOfferUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToNewTripUseCase>(() => ListenToNewTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToRemoveTripUseCase>(() => ListenToRemoveTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<AutoAcceptTripUseCase>(() => AutoAcceptTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAvailableNonSocketTripsUseCase>(() => GetAvailableNonSocketTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAcceptedNonSocketTripsUseCase>(() => GetAcceptedNonSocketTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetPastNonSocketTripsUseCase>(() => GetPastNonSocketTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetRunningTripUseCase>(() => GetRunningTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GoingToClientUseCase>(() => GoingToClientUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ArrivedToClientUseCase>(() => ArrivedToClientUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<StartDriverTripUseCase>(() => StartDriverTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CompleteDriverTripUseCase>(() => CompleteDriverTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CancelTripByRiderUseCase>(() => CancelTripByRiderUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<DriverRateClientUseCase>(() => DriverRateClientUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetSupportDetailsUseCase>(() => GetSupportDetailsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<EmergencySupportUseCase>(() => EmergencySupportUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetEmergencyContactsUseCase>(() => GetEmergencyContactsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<EditEmergencyContactsUseCase>(() => EditEmergencyContactsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<AddEmergencyContactsUseCase>(() => AddEmergencyContactsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<WatchingTripsUseCase>(() => WatchingTripsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateNonTrackOfferUseCase>(() => CreateNonTrackOfferUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateDriverSettingsUseCase>(() => UpdateDriverSettingsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDriverSettingsUseCase>(() => GetDriverSettingsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToRemoveUntrackedTripUseCase>(() => ListenToRemoveUntrackedTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<DeleteEmergencyContactUseCase>(() => DeleteEmergencyContactUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<FinalizeTripByRiderUseCase>(() => FinalizeTripByRiderUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToAvailableUntrackedTripUseCase>(() => ListenToAvailableUntrackedTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToAcceptUntrackedTripOfferUseCase>(() => ListenToAcceptUntrackedTripOfferUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToEndTripUseCase>(() => ListenToEndTripUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<AddRateWithDriverUseCase>(() => AddRateWithDriverUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateDriverRateClientUseCase>(() => UpdateDriverRateClientUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CompleteRideTripWithPriceUseCase>(() => CompleteRideTripWithPriceUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAcceptedNonSocketLoadingUseCase>(() => GetAcceptedNonSocketLoadingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateOfferLoadingUseCase>(() => CreateOfferLoadingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAvailableNonSocketLoadingUseCase>(() => GetAvailableNonSocketLoadingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetHistoryNonSocketLoadingUseCase>(() => GetHistoryNonSocketLoadingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateDriverRateNonSocketUseCase>(() => UpdateDriverRateNonSocketUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDriverLoadingSettingsUseCase>(() => GetDriverLoadingSettingsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateDriverSettingsLoadingUseCase>(() => UpdateDriverSettingsLoadingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToRemoveLoadingUseCase>(() => ListenToRemoveLoadingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToAvailableLoadingUseCase>(() => ListenToAvailableLoadingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToPartialPaymentDriverUseCase>(() => ListenToPartialPaymentDriverUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateDriverRateLoadingNonSocketUseCase>(() => UpdateDriverRateLoadingNonSocketUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<AddRateWithDriverLoadingUseCase>(() => AddRateWithDriverLoadingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToAcceptLoadingTripOfferUseCase>(() => ListenToAcceptLoadingTripOfferUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToRemoveAcceptedLoadingTripOfferUseCase>(() => ListenToRemoveAcceptedLoadingTripOfferUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToClientComingTrackingUseCase>(() => ListenToClientComingTrackingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<ListenToRemoveOfferUseCase>(() => ListenToRemoveOfferUseCase(serviceLocator()));

    // ---------------------------------- cubits ----------------------------------

    serviceLocator.registerFactory<DashboardsCubit>(() => DashboardsCubit(
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
