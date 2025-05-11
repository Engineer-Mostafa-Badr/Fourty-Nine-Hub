import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/trip_states_enum.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/upload_record.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/arrived_to_client_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/support_details_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/arrived_to_client_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/auto_accept_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/driver_rate_client_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/emergency_support_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_running_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/going_to_client_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_accept_offer_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_change_trip_price_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_new_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_remove_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_update_trip_auto_accept_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/start_ride_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/complete_ride_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/recording_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/domain/usecases/create_rider_offer_usecase.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/cancel_trip_by_rider.dart';

import '../../../../../core/error/failure.dart';

import '../../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import '../../../domain/entities/dashboards/trips_response_entity.dart';
import '../../../domain/usecases/dashboards/create_driver_rating_usecase.dart';
import '../../../domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import '../../../domain/usecases/dashboards/get_past_trips_usecase.dart';
import '../../../domain/usecases/dashboards/get_settings_dashboard_usecase.dart';
import '../../../domain/usecases/dashboards/update_driver_rating_usecase.dart';
import '../../../domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:record/record.dart';

part 'dashboards_state.dart';

class DashboardsCubit extends Cubit<DashboardsState> {
  final GetAvailableTripsUsecase getAvailableTripsUsecase;
  final AvailableRideTripsUseCase availableRideTripsUseCase;
  final GetPastTripsUsecase getPastTripsUsecase;
  final GetSettingsDashboardUsecase getSettingsDashboardUsecase;
  final UpdateSettingsDashboardUsecase updateSettingsDashboardUsecase;
  final CreateNewOfferDashboardUsecase createNewOfferDashboardUsecase;
  final CreateNewOfferNonSocketUsecase createNewOfferNonSocketUsecase;
  final CreateDriverRatingUsecase createDriverRatingUsecase;
  final UpdateDriverRatingUsecase updateDriverRatingUsecase;
  final CreateRiderOfferUseCase createRiderOfferUseCase;
  final ListenToUpdateTripAutoAcceptUseCase listenToUpdateTripAutoAcceptUseCase;
  final ListenToUpdateTripPriceUseCase listenToUpdateTripPriceUseCase;
  final ListenToAcceptOfferUseCase listenToAcceptOfferUseCase;
  final ListenToNewTripUseCase listenToNewTripUseCase;
  final ListenToRemoveTripUseCase listenToRemoveTripUseCase;
  final AutoAcceptTripUseCase autoAcceptTripUseCase;
  final GetRunningTripUseCase getRunningTripUseCase;
  final GoingToClientUseCase goingToClientUseCase;
  final ArrivedToClientUseCase arrivedToClientUseCase;
  final StartDriverTripUseCase startDriverTripUseCase;
  final CompleteDriverTripUseCase completeDriverTripUseCase;
  final RecordingTripUseCase recordingTripUseCase;
  final CancelTripByRiderUseCase cancelTripByRiderUseCase;
  final DriverRateClientUseCase driverRateClientUseCase;
  final GetSupportDetailsUseCase getSupportDetailsUseCase;
  final EmergencySupportUseCase emergencySupportUseCase;
  DashboardsCubit(
    this.getAvailableTripsUsecase,
    this.getPastTripsUsecase,
    this.availableRideTripsUseCase,
    this.getSettingsDashboardUsecase,
    this.updateSettingsDashboardUsecase,
    this.createNewOfferDashboardUsecase,
    this.createNewOfferNonSocketUsecase,
    this.createDriverRatingUsecase,
    this.updateDriverRatingUsecase,
    this.createRiderOfferUseCase,
    this.listenToUpdateTripAutoAcceptUseCase,
    this.listenToUpdateTripPriceUseCase,
    this.listenToAcceptOfferUseCase,
    this.listenToNewTripUseCase,
    this.listenToRemoveTripUseCase,
    this.autoAcceptTripUseCase,
    this.getRunningTripUseCase,
    this.goingToClientUseCase,
    this.arrivedToClientUseCase,
    this.startDriverTripUseCase,
    this.completeDriverTripUseCase,
    this.recordingTripUseCase,
    this.cancelTripByRiderUseCase,
    this.driverRateClientUseCase,
    this.getSupportDetailsUseCase,
    this.emergencySupportUseCase,
  ) : super(const DashboardsState());
  List<TripEntity> availableTripsNonSocket = [];

  TextEditingController reasonController = TextEditingController();

  void changeIndex(int index, BuildContext context) {
    emit(state.copyWith(currentIndex: index, status: DashboardsStates.success));
    if (index == 0) loadAvailableRideTrips(context);
    if (index == 1) getActiveTrip(context);
  }

  void listenToNewTrip() {
    CliLogger.info('Listen To New Trip');
    // TripsResponseEntity
    listenToNewTripUseCase((trip) {
      List<AvailableRideTripEntity> list = state.availableRideTrips ?? [];
      list.insert(0, trip);
      emit(state.copyWith(availableRideTrips: list));
      log(trip.toString());
    });
  }

  void listenToRemoveTrip() {
    CliLogger.info('Remove Trip');
    // TripsResponseEntity
    listenToRemoveTripUseCase((tripId) {
      List<AvailableRideTripEntity> list = state.availableRideTrips ?? [];
      log("tripId.toString()${tripId.toString()}");
      if (tripId.isNotEmpty) list.removeWhere((e) => e.id == tripId);
      // log(trip.toString());
      // list.insert(0, trip);
      emit(state.copyWith(availableRideTrips: list));
    });
  }

  void listenToUpdateTripAutoAccept() {
    CliLogger.info('Listen To Update Trip Auto Accept');
    listenToUpdateTripAutoAcceptUseCase((trip) {
      List<AvailableRideTripEntity> list = state.availableRideTrips ?? [];
      list.firstWhere((e) => e.id == trip.id).isAutoAccept = trip.isAutoAccept;
      log(trip.toString());
      emit(state.copyWith(availableRideTrips: list));
    });
  }

  void listenToUpdateTripPrice() {
    CliLogger.info('Listen To Update Trip Price');
    listenToUpdateTripPriceUseCase((trip) {
      CliLogger.info('Listen To Update TripPrice ${trip.price}');
      CliLogger.info('Listen To Update TripId ${trip.tripId}');

      List<AvailableRideTripEntity> list = state.availableRideTrips ?? [];
      list.firstWhere((e) => e.id == trip.tripId).price = trip.price;
      log(trip.toString());
      emit(state.copyWith(availableRideTrips: list));
    });
  }

  void listenToAcceptOffer(BuildContext context) {
    CliLogger.info('Listen To Update Trip Auto Accept');
    listenToAcceptOfferUseCase((trip) {
      changeIndex(1, context);
      // List<AvailableRideTripEntity> list = state.availableRideTrips ?? [];
      // list.firstWhere((e)=>e.id==trip.id).isAutoAccept = trip.isAutoAccept;
      // log(trip.toString());
      // emit(state.copyWith(availableRideTrips: list));
    });
  }

  Future<void> getAvailableTrips(BuildContext context) async {
    if (!hasMoreData || isLoadingMore) return;
    emit(state.copyWith(status: DashboardsStates.loadingAvailable));
    isLoadingMore = true;
    final Either<Failure, TripsResponseEntity> result = await getAvailableTripsUsecase(AvailableRideTripsUseCaseParams(page: currentPage, limit: pageSize));
    result.fold(
      (failure) {
        showErrorMessage(context, getFailureMessage(failure, context));
        isLoadingMore = false;
        log("objectavailableRideTripsEEEE");
        log("Failure");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (availableTrips) {
        log("Suzccess");
        List<TripEntity> availableRideTrips = [];
        availableRideTrips.addAll(state.availableTrips ?? []);
        availableRideTrips.addAll(availableTrips.data.trips);
        if (availableTrips.data.trips.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }
        isLoadingMore = false;
        availableTripsNonSocket = availableRideTrips;
        emit(state.copyWith(status: DashboardsStates.success, availableTrips: availableRideTrips));
        // emit(state.copyWith(status: DashboardsStates.success, availableTrips: availableTrips.data.trips));
      },
    );
  }

  void loadAvailableRideTrips(BuildContext context) async {
    print("loadAvailableRideTrips1");
    emit(state.copyWith(availableRideTrips: []));
    currentPage = 1;
    hasMoreData = true;
    await getAvailableRideTrips(context);
    print("loadAvailableRideTrips2");
  }

  // List<AvailableRideTripEntity> availableRideTrips = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  Future<void> getAvailableRideTrips(BuildContext context) async {
    if (!hasMoreData || isLoadingMore) return;
    emit(state.copyWith(status: DashboardsStates.loading));
    isLoadingMore = true;
    final response = await availableRideTripsUseCase(
      AvailableRideTripsUseCaseParams(page: currentPage, limit: pageSize),
    );
    response.fold(
      (failure) {
        showErrorMessage(context, getFailureMessage(failure, context));
        isLoadingMore = false;
        print("objectavailableRideTripsEEEE");
        print("Failure");

        emit(state.copyWith(failure: failure, status: DashboardsStates.error));
      },
      (data) {
        print("objectavailableRideTrips");
        List<AvailableRideTripEntity> availableRideTrips = [];
        availableRideTrips.addAll(state.availableRideTrips ?? []);
        availableRideTrips.addAll(data);
        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }
        isLoadingMore = false;
        emit(state.copyWith(status: DashboardsStates.success, availableRideTrips: availableRideTrips));
      },
    );
  }

  Future<void> getPastTrips(BuildContext context, String type) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, TripsResponseEntity> result = await getPastTripsUsecase(type);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (pastTrips) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.success, pastTrips: pastTrips.data.trips));
      },
    );
  }

  Future<void> getActiveTrip(BuildContext context) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, RunningTripEntity> result = await getRunningTripUseCase(const NoParams());

    if (isClosed) return;
    result.fold(
      (failure) {
        context.pop();
        log("Failure ${getFailureMessage(failure, context)}");
        showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(status: DashboardsStates.error, failure: failure, tripStatus: TripState.pending.name));
      },
      (activeTrip) {
        log("Suzccess");
        context.pop();
        emit(state.copyWith(status: DashboardsStates.success, activeTrip: activeTrip, tripStatus: activeTrip.status));
      },
    );
  }

  Future<void> goingToClient(BuildContext context, String id) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result = await goingToClientUseCase(id);

    if (isClosed) return;
    result.fold(
      (failure) {
        context.pop();
        log("Failure ${getFailureMessage(failure, context)}");
        showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (activeTrip) {
        log("Suzccess");
        context.pop();
        emit(state.copyWith(status: DashboardsStates.success, tripStatus: TripState.goToClient.name));
      },
    );
  }

  Future<void> arrivedToClient(BuildContext context, String id, String message) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result = await arrivedToClientUseCase(ArrivedToClientEntity(tripId: id, message: message));

    if (isClosed) return;
    result.fold(
      (failure) {
        context.pop();
        log("Failure ${getFailureMessage(failure, context)}");
        showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (activeTrip) {
        log("Suzccess");
        context.pop();
        emit(state.copyWith(status: DashboardsStates.success, tripStatus: TripState.inLocation.name));
      },
    );
  }

  Future<void> startDriverTrip(BuildContext context, String id, String otp) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result = await startDriverTripUseCase(StartDriverTripParams(tripId: id, otp: otp));

    if (isClosed) return;
    result.fold(
      (failure) {
        context.pop();
        log("Failure ${getFailureMessage(failure, context)}");
        showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (activeTrip) {
        log("Suzccess");
        context.pop();
        emit(state.copyWith(status: DashboardsStates.success, tripStatus: TripState.started.name));
      },
    );
  }

  Future<void> completeDriverTrip(BuildContext context, String id, String otp) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result = await completeDriverTripUseCase(StartDriverTripParams(tripId: id, otp: otp));

    if (isClosed) return;
    result.fold(
      (failure) {
        context.pop();
        log("Failure ${getFailureMessage(failure, context)}");
        showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (activeTrip) {
        log("Suzccess");
        context.pop();
        emit(state.copyWith(status: DashboardsStates.success, tripStatus: TripState.started.name));
      },
    );
  }

  Future<void> cancelDriverTrip({required BuildContext context, required String tripId, required String note, required String reasonId}) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result = await cancelTripByRiderUseCase(CancelTripByRiderUseCaseParams(tripId: tripId, note: note, reasonId: reasonId));

    if (isClosed) return;
    result.fold(
      (failure) {
        context.pop();
        log("Failure ${getFailureMessage(failure, context)}");
        showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (activeTrip) {
        log("Suzccess");
        context.pop();
        emit(state.copyWith(status: DashboardsStates.success, tripStatus: TripState.started.name));
      },
    );
  }

  Future<void> rateTheClient({required BuildContext context, required String tripId, required String comment, required double rate}) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result = await driverRateClientUseCase(DriverRateClientParams(tripId: tripId, comment: comment, rate: rate));

    if (isClosed) return;
    result.fold(
      (failure) {
        context.pop();
        log("Failure ${getFailureMessage(failure, context)}");
        showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (activeTrip) {
        log("Suzccess");
        context.pop();
        emit(state.copyWith(status: DashboardsStates.success, tripStatus: TripState.started.name));
      },
    );
  }

  Future<void> getSettings(BuildContext context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingSettings));

    final Either<Failure, SettingsDashboardEntityResponse> result = await getSettingsDashboardUsecase(const NoParams());

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.success, settings: settings.data));
      },
    );
  }

  Future<void> updateSettings(BuildContext context, UpdateSettingsDashboardUsecaseParam param) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingSettings));

    final Either<Failure, bool> result = await updateSettingsDashboardUsecase(param);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        log("Suzccess");
        // emit(state.copyWith(status: DashboardsStates.success));
        // if (settings) {
        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('Updated Successful.'),
        //   ));
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text('Some thing went error!'),
        //   ));
        // }
        getSettings(context);
      },
    );
  }

  Future<void> createNewOffer(BuildContext context, CreateNewOfferDashboardUsecaseParam param) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingCreateOffer));

    final Either<Failure, bool> result = await createNewOfferDashboardUsecase(param);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.successOffer));
      },
    );
  }

  Future<void> autoAcceptTrip(BuildContext context, String id) async {
    emit(state.copyWith(status: DashboardsStates.loadingAcceptTrip));
    final Either<Failure, bool> result = await autoAcceptTripUseCase(id);
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (data) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.successAcceptTrip));
      },
    );
  }

  Future<void> createNewOfferNonSocket(BuildContext context, CreateNewOfferDashboardUsecaseParam param, String subCategoryId) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingCreateOffer));

    final Either<Failure, bool> result = await createNewOfferNonSocketUsecase(param);

    if (isClosed) return;
    result.fold(
      (failure) {
        String errorName = getFailureName(failure, context);
        errorName == 'DebtError'
            ? showDebtDialog(context, subCategoryId)
            : errorName == 'SubscribeError'
                ? showSubscribeDialog(context, subCategoryId)
                : showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(status: DashboardsStates.errorOffers, failure: failure));
      },
      (settings) {
        log("Suzccess");
        showSuccessMessage(context, 'Offer Created Successfully');
        emit(state.copyWith(status: DashboardsStates.successOffer));
      },
    );
  }

  Future<void> createOffer({required String tripId, required num price, required BuildContext context, required String subCategoryId}) async {
    emit(state.copyWith(status: DashboardsStates.loadingAcceptOffer));
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final response = await createRiderOfferUseCase(CreateRiderOfferParams(tripId: tripId, price: price, lat: currentPosition.latitude, lng: currentPosition.longitude));
    response.fold((l) {
      String errorName = getFailureName(l, context);
      errorName == 'DebtError'
          ? showDebtDialog(context, subCategoryId)
          : errorName == 'SubscribeError'
              ? showSubscribeDialog(context, subCategoryId)
              : showErrorMessage(context, getFailureMessage(l, context));
      emit(state.copyWith(failure: l, status: DashboardsStates.error));
    }, (data) {
      emit(state.copyWith(status: DashboardsStates.success));
    });
  }

  Future<void> createDriverRating(BuildContext context, CreateUpdateDriverRatingUsecaseParam param) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingRating));

    final Either<Failure, bool> result = await createDriverRatingUsecase(param);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.successRating));
      },
    );
  }

  Future<void> updateDriverRating(BuildContext context, CreateUpdateDriverRatingUsecaseParam param) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingRating));

    final Either<Failure, bool> result = await updateDriverRatingUsecase(param);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.successRating));
      },
    );
  }

  Future<void> refuseTrip(BuildContext context, String id) async {
    emit(state.copyWith(status: DashboardsStates.loadingAvailable));
    availableTripsNonSocket.removeWhere((element) => element.tripDetails!.id == id);
    emit(state.copyWith(status: DashboardsStates.successOffer, availableTrips: availableTripsNonSocket));
  }

  showSubscribeDialog(BuildContext context, String subCategoryId) {
    showCustomDialogTrip(
        context,
        Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.alert.localize,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Please Subscribe for more trips',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.s16,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: 'Close',
                    backColor: AppColors.SECONDARY_COLOR_DARK2,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                const SizedBox(width: 16),
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: 'Subscribe',
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      Navigator.of(context).pop();
                      SubscriptionMethod().subscribe(subscribeId: subCategoryId, showRegular: true, title: '');
                    }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  showDebtDialog(BuildContext context, String subCategoryId) {
    showCustomDialogTrip(
        context,
        Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.alert.localize,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Please pay the Debt for more trips',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.s16,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: 'Close',
                    backColor: AppColors.SECONDARY_COLOR_DARK2,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                const SizedBox(width: 16),
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: 'Pay',
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      Navigator.of(context).pop();
                      serviceLocator<SubscriptionController>().showActiveSubscriptionAmounts(walletType: WalletTypes.mainWallet, price: 50);
                    }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  uploadRecord(BuildContext context, String tripId, String mediaId) async {
    final Either<Failure, bool> result = await recordingTripUseCase(RecordingTripUseCaseParams(tripId, mediaId));

    result.fold(
      (failure) {
        context.pop();
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (data) async {
        context.pop();
        emit(state.copyWith(status: DashboardsStates.success));
      },
    );
  }

  bool _isRequestingPermission = false;

  Future<bool> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // You can show a dialog here asking user to enable location
      return false;
    }

    // Step 2: Request permission
    LocationPermission permission = await Geolocator.requestPermission();

    // Step 3: Check if permission is whileInUse
    if (permission == LocationPermission.whileInUse) {
      return true;
    }

    // Optional: Handle permanently denied
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }

    return false;
  }

  getEmergencyDetails(BuildContext context, GetSupportDetailsParams params) async {
    // showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loading));
    final Either<Failure, SupportDetailsEntity> result = await getSupportDetailsUseCase(params);

    result.fold(
      (failure) {
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (data) async {
        emit(state.copyWith(status: DashboardsStates.success));
      },
    );
  }

  TextEditingController supportDescriptionController = TextEditingController();
  TextEditingController supportPhoneController = TextEditingController();
  requestEmergencySupport(
    BuildContext context,
    String driverId,
    String tripId,
    String clientId,
  ) async {
    bool hasPermission = await _checkPermissions();
    print("hasPermission $hasPermission");
    Position? currentPosition;
    if (hasPermission) {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("currentPosition.latitude ${currentPosition.latitude}");
      print("currentPosition.latitude ${currentPosition.longitude}");
    }
    emit(state.copyWith(status: DashboardsStates.loadingSubmitRequest));
    final Either<Failure, bool> result = await emergencySupportUseCase(EmergencySupportParams(
        driverId: driverId,
        description: supportDescriptionController.text,
        phone: supportPhoneController.text,
        type: 'driver',
        clientId: clientId,
        latitude: currentPosition?.latitude ?? 0,
        tripId: tripId,
        longitude: currentPosition?.longitude ?? 0));

    result.fold(
          (failure) {
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
          (data) async {
        emit(state.copyWith(status: DashboardsStates.success));
      },
    );
  }

  ///record trip
  Record record = Record();

  // Start recording
  Future<void> startRecord() async {
    log('startRecorddd${await record.hasPermission()}');
    try {
      if (await record.hasPermission()) {
        log('record.hasPermission');
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';
        await record.start(
          path: tempPath,
        );
        print("object");
      } else {
        throw Exception('Microphone permission not granted');
      }
    } catch (e) {
      log('Error starting record: $e');
    }
  }

  Future<String?> stopRecord({required BuildContext context, required String subcategoryId, required String tripId}) async {
    try {
      showLoadingDialog(context);
      log('stopRecord');
      String? path = await record.stop();
      await UploadRecord().mediaUrl(
        tripId: tripId,
        path: path ?? "",
        subcategoryId: subcategoryId,
        onSuccess: (String mediaId, String tripId) async {
          log("tripId$tripId");
          log("mediaId$mediaId");
          await uploadRecord(context, tripId, mediaId);
        },
      );
      // await recordingTripUseCase(RecordingTripUseCaseParams( tripId,  'mediaId'));
      return path;
    } catch (e) {
      log('Error stopping record: $e');
      return null;
    }
  }

  changeReasonSelection({bool? isOther, bool? isChangedMind, bool? isClientNotShown}) {
    if (isOther == true) {
      emit(state.copyWith(isOtherReason: true, isChangedMindReason: false, isClientNotShownReason: false, status: DashboardsStates.success));
    }
    if (isChangedMind == true) {
      emit(state.copyWith(isOtherReason: false, isChangedMindReason: true, isClientNotShownReason: false, status: DashboardsStates.success));
    }
    if (isClientNotShown == true) {
      emit(state.copyWith(isOtherReason: false, isChangedMindReason: false, isClientNotShownReason: true, status: DashboardsStates.success));
    }
  }
}
