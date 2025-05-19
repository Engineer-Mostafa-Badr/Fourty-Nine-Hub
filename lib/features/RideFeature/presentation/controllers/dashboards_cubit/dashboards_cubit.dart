import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/auto_accept_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_accept_offer_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_change_trip_price_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_new_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_remove_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_update_trip_auto_accept_case.dart';
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
import 'package:path/path.dart';

import '../../../../../common/functions/global/upload_image.dart';
import '../../../../../core/error/failure.dart';

import '../../../../../core/utils/ride_method_helper.dart';
import '../../../domain/entities/dashboards/create_non_track_offer_entity.dart';
import '../../../domain/entities/dashboards/driver_settings_entity.dart';
import '../../../domain/entities/dashboards/get_accepted_ride_non_socket_trip_entity.dart';
import '../../../domain/entities/dashboards/get_available_ride_non_socket_trip_entity.dart';
import '../../../domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import '../../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import '../../../domain/entities/dashboards/trips_response_entity.dart';
import '../../../domain/entities/dashboards/update_driver_settings_entity.dart';
import '../../../domain/usecases/dashboards/create_driver_rating_usecase.dart';
import '../../../domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import '../../../domain/usecases/dashboards/create_non_track_offer_use_case.dart';
import '../../../domain/usecases/dashboards/get_accepted_ride_non_socket_trips_use_case.dart';
import '../../../domain/usecases/dashboards/get_available_ride_non_socket_trips_use_case.dart';
import '../../../domain/usecases/dashboards/get_driver_settings_usecase.dart';
import '../../../domain/usecases/dashboards/get_past_ride_non_socket_trips_use_case.dart';
import '../../../domain/usecases/dashboards/get_past_trips_usecase.dart';
import '../../../domain/usecases/dashboards/get_settings_dashboard_usecase.dart';
import '../../../domain/usecases/dashboards/listen_to_remove_untracked_trip_use_case.dart';
import '../../../domain/usecases/dashboards/update_driver_rating_usecase.dart';
import '../../../domain/usecases/dashboards/update_driver_settings_use_case.dart';
import '../../../domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import '../../../domain/usecases/get_client_pending_untracked_trips_use_case.dart';
import '../../pages/Register/Driver/upload_rider_images.dart';
import '../../pages/dashboards/ride_mode_screen.dart';

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
  final GetAvailableNonSocketTripsUseCase getAvailableNonSocketTripsUseCase;
  final GetAcceptedNonSocketTripsUseCase getAcceptedNonSocketTripsUseCase;
  final GetPastNonSocketTripsUseCase getPastNonSocketTripsUseCase;
  final CreateNonTrackOfferUseCase createNonTrackTripUseCase;
  final UpdateDriverSettingsUseCase updateDriverSettingsUseCase;
  final GetDriverSettingsUseCase getDriverSettingsUseCase;
  final ListenToRemoveUntrackedTripUseCase listenToRemoveUntrackedTripUseCase;
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
      this.autoAcceptTripUseCase, this.getAvailableNonSocketTripsUseCase, this.getAcceptedNonSocketTripsUseCase, this.getPastNonSocketTripsUseCase, this.createNonTrackTripUseCase, this.updateDriverSettingsUseCase, this.getDriverSettingsUseCase, this.listenToRemoveUntrackedTripUseCase,
  ) : super(const DashboardsState());



  TextEditingController rideDriverExpireDateController = TextEditingController();


  onSubmitUploadingDriverLicense(BuildContext context) async {

    if (driverLicenseFormKey.currentState!.validate()) {
      if (state.driverLicensePicture == null) {
        showErrorMessage(context, "Please select driver license picture");
        return;
      }
      if (state.backOfDriverLicensePicture == null) {
        showErrorMessage(context, "Please select back of driver license picture");
        return;
      }
      if (state.selfieDriverLicensePicture == null ) {
        showErrorMessage(context, "Please select selfie driver license picture");
        return;
      }
      showLoadingDialog(context, canPop: false);
     await RideMethodHelper().uploadDriverLicense(
          drivingImageInFront: state.driverLicensePicture!,
         drivingImageBehind: state.backOfDriverLicensePicture!,
         drivingExpiryDate: rideDriverExpireDateController.text, onSuccessUploaded: (bool isSuccess) async{
        if (isSuccess) {

          emit(state.copyWith(status: DashboardsStates.success));
        } else {
          showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
        }
      });
      emit(state.copyWith(status: DashboardsStates.success));

        await RideMethodHelper().confirmIdentity(verifyUserImage: state.selfieDriverLicensePicture!, onSuccessUploaded: (bool isSuccess) async{
          if (isSuccess) {
            showSuccessMessage(
                context,
                context.isArabic
                    ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                    : "Successfully uploaded images, please wait for the approval of all data.");
            context.pop();
            context.pop();
            emit(state.copyWith(status: DashboardsStates.success));
          } else {
            context.pop();
            showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
          }
        });

      emit(state.copyWith(status: DashboardsStates.success));
    }
  }


  onUploadDriverLicensePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(driverLicensePicture: file));
        });
  }

  onUploadBackOfDriverLicensePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(backOfDriverLicensePicture: file));
        });
  }

  onUploadSelfieDriverLicensePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(selfieDriverLicensePicture: file));
        });
  }














  final formKey = GlobalKey<FormState>();
  final idFormKey = GlobalKey<FormState>();
  final driverLicenseFormKey = GlobalKey<FormState>();

  TextEditingController ridePersonalDocExpireDateController = TextEditingController();

  onSubmitUploadingId(BuildContext context,) async {
    emit(state.copyWith(status: DashboardsStates.loading));
    // DriverInfoEntity? driverInfo = state.driverInfo;
    // LoadingInfoEntity? loaderInfo = state.loaderInfo;
    if (idFormKey.currentState!.validate()) {
      if (state.personalFrontIdPicture == null) {
        showErrorMessage(context, "Please select front id picture");
        return;
      }
      if (state.personalBackIdPicture == null) {
        showErrorMessage(context, "Please select back id picture");
        return;
      }
      showLoadingDialog(context, canPop: false);
      emit(state.copyWith(status: DashboardsStates.loading));
      await RideMethodHelper()
          .uploadDriverId(idImageInBehind: state.personalBackIdPicture!, idImageInFront: state.personalFrontIdPicture!,
          idExpiryDate: ridePersonalDocExpireDateController.text,
          onSuccessUploaded: (bool isSuccess) async{
        if (isSuccess) {
          showSuccessMessage(
              context,
              context.isArabic
                  ? 'تم رفع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                  : "Successfully uploaded image, please wait for the approval of all data.");
          context.pop();
          context.pop();
          emit(state.copyWith(status: DashboardsStates.success));
        } else {
          context.pop();
          showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
        }
      });
      Future.delayed(const Duration(seconds: 3));
      // driverInfo?.isUploadDriverId = true;
    }
  }

  onUploadPersonalFrontIdPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalFrontIdPicture: file));
        });
  }

  onUploadPersonalBackIdPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalBackIdPicture: file));
        });
  }

  Future<void> getDriverSettings() async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loading));

    final response = await getDriverSettingsUseCase(NoParams());

    if (isClosed) return;
    response.fold(
          (failure) {
        // log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
          (data) {
        log("Suzccess");
        emit(state.copyWith(
          status: DashboardsStates.successOffer,
          driverSettingsEntity: data,
        ));

      },
    );
  }
  Future<void> updateDriverSettings(
      bool isReady) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loading));

    final response = await updateDriverSettingsUseCase(UpdateDriverSettingsParams(isReady: isReady));

    if (isClosed) return;
    response.fold(
          (failure) {
        // log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
          (data) {
        log("Suzccess");
        emit(state.copyWith(
          status: DashboardsStates.successOffer,
          updateDriverSettingsEntity: data,
          offerCreatedShown: false, // freshly created
        ));
        getDriverSettings();
      },
    );
  }

  Future<void> createNonTrackOffer(
      CreateNonTrackOfferParams params,context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loading));

    final response = await createNonTrackTripUseCase(params);

    if (isClosed) return;
    response.fold(
          (failure) {
        // log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
          (data) {
        log("Suzccess");
        emit(state.copyWith(
          status: DashboardsStates.successOffer,
          createNonTrackOfferEntity: data,
          offerCreatedShown: false, // freshly created
        ));
        showSuccessMessage(context, data.message);
          },
    );
  }

  void clearCreateOfferState() {
    emit(state.copyWith(
      status: DashboardsStates.initState,
      createNonTrackOfferEntity: null,
      offerCreatedShown: true,
    ));
  }













  List<TripEntity> availableTripsNonSocket = [];

  List<HistoryTripEntity > pastRideNonSocketData = [];
  bool hasMorePastNonSocketTrips = true;
  int currentPagePastNonSocketTrips = 1;
  bool isLoadingMorePastNonSocketTrips = false;

  void loadInitialPastNonSocketTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    pastRideNonSocketData.clear();
    currentPagePastNonSocketTrips = 1;
    hasMorePastNonSocketTrips = true;
    await getPastNonSocketTrips();
    emit(state.copyWith(status: DashboardsStates.success));
  }

  Future<void> getPastNonSocketTrips() async {
    if (!hasMorePastNonSocketTrips || isLoadingMorePastNonSocketTrips) return;
    isLoadingMorePastNonSocketTrips = true;
    emit(state.copyWith(status: DashboardsStates.loading));
    final response = await getPastNonSocketTripsUseCase(
        ClientPendingTripParams(page: currentPagePastNonSocketTrips, limit: 5));
    response.fold(
          (failure) {
        isLoadingMorePastNonSocketTrips = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: DashboardsStates.error));
      },
          (data) {
        pastRideNonSocketData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMorePastNonSocketTrips = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: DashboardsStates.loading));

        } else {
          currentPagePastNonSocketTrips++;
        }

        isLoadingMorePastNonSocketTrips = false;
        emit(state.copyWith(pastRideNonSocketTrips: data,));
      },
    );
  }






  List<AcceptedRideNonSocketTripEntity> acceptedRideNonSocketData = [];
  bool hasMoreAcceptedNonSocketTrips = true;
  int currentPageAcceptedNonSocketTrips = 1;
  bool isLoadingMoreAcceptedNonSocketTrips = false;

  void loadInitialAcceptedNonSocketTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    acceptedRideNonSocketData.clear();
    currentPageAcceptedNonSocketTrips = 1;
    hasMoreAcceptedNonSocketTrips = true;
    await getAcceptedNonSocketTrips();
    emit(state.copyWith(status: DashboardsStates.success));
  }

  Future<void> getAcceptedNonSocketTrips() async {
    if (!hasMoreAcceptedNonSocketTrips || isLoadingMoreAcceptedNonSocketTrips) return;
    isLoadingMoreAcceptedNonSocketTrips = true;
    emit(state.copyWith(status: DashboardsStates.loading));
    final response = await getAcceptedNonSocketTripsUseCase(
        ClientPendingTripParams(page: currentPageAcceptedNonSocketTrips, limit: 5));
    response.fold(
          (failure) {
        isLoadingMoreAcceptedNonSocketTrips = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: DashboardsStates.error));
      },
          (data) {
        acceptedRideNonSocketData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreAcceptedNonSocketTrips = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: DashboardsStates.loading));

        } else {
          currentPageAcceptedNonSocketTrips++;
        }

        isLoadingMoreAcceptedNonSocketTrips = false;
        emit(state.copyWith(acceptedRideNonSocketTrips: data,));
      },
    );
  }


  List<AvailableRideNonSocketTripEntity> availableRideNonSocketData = [];
  bool hasMoreAvailableNonSocketTrips = true;
  int currentPageAvailableNonSocketTrips = 1;
  bool isLoadingMoreAvailableNonSocketTrips = false;

  void loadInitialAvailableNonSocketTrips() async {
    // emit(state.copyWith(status: RestaurantsListStates.loading));
    availableRideNonSocketData.clear();
    currentPageAvailableNonSocketTrips = 1;
    hasMoreAvailableNonSocketTrips = true;
    await getAvailableNonSocketTrips();
    emit(state.copyWith(status: DashboardsStates.success));
  }

  Future<void> getAvailableNonSocketTrips() async {
    if (!hasMoreAvailableNonSocketTrips || isLoadingMoreAvailableNonSocketTrips) return;
    isLoadingMoreAvailableNonSocketTrips = true;
    emit(state.copyWith(status: DashboardsStates.loading));
    final response = await getAvailableNonSocketTripsUseCase(
        ClientPendingTripParams(page: currentPageAvailableNonSocketTrips, limit: 5));
    response.fold(
          (failure) {
        isLoadingMoreAvailableNonSocketTrips = false;
        emit(state.copyWith(
            failure: failure,
            // isLoadingMoreLogs: false,
            status: DashboardsStates.error));
      },
          (data) {
        availableRideNonSocketData.addAll(data);
        if ((data.length ?? 0) < 5) {
          hasMoreAvailableNonSocketTrips = false;
          // emit(state.copyWith(isLoadingMore: false));
          emit(state.copyWith(status: DashboardsStates.loading));

        } else {
          currentPageAvailableNonSocketTrips++;
        }

        isLoadingMoreAvailableNonSocketTrips = false;
        emit(state.copyWith(availableRideNonSocketTrips: data,));
      },
    );
  }
  void changeIndex(int index, BuildContext context, RideModeParams params) {
    final settings = state.driverSettingsEntity; // Assuming this contains `isReady`

    emit(state.copyWith(currentIndex: index, status: DashboardsStates.success));

    // Index 0: Available Trips
    if (index == 0) {
      if (params.isSocket == true) {
        loadAvailableRideTrips(context);
      } else if (params.modeType == "ride" && settings?.isReady == true) {
        loadInitialAvailableNonSocketTrips();
      }
      return; // prevent loading other data if index is 0
    }

    // Index 2: Past Trips
    if (index == 2 && params.isSocket == false && params.modeType == "ride") {
      loadInitialPastNonSocketTrips();
    }

    // Index 3: Settings
    if (index == 3 && params.isSocket == false && params.modeType == "ride") {
      getDriverSettings();
    }

    // Index 4: Accepted Trips
    if (index == 4 && params.isSocket == false && params.modeType == "ride") {
      loadInitialAcceptedNonSocketTrips();
    }
  }

  // void changeIndex(int index,BuildContext context,RideModeParams params){
  //   final settings = state.driverSettingsEntity;
  //   emit(state.copyWith(currentIndex: index, status: DashboardsStates.success));
  //   if(index==0 && params.isSocket == true)loadAvailableRideTrips(context);
  //   /// method load
  //   if(index== 0&& params.isSocket == false && params.modeType == "ride")loadInitialAvailableNonSocketTrips();
  //   if(index== 4&& params.isSocket == false && params.modeType == "ride")loadInitialAcceptedNonSocketTrips();
  //   if(index==2&& params.isSocket == false && params.modeType == "ride")loadInitialPastNonSocketTrips();
  //   if(index==3&& params.isSocket == false && params.modeType == "ride")getDriverSettings();
  // }

  void listenToRemoveTrip() {
    CliLogger.info('Remove Trip');
    // TripsResponseEntity
    listenToRemoveTripUseCase((tripId) {
      List<AvailableRideTripEntity> list = state.availableRideTrips ?? [];
      log("tripId.toString()${tripId.toString()}");
      if(tripId.isNotEmpty)list.removeWhere((e)=>e.id==tripId);
      // log(trip.toString());
      // list.insert(0, trip);
      emit(state.copyWith(availableRideTrips: list));
    });
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

  void listenToRemoveUntrackedTrip() {
    CliLogger.info('Remove Trip');
    // TripsResponseEntity
    listenToRemoveUntrackedTripUseCase((tripId) {
      List<AvailableRideNonSocketTripEntity> list = availableRideNonSocketData ?? [];
      log("tripId.toString()${tripId.toString()}");
      if(tripId.isNotEmpty)list.removeWhere((e)=>e.tripDetails?.id==tripId);
      // log(trip.toString());
      // list.insert(0, trip);
      emit(state.copyWith(availableRideNonSocketTrips: list));
    });
  }

  void listenToUpdateTripAutoAccept() {
    CliLogger.info('Listen To Update Trip Auto Accept');
    listenToUpdateTripAutoAcceptUseCase((trip) {
      List<AvailableRideTripEntity> list = state.availableRideTrips ?? [];
      list.firstWhere((e)=>e.id==trip.id).isAutoAccept = trip.isAutoAccept;
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
      list.firstWhere((e)=>e.id==trip.tripId).price = trip.price;
      log(trip.toString());
      emit(state.copyWith(availableRideTrips: list));
    });
  }

  void listenToAcceptOffer() {
    CliLogger.info('Listen To Update Trip Auto Accept');
    listenToAcceptOfferUseCase((trip) {
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
    final Either<Failure, TripsResponseEntity> result =
        await getAvailableTripsUsecase(AvailableRideTripsUseCaseParams(
            page: currentPage, limit: pageSize));
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
        emit(state.copyWith(
            status: DashboardsStates.success,
            availableTrips: availableRideTrips));
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
        emit(state.copyWith(
            status: DashboardsStates.success,
            availableRideTrips: availableRideTrips));
      },
    );
  }

  Future<void> getPastTrips(BuildContext context, String type) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, TripsResponseEntity> result =
        await getPastTripsUsecase(type);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (pastTrips) {
        log("Suzccess");
        emit(state.copyWith(
            status: DashboardsStates.success, pastTrips: pastTrips.data.trips));
      },
    );
  }

  Future<void> getSettings(BuildContext context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingSettings));

    final Either<Failure, SettingsDashboardEntityResponse> result =
        await getSettingsDashboardUsecase(const NoParams());

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(
            status: DashboardsStates.success, settings: settings.data));
      },
    );
  }

  Future<void> updateSettings(
      BuildContext context, UpdateSettingsDashboardUsecaseParam param) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingSettings));

    final Either<Failure, bool> result =
        await updateSettingsDashboardUsecase(param);

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

  Future<void> createNewOffer(
      BuildContext context, CreateNewOfferDashboardUsecaseParam param) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingCreateOffer));

    final Either<Failure, bool> result =
        await createNewOfferDashboardUsecase(param);

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

  Future<void> createNewOfferNonSocket(BuildContext context,
      CreateNewOfferDashboardUsecaseParam param, String subCategoryId) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loadingCreateOffer));

    final Either<Failure, bool> result =
        await createNewOfferNonSocketUsecase(param);

    if (isClosed) return;
    result.fold(
      (failure) {
        String errorName = getFailureName(failure, context);
        errorName == 'DebtError'
            ? showDebtDialog(context, subCategoryId)
            : errorName == 'SubscribeError'
                ? showSubscribeDialog(context, subCategoryId)
                : showErrorMessage(
                    context, getFailureMessage(failure, context));
        emit(state.copyWith(
            status: DashboardsStates.errorOffers, failure: failure));
      },
      (settings) {
        log("Suzccess");
        showSuccessMessage(context, 'Offer Created Successfully');
        emit(state.copyWith(status: DashboardsStates.successOffer));
      },
    );
  }

  Future<void> createOffer(
      {required String tripId,
      required num price,
      required BuildContext context,
      required String subCategoryId}) async {
    emit(state.copyWith(status: DashboardsStates.loadingAcceptOffer));
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final response = await createRiderOfferUseCase(CreateRiderOfferParams(
        tripId: tripId,
        price: price,
        lat: currentPosition.latitude,
        lng: currentPosition.longitude));
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

  Future<void> createDriverRating(
      BuildContext context, CreateUpdateDriverRatingUsecaseParam param) async {
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

  Future<void> updateDriverRating(
      BuildContext context, CreateUpdateDriverRatingUsecaseParam param) async {
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
    availableTripsNonSocket
        .removeWhere((element) => element.tripDetails!.id == id);
    emit(state.copyWith(
        status: DashboardsStates.successOffer,
        availableTrips: availableTripsNonSocket));
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
                      SubscriptionMethod().subscribe(
                          subscribeId: subCategoryId,
                          showRegular: true,
                          title: '');
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
                      serviceLocator<SubscriptionController>()
                          .showActiveSubscriptionAmounts(
                              walletType: WalletTypes.mainWallet, price: 50);
                    }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ));
  }
}
