import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/support_status_enum.dart';
import 'package:fourtyninehub/core/enums/trip_states_enum.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/upload_record.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/arrived_to_client_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/emergency_contact_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/support_details_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/arrived_to_client_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/auto_accept_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/delete_emergency_contact_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/driver_rate_client_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/emergency_support_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/finalize_trip_by_rider.dart.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_ride_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_available_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_emergency_contacts_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/add_emergency_contacts_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/edit_emergency_contacts_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_running_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/going_to_client_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_accept_offer_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_change_trip_price_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_end_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_new_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_remove_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/listen_to_update_trip_auto_accept_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/start_ride_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/complete_ride_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/watching_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/recording_trip_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_ride_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
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
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/functions/global/upload_image.dart';
import '../../../../../core/error/failure.dart';

import '../../../../../core/utils/loading_method_helper.dart';
import '../../../../../core/utils/ride_method_helper.dart';
import '../../../../food_feature/restaurants_list/domain/entities/rate_response_entity.dart';
import '../../../../food_feature/restaurants_list/domain/usecases/add_rate_restaurant_use_case.dart';
import '../../../domain/entities/dashboards/create_non_track_offer_entity.dart';
import '../../../domain/entities/dashboards/driver_settings_entity.dart';
import '../../../domain/entities/dashboards/get_accepted_ride_non_socket_trip_entity.dart';
import '../../../domain/entities/dashboards/get_available_ride_non_socket_trip_entity.dart';
import '../../../domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import '../../../domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import '../../../domain/entities/dashboards/trips_response_entity.dart';
import '../../../domain/entities/dashboards/update_driver_settings_entity.dart';
import '../../../domain/usecases/dashboards/add_rate_with_driver_use_case.dart';
import '../../../domain/usecases/dashboards/create_driver_rating_usecase.dart';
import '../../../domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import '../../../domain/usecases/dashboards/create_non_track_offer_use_case.dart';
import '../../../domain/usecases/dashboards/get_accepted_ride_non_socket_trips_use_case.dart';
import '../../../domain/usecases/dashboards/get_available_ride_non_socket_trips_use_case.dart';
import '../../../domain/usecases/dashboards/get_driver_settings_usecase.dart';
import '../../../domain/usecases/dashboards/get_past_ride_non_socket_trips_use_case.dart';
import '../../../domain/usecases/dashboards/get_past_trips_usecase.dart';
import '../../../domain/usecases/dashboards/get_settings_dashboard_usecase.dart';
import '../../../domain/usecases/dashboards/listen_to_accept_untracked_trip_offer_use_case.dart';
import '../../../domain/usecases/dashboards/listen_to_available_untracked_trip_use_case.dart';
import '../../../domain/usecases/dashboards/listen_to_remove_untracked_trip_use_case.dart';
import '../../../domain/usecases/dashboards/update_driver_rating_usecase.dart';
import '../../../domain/usecases/dashboards/update_driver_settings_use_case.dart';
import '../../../domain/usecases/dashboards/update_settings_dashboard_usecase.dart';
import '../../../domain/usecases/get_client_pending_untracked_trips_use_case.dart';
import '../../pages/Register/Driver/upload_rider_images.dart';
import '../../pages/dashboards/ride_mode_screen.dart';
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
  final WatchingTripsUseCase watchingTripsUseCase;
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
  final GetAvailableNonSocketTripsUseCase getAvailableNonSocketTripsUseCase;
  final GetAcceptedNonSocketTripsUseCase getAcceptedNonSocketTripsUseCase;
  final GetPastNonSocketTripsUseCase getPastNonSocketTripsUseCase;
  final CreateNonTrackOfferUseCase createNonTrackTripUseCase;
  final UpdateDriverSettingsUseCase updateDriverSettingsUseCase;
  final GetDriverSettingsUseCase getDriverSettingsUseCase;
  final ListenToRemoveUntrackedTripUseCase listenToRemoveUntrackedTripUseCase;
  final GetEmergencyContactsUseCase getEmergencyContactsUseCase;
  final AddEmergencyContactsUseCase addEmergencyContactsUseCase;
  final EditEmergencyContactsUseCase editEmergencyContactsUseCase;
  final DeleteEmergencyContactUseCase deleteEmergencyContactUseCase;
  final FinalizeTripByRiderUseCase finalizeTripByRiderUseCase;
  final ListenToAvailableUntrackedTripUseCase
      listenToAvailableUntrackedTripUseCase;
  final ListenToAcceptUntrackedTripOfferUseCase
      listenToAcceptUntrackedTripOfferUseCase;
  final ListenToEndTripUseCase listenToEndTripUseCase;
  final AddRateWithDriverUseCase addRateWithDriverUseCase;
  final terminalExaminationFormKey = GlobalKey<FormState>();

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
      this.getAvailableNonSocketTripsUseCase,
      this.getAcceptedNonSocketTripsUseCase,
      this.getPastNonSocketTripsUseCase,
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
      this.getEmergencyContactsUseCase,
      this.addEmergencyContactsUseCase,
      this.editEmergencyContactsUseCase,
      this.watchingTripsUseCase,
      this.deleteEmergencyContactUseCase,
      this.finalizeTripByRiderUseCase,
      this.listenToAvailableUntrackedTripUseCase,
      this.listenToEndTripUseCase,
      this.createNonTrackTripUseCase,
      this.updateDriverSettingsUseCase,
      this.getDriverSettingsUseCase,
      this.listenToRemoveUntrackedTripUseCase,
      this.listenToAcceptUntrackedTripOfferUseCase,
      this.addRateWithDriverUseCase)
      : super(const DashboardsState());
  TextEditingController rideVehicleExpireDateController =
      TextEditingController();
  final criminalRecordFormKey = GlobalKey<FormState>();
  TextEditingController rideCriminalRecordExpireDateController = TextEditingController();
  TextEditingController rideTechnicalExaminationExpireDateController = TextEditingController();
  final drugAnalysisFormKey = GlobalKey<FormState>();
  TextEditingController rideDragAnalysisExpireDateController = TextEditingController();

  onSubmitUploadingTechnicalExamination(BuildContext context) async {
    if (terminalExaminationFormKey.currentState!.validate()) {
      emit(state.copyWith(status: DashboardsStates.loadingSubmitRequest));

      await RideMethodHelper().uploadTechnicalExamination(
          technicalExaminationDate: rideTechnicalExaminationExpireDateController.text, technicalExaminationImage: state.personalTechnicalExaminationPicture!, onSuccessUploaded: (bool isSuccess) async{
        if (isSuccess) {
          showSuccessMessage(
              context,
              context.isArabic
                  ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                  : "Successfully uploaded images, please wait for the approval of all data.");
          // context.pop();
          context.pop();
          emit(state.copyWith(status: DashboardsStates.success));
        } else {
          context.pop();
          showErrorMessage(
              context,
              context.isArabic
                  ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                  : 'An error occurred while uploading images. Please try again.');
        }
      });
      emit(state.copyWith(status: DashboardsStates.success, ));
    }
  }
  onSubmitUploadingDrugAnalysis(BuildContext context) async {
    if (drugAnalysisFormKey.currentState!.validate()) {
      emit(state.copyWith(status: DashboardsStates.loadingSubmitRequest));
      showLoadingDialog(context, canPop: false);
      await RideMethodHelper().uploadDrugAnalysis(dragAnalysisDate: rideDragAnalysisExpireDateController.text, dragAnalysis: state.personalDrugAnalysisPicture!, onSuccessUploaded: (bool isSuccess) async{
        if (isSuccess) {
          showSuccessMessage(
              context,
              context.isArabic
                  ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                  : "Successfully uploaded images, please wait for the approval of all data.");
          // context.pop();
          context.pop();
          emit(state.copyWith(status: DashboardsStates.success));
        } else {
          context.pop();
          showErrorMessage(
              context,
              context.isArabic
                  ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                  : 'An error occurred while uploading images. Please try again.');
        }
      });
      emit(state.copyWith(status: DashboardsStates.success));
    }
  }
  onUploadPersonalTechnicalExaminationPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalTechnicalExaminationPicture: file));
        });
  }
  onUploadPersonalDrugAnalysisPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalDrugAnalysisPicture: file));
        });
  }
  onSubmitUploadingCriminalRecord(BuildContext context) async {
    if (criminalRecordFormKey.currentState!.validate()) {
      emit(state.copyWith(status: DashboardsStates.loadingSubmitRequest));

      await RideMethodHelper().uploadCriminalRecord(criminalRecordDate: rideCriminalRecordExpireDateController.text, criminalRecordImage: state.personalCriminalRecordPicture!, onSuccessUploaded: (bool isSuccess) async{
        if (isSuccess) {
          showSuccessMessage(
              context,
              context.isArabic
                  ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                  : "Successfully uploaded images, please wait for the approval of all data.");
          // context.pop();
          context.pop();
          emit(state.copyWith(status: DashboardsStates.success));
        } else {
          context.pop();
          showErrorMessage(
              context,
              context.isArabic
                  ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                  : 'An error occurred while uploading images. Please try again.');
        }
      });
      emit(state.copyWith(status: DashboardsStates.success));
    }
  }

  onUploadVehiclePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(vehiclePicture: file));
        });
  }
  onUploadPersonalCriminalRecordPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalCriminalRecordPicture: file));
        });
  }

  onUploadVehicleFrontPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(vehicleFrontPicture: file));
        });
  }

  onUploadVehicleBackPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(vehicleBackPicture: file));
        });
  }

  onSubmitUploadingCarLicense(
      BuildContext context, ) async {
    emit(state.copyWith(status: DashboardsStates.loadingSubmitRequest));
    showLoadingDialog(context, canPop: false);
    await RideMethodHelper().uploadCarLicense(
        licenseExpiryDate: rideVehicleExpireDateController.text,
        carLicenseBehindImage: state.vehicleBackPicture!,
        carLicenseFrontImage: state.vehicleFrontPicture!,
        onSuccessUploaded: (bool isSuccess) async {
          if (isSuccess) {
            // showSuccessMessage(
            //     context,
            //     context.isArabic
            //         ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
            //         : "Successfully uploaded images, please wait for the approval of all data.");
            // context.pop();
            // context.pop();
            emit(state.copyWith(status: DashboardsStates.success));
          } else {
            context.pop();
            showErrorMessage(
                context,
                context.isArabic
                    ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                    : 'An error occurred while uploading images. Please try again.');
          }
        });
         await RideMethodHelper().uploadCarImage(
            carImage: state.vehiclePicture!,
            onSuccessUploaded: (bool isSuccess) async {
              log('uploadCarImageSuccessCubit $isSuccess');

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
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            });
    emit(state.copyWith(status: DashboardsStates.success));
  }

  TextEditingController rideDriverExpireDateController =
      TextEditingController();

  Future<void> rateDriverNonSocket(
      {required AddRateWithDriverParams params}) async {
    emit(state.copyWith(status: DashboardsStates.loading));

    final response = await addRateWithDriverUseCase(params);

    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: DashboardsStates.error));
      },
      (rateData) {
        emit(state.copyWith(
          rateResponseEntity: rateData,
          status: DashboardsStates.success,
        ));
      },
    );
  }

  void listenToAcceptTripOfferTrip(
      int index, BuildContext context, RideModeParams params) {
    CliLogger.info('Remove Trip');
    // TripsResponseEntity
    listenToAcceptUntrackedTripOfferUseCase((tripId) {
      List<AvailableRideTripEntity> list = state.availableRideTrips ?? [];
      if (tripId.isNotEmpty) {
        list.removeWhere((e) => e.id == tripId);

        // Switch to index 4 (Accepted Trips) whenever a trip is accepted
        emit(state.copyWith(
          availableRideTrips: list,
          // currentIndex: 4,
          status: DashboardsStates.success,
        ));
        changeIndex(4, context, params);
        // loadInitialAcceptedNonSocketTrips();
      }
    });
  }

  onSubmitUploadingDriverLicense(BuildContext context) async {
    if (driverLicenseFormKey.currentState!.validate()) {
      if (state.driverLicensePicture == null) {
        showErrorMessage(context, "Please select driver license picture");
        return;
      }
      if (state.backOfDriverLicensePicture == null) {
        showErrorMessage(
            context, "Please select back of driver license picture");
        return;
      }
      if (state.selfieDriverLicensePicture == null) {
        showErrorMessage(
            context, "Please select selfie driver license picture");
        return;
      }
      showLoadingDialog(context, canPop: false);
      await RideMethodHelper().uploadDriverLicense(
          drivingImageInFront: state.driverLicensePicture!,
          drivingImageBehind: state.backOfDriverLicensePicture!,
          drivingExpiryDate: rideDriverExpireDateController.text,
          onSuccessUploaded: (bool isSuccess) async {
            if (isSuccess) {
              emit(state.copyWith(status: DashboardsStates.success));
            } else {
              showErrorMessage(
                  context,
                  context.isArabic
                      ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                      : 'An error occurred while uploading images. Please try again.');
            }
          });
      emit(state.copyWith(status: DashboardsStates.success));

      await RideMethodHelper().confirmIdentity(
          verifyUserImage: state.selfieDriverLicensePicture!,
          onSuccessUploaded: (bool isSuccess) async {
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
              showErrorMessage(
                  context,
                  context.isArabic
                      ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                      : 'An error occurred while uploading images. Please try again.');
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

  TextEditingController ridePersonalDocExpireDateController =
      TextEditingController();

  onSubmitUploadingId(
    BuildContext context,
  ) async {
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
      await RideMethodHelper().uploadDriverId(
          idImageInBehind: state.personalBackIdPicture!,
          idImageInFront: state.personalFrontIdPicture!,
          idExpiryDate: ridePersonalDocExpireDateController.text,
          onSuccessUploaded: (bool isSuccess) async {
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
              showErrorMessage(
                  context,
                  context.isArabic
                      ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                      : 'An error occurred while uploading images. Please try again.');
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

  Future<void> updateDriverSettings(bool isReady) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: DashboardsStates.loading));

    final response = await updateDriverSettingsUseCase(
        UpdateDriverSettingsParams(isReady: isReady));

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
      CreateNonTrackOfferParams params, context, String subCategoryId) async {
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
        String errorName = getFailureName(state.failure!, context);
        if (errorName == 'SubscribeError') {
          // showSubscribeDialog(context, subCategoryId);
          SubscriptionMethod().subscribe(
            subscribeId: subCategoryId,
            title: 'Ride',
          );
        }
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

  List<HistoryTripEntity> pastRideNonSocketData = [];
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

  Future<void> emitWatchingTrips(List<String> tripIds) async {
    var user = UserCubit.to.state.data;
    final result = await watchingTripsUseCase(WatchingTripsParams(
        tripIds: tripIds,
        driverImage: user?.profilePicture ?? '',
        driverId: user?.id ?? ''));
    result.fold(
        (l) => emit(state.copyWith(failure: l, status: DashboardsStates.error)),
        (r) async {
      if (r == true) log("Location Updated Successfully");
    });
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
        emit(state.copyWith(
          pastRideNonSocketTrips: data,
        ));
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
    if (!hasMoreAcceptedNonSocketTrips || isLoadingMoreAcceptedNonSocketTrips)
      return;
    isLoadingMoreAcceptedNonSocketTrips = true;
    emit(state.copyWith(status: DashboardsStates.loading));
    final response = await getAcceptedNonSocketTripsUseCase(
        ClientPendingTripParams(
            page: currentPageAcceptedNonSocketTrips, limit: 5));
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
        emit(state.copyWith(
          acceptedRideNonSocketTrips: data,
        ));
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
    if (!hasMoreAvailableNonSocketTrips || isLoadingMoreAvailableNonSocketTrips)
      return;
    isLoadingMoreAvailableNonSocketTrips = true;
    emit(state.copyWith(status: DashboardsStates.loading));
    final response = await getAvailableNonSocketTripsUseCase(
        ClientPendingTripParams(
            page: currentPageAvailableNonSocketTrips, limit: 5));
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
        emit(state.copyWith(
          availableRideNonSocketTrips: data,
        ));
      },
    );
  }

  TextEditingController reasonController = TextEditingController();

  void changeIndex(int index, BuildContext context, RideModeParams params) {
    final settings =
        state.driverSettingsEntity; // Assuming this contains `isReady`

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

    if (index == 1 && params.isSocket == true) getActiveTrip(context);
    if (index == 2 && params.isSocket == true)
      loadPastRideTrips(
          context, params.isSocket == true ? "tracking" : 'non-tracking');
    if (index == 3 && params.isSocket == true) getSettings(context);

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
      if (tripId.isNotEmpty) list.removeWhere((e) => e.id == tripId);
      // log(trip.toString());
      // list.insert(0, trip);
      emit(state.copyWith(availableRideTrips: list));
    });
  }

  void listenToEndTrip(BuildContext context) {
    CliLogger.info('End Trip');
    // TripsResponseEntity
    listenToEndTripUseCase((tripId) {
      log("messageTripId $tripId");
      showErrorMessage(
          context,
          context.isArabic
              ? 'تم إلغاء الرحلة من قبل العميل'
              : 'Trip has been canceled by the customer');
      emit(state.copyWith(status: DashboardsStates.success, tripStatus: ''));
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
      emitWatchingTrips([trip.id]);
    });
  }

  void listenToNewTripNonSocket() {
    CliLogger.info('Listen To New Trip');
    // TripsResponseEntity
    listenToAvailableUntrackedTripUseCase((trip) {
      List<AvailableRideNonSocketTripEntity> list =
          availableRideNonSocketData ?? [];
      list.insert(0, trip);
      emit(state.copyWith(availableRideNonSocketTrips: list));
      log(trip.toString());
    });
  }

  void listenToRemoveUntrackedTrip() {
    CliLogger.info('Remove Trip');
    // TripsResponseEntity
    listenToRemoveUntrackedTripUseCase((tripId) {
      List<AvailableRideNonSocketTripEntity> list =
          availableRideNonSocketData ?? [];
      log("tripId.toString()${tripId.toString()}");
      if (tripId.isNotEmpty)
        list.removeWhere((e) => e.tripDetails?.id == tripId);
      if (tripId.isNotEmpty)
        list.removeWhere((e) => e.tripDetails?.id == tripId);
      // log(trip.toString());
      // list.insert(0, trip);
      emit(state.copyWith(availableRideNonSocketTrips: list));
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

  void listenToAcceptOffer(BuildContext context, RideModeParams params) {
    CliLogger.info('Listen To Update Trip Auto Accept');
    listenToAcceptOfferUseCase((trip) {
      changeIndex(1, context, params);
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

  bool isLoadingAvailableRideTrips = false;

  void loadAvailableRideTrips(BuildContext context) async {
    isLoadingAvailableRideTrips = true;
    print("loadAvailableRideTrips1");
    emit(state.copyWith(availableRideTrips: []));
    currentPage = 1;
    availableRideTrips.clear();
    hasMoreData = true;
    await getAvailableRideTrips(context);
    print("loadAvailableRideTrips2");
    isLoadingAvailableRideTrips = false;
  }

  // List<AvailableRideTripEntity> availableRideTrips = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;
  List<AvailableRideTripEntity> availableRideTrips = [];

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
        List<String> tripIds = data.map((e) => e.id).toList();
        if (tripIds.isNotEmpty) emitWatchingTrips(tripIds);
        // availableRideTrips.addAll(state.availableRideTrips ?? []);
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

  bool isLoadingPastRideTrips = false;

  void loadPastRideTrips(BuildContext context, String type) async {
    isLoadingPastRideTrips = true;
    print("loadPastRideTrips1");
    emit(state.copyWith(availableRideTrips: []));
    currentPastTripPage = 1;
    pastRideTrips.clear();
    hasMorePastTripData = true;
    await getPastTrips(context, type);
    print("loadPastRideTrips2");
    isLoadingPastRideTrips = false;
  }

  bool isLoadingPastTripMore = false;
  bool hasMorePastTripData = true;
  int currentPastTripPage = 1;
  List<TripEntity> pastRideTrips = [];

  Future<void> getPastTrips(BuildContext context, String type) async {
    if (!hasMorePastTripData || isLoadingPastTripMore) return;
    emit(state.copyWith(status: DashboardsStates.loadingPast));
    isLoadingPastRideTrips = true;
    final Either<Failure, TripsResponseEntity> result =
        await getPastTripsUsecase(GetPastTripsParams(
            type: type, limit: pageSize, page: currentPastTripPage));
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (pastTrips) {
        print("pastTrips.data.trips ${pastTrips.data.trips}");
        // availableRideTrips.addAll(state.availableRideTrips ?? []);
        pastRideTrips.addAll(pastTrips.data.trips);
        if (pastTrips.data.trips.length < pageSize) {
          hasMorePastTripData = false;
        } else {
          currentPastTripPage++;
        }
        isLoadingPastRideTrips = false;
        emit(state.copyWith(
            status: DashboardsStates.success, pastTrips: pastTrips.data.trips));
      },
    );
  }

  Future<void> getActiveTrip(BuildContext context) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, RunningTripEntity> result =
        await getRunningTripUseCase(const NoParams());

    if (isClosed) return;
    result.fold(
      (failure) {
        context.pop();
        log("Failure ${getFailureMessage(failure, context)}");
        showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(
            status: DashboardsStates.error,
            failure: failure,
            tripStatus: TripState.pending.name));
      },
      (activeTrip) {
        log("Suzccess");
        context.pop();
        emit(state.copyWith(
            status: DashboardsStates.success,
            activeTrip: activeTrip,
            tripStatus: activeTrip.status));
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
        emit(state.copyWith(
            status: DashboardsStates.success,
            tripStatus: TripState.goToClient.name));
      },
    );
  }

  showSafety(String lastStatus) {
    emit(state.copyWith(tripStatus: 'support', lastStatus: lastStatus));
  }

  closeSafety() {
    emit(state.copyWith(tripStatus: state.lastStatus));
  }

  updateRemainingTime(DateTime futureTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('remaining_time', futureTime.toIso8601String());
    await checkExpiryTime();
  }

  checkExpiryTime() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTimeString = prefs.getString('remaining_time');

    if (savedTimeString != null) {
      final savedTime = DateTime.parse(savedTimeString);
      emit(state.copyWith(remainingTime: savedTime));
      if (savedTime.isAfter(DateTime.now())) {
        return savedTime;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> arrivedToClient(
      BuildContext context, String id, String message) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result = await arrivedToClientUseCase(
        ArrivedToClientEntity(tripId: id, message: message));

    if (isClosed) return;
    result.fold(
      (failure) {
        context.pop();
        log("Failure ${getFailureMessage(failure, context)}");
        showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (activeTrip) async {
        final prefs = await SharedPreferences.getInstance();
        final futureTime = DateTime.now().add(Duration(minutes: 5));
        await prefs.setString('remaining_time', futureTime.toIso8601String());
        log("Suzccess");
        context.pop();
        emit(state.copyWith(
            status: DashboardsStates.success,
            remainingTime: futureTime,
            tripStatus: TripState.inLocation.name));
      },
    );
  }

  Future<void> startDriverTrip(
      BuildContext context, String id, String otp) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result = await startDriverTripUseCase(
        StartDriverTripParams(tripId: id, otp: otp));

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
        emit(state.copyWith(
            status: DashboardsStates.success,
            tripStatus: TripState.started.name));
      },
    );
  }

  Future<void> completeDriverTrip(
      BuildContext context, String id, String otp) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result = await completeDriverTripUseCase(
        StartDriverTripParams(tripId: id, otp: otp));

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
        emit(state.copyWith(
            status: DashboardsStates.success,
            tripStatus: TripState.completed.name));
      },
    );
  }

  Future<void> cancelDriverTrip(
      {required BuildContext context,
      required String tripId,
      required String note,
      required String reasonId}) async {
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result = await cancelTripByRiderUseCase(
        CancelTripByRiderUseCaseParams(
            tripId: tripId, note: note, reasonId: reasonId));

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (activeTrip) {
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.success, tripStatus: ''));
      },
    );
  }

  Future<void> finalizeTripByRider(
      {required BuildContext context, required String tripId}) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result =
        await finalizeTripByRiderUseCase(tripId);

    if (isClosed) return;
    result.fold(
      (failure) {
        context.pop();
        log("Failure ${getFailureMessage(failure, context)}");
        showErrorMessage(context, getFailureMessage(failure, context));
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (activeTrip) {
        context.pop();
        log("Suzccess");
        emit(state.copyWith(status: DashboardsStates.success, tripStatus: ''));
      },
    );
  }

  Future<void> rateTheClient(
      {required BuildContext context,
      required String tripId,
      required String comment,
      required double rate}) async {
    showLoadingDialog(context);
    emit(state.copyWith(status: DashboardsStates.loadingPast));

    final Either<Failure, bool> result = await driverRateClientUseCase(
        DriverRateClientParams(tripId: tripId, comment: comment, rate: rate));

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
        emit(state.copyWith(status: DashboardsStates.success, tripStatus: ''));
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
    // emit(state.copyWith(status: DashboardsStates.loadingCreateOffer));
    showLoadingDialog(context);
    final Either<Failure, bool> result =
        await createNewOfferDashboardUsecase(param);

    if (isClosed) return;
    result.fold(
      (failure) {
        context.pop();
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (settings) {
        context.pop();
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
    showLoadingDialog(context);
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final response = await createRiderOfferUseCase(CreateRiderOfferParams(
        tripId: tripId,
        price: price,
        lat: currentPosition.latitude,
        lng: currentPosition.longitude));
    response.fold((l) {
      context.pop();
      String errorName = getFailureName(l, context);
      errorName == 'DebtError'
          ? showDebtDialog(context, subCategoryId)
          : errorName == 'SubscribeError'
              ? showSubscribeDialog(context, subCategoryId)
              : showErrorMessage(context, getFailureMessage(l, context));
      emit(state.copyWith(failure: l, status: DashboardsStates.error));
    }, (data) {
      context.pop();
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

  uploadRecord(BuildContext context, String tripId, String mediaId) async {
    final Either<Failure, bool> result =
        await recordingTripUseCase(RecordingTripUseCaseParams(tripId, mediaId));

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

  getEmergencyDetails(
      BuildContext context, SupportRideParams mainParams) async {
    GetSupportDetailsParams params = GetSupportDetailsParams(
        tripId: mainParams.tripId,
        tripType: mainParams.tripType,
        userType: mainParams.userType);
    emit(state.copyWith(status: DashboardsStates.loading));
    final Either<Failure, SupportDetailsEntity> result =
        await getSupportDetailsUseCase(params);

    result.fold(
      (failure) {
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (data) async {
        emit(state.copyWith(
            supportDetails: data,
            supportStatus: data.status,
            status: DashboardsStates.success));
      },
    );
  }

  var firstFormKey = GlobalKey<FormState>();
  var secondFormKey = GlobalKey<FormState>();
  var thirdFormKey = GlobalKey<FormState>();
  var fourthFormKey = GlobalKey<FormState>();
  var fifthFormKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController firstPhoneController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController secondPhoneController = TextEditingController();
  final TextEditingController thirdNameController = TextEditingController();
  final TextEditingController thirdPhoneController = TextEditingController();
  final TextEditingController fourthNameController = TextEditingController();
  final TextEditingController fourthPhoneController = TextEditingController();
  final TextEditingController fifthNameController = TextEditingController();
  final TextEditingController fifthPhoneController = TextEditingController();

  getEmergencyContacts(BuildContext context) async {
    firstNameController.clear();
    firstPhoneController.clear();
    secondNameController.clear();
    secondPhoneController.clear();
    thirdNameController.clear();
    thirdPhoneController.clear();
    fourthNameController.clear();
    fourthPhoneController.clear();
    fifthNameController.clear();
    fifthPhoneController.clear();

    emit(state.copyWith(status: DashboardsStates.loading));
    final Either<Failure, List<EmergencyContactEntity>> result =
        await getEmergencyContactsUseCase(const NoParams());

    result.fold(
      (failure) {
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (data) async {
        if (data.length == 1) {
          firstNameController.text = data[0].name;
          firstPhoneController.text = data[0].phoneNumber;
        } else if (data.length == 2) {
          firstNameController.text = data[0].name;
          firstPhoneController.text = data[0].phoneNumber;
          secondNameController.text = data[1].name;
          secondPhoneController.text = data[1].phoneNumber;
        } else if (data.length == 3) {
          firstNameController.text = data[0].name;
          firstPhoneController.text = data[0].phoneNumber;
          secondNameController.text = data[1].name;
          secondPhoneController.text = data[1].phoneNumber;
          thirdNameController.text = data[2].name;
          thirdPhoneController.text = data[2].phoneNumber;
        } else if (data.length == 4) {
          firstNameController.text = data[0].name;
          firstPhoneController.text = data[0].phoneNumber;
          secondNameController.text = data[1].name;
          secondPhoneController.text = data[1].phoneNumber;
          thirdNameController.text = data[2].name;
          thirdPhoneController.text = data[2].phoneNumber;
          fourthNameController.text = data[3].name;
          fourthPhoneController.text = data[3].phoneNumber;
        } else if (data.length > 4) {
          firstNameController.text = data[0].name;
          firstPhoneController.text = data[0].phoneNumber;
          secondNameController.text = data[1].name;
          secondPhoneController.text = data[1].phoneNumber;
          thirdNameController.text = data[2].name;
          thirdPhoneController.text = data[2].phoneNumber;
          fourthNameController.text = data[3].name;
          fourthPhoneController.text = data[3].phoneNumber;
          fifthNameController.text = data[4].name;
          fifthPhoneController.text = data[4].phoneNumber;
        }
        emit(state.copyWith(
            emergencyContacts: data, status: DashboardsStates.success));
      },
    );
  }

  addEmergencyContacts(
      {required BuildContext context,
      required String name,
      required String phoneNumber,
      required int index}) async {
    showLoadingDialog(context);

    final Either<Failure, EmergencyContactEntity> result =
        await addEmergencyContactsUseCase(EmergencyContactEntity(
            name: name, phoneNumber: phoneNumber, id: ''));

    result.fold(
      (failure) {
        context.pop();
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (addedContact) async {
        context.pop();
        showSuccessMessage(
            context,
            context.isArabic
                ? 'تم اضافة جهة الاتصال بنجاح'
                : 'Emergency contact added successfully');
        List<EmergencyContactEntity> contacts = state.emergencyContacts ?? [];
        contacts.add(addedContact);
        if (contacts.length < index) {
          if (index == 1) {
            firstNameController.clear();
            firstPhoneController.clear();
          } else if (index == 2) {
            secondNameController.clear();
            secondPhoneController.clear();
          } else if (index == 3) {
            thirdNameController.clear();
            thirdPhoneController.clear();
          } else if (index == 4) {
            fourthNameController.clear();
            fourthPhoneController.clear();
          } else if (index == 5) {
            fifthNameController.clear();
            fifthPhoneController.clear();
          }
        }
        if (contacts.length == 1) {
          firstNameController.text = contacts[0].name;
          firstPhoneController.text = contacts[0].phoneNumber;
        } else if (contacts.length == 2) {
          firstNameController.text = contacts[0].name;
          firstPhoneController.text = contacts[0].phoneNumber;
          secondNameController.text = contacts[1].name;
          secondPhoneController.text = contacts[1].phoneNumber;
        } else if (contacts.length == 3) {
          firstNameController.text = contacts[0].name;
          firstPhoneController.text = contacts[0].phoneNumber;
          secondNameController.text = contacts[1].name;
          secondPhoneController.text = contacts[1].phoneNumber;
          thirdNameController.text = contacts[2].name;
          thirdPhoneController.text = contacts[2].phoneNumber;
        } else if (contacts.length == 4) {
          firstNameController.text = contacts[0].name;
          firstPhoneController.text = contacts[0].phoneNumber;
          secondNameController.text = contacts[1].name;
          secondPhoneController.text = contacts[1].phoneNumber;
          thirdNameController.text = contacts[2].name;
          thirdPhoneController.text = contacts[2].phoneNumber;
          fourthNameController.text = contacts[3].name;
          fourthPhoneController.text = contacts[3].phoneNumber;
        } else if (contacts.length == 5) {
          firstNameController.text = contacts[0].name;
          firstPhoneController.text = contacts[0].phoneNumber;
          secondNameController.text = contacts[1].name;
          secondPhoneController.text = contacts[1].phoneNumber;
          thirdNameController.text = contacts[2].name;
          thirdPhoneController.text = contacts[2].phoneNumber;
          fourthNameController.text = contacts[3].name;
          fourthPhoneController.text = contacts[3].phoneNumber;
          fifthNameController.text = contacts[4].name;
          fifthPhoneController.text = contacts[4].phoneNumber;
        }
        emit(state.copyWith(
            emergencyContacts: contacts, status: DashboardsStates.success));
      },
    );
  }

  deleteEmergencyContact(
      BuildContext context, EmergencyContactEntity contact, int index) async {
    showLoadingDialog(context);

    final Either<Failure, bool> result =
        await deleteEmergencyContactUseCase(contact);

    result.fold(
      (failure) {
        context.pop();
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (data) async {
        context.pop();
        showSuccessMessage(
            context,
            context.isArabic
                ? 'تم حذف جهة الاتصال بنجاح'
                : 'Emergency contact deleted successfully');
        List<EmergencyContactEntity> contacts = state.emergencyContacts ?? [];
        contacts.removeWhere((e) => e.id == contact.id);
        if (contacts.isEmpty) {
          firstNameController.clear();
          firstPhoneController.clear();
          secondNameController.clear();
          secondPhoneController.clear();
          thirdNameController.clear();
          thirdPhoneController.clear();
          fourthNameController.clear();
          fourthPhoneController.clear();
          fifthNameController.clear();
          fifthPhoneController.clear();
        } else if (contacts.length == 1) {
          firstNameController.text = contacts[0].name;
          firstPhoneController.text = contacts[0].phoneNumber;
          secondNameController.clear();
          secondPhoneController.clear();
          thirdNameController.clear();
          thirdPhoneController.clear();
          fourthNameController.clear();
          fourthPhoneController.clear();
          fifthNameController.clear();
          fifthPhoneController.clear();
        } else if (contacts.length == 2) {
          firstNameController.text = contacts[0].name;
          firstPhoneController.text = contacts[0].phoneNumber;
          secondNameController.text = contacts[1].name;
          secondPhoneController.text = contacts[1].phoneNumber;
          thirdNameController.clear();
          thirdPhoneController.clear();
          fourthNameController.clear();
          fourthPhoneController.clear();
          fifthNameController.clear();
          fifthPhoneController.clear();
        } else if (contacts.length == 3) {
          firstNameController.text = contacts[0].name;
          firstPhoneController.text = contacts[0].phoneNumber;
          secondNameController.text = contacts[1].name;
          secondPhoneController.text = contacts[1].phoneNumber;
          thirdNameController.text = contacts[2].name;
          thirdPhoneController.text = contacts[2].phoneNumber;
          fourthNameController.clear();
          fourthPhoneController.clear();
          fifthNameController.clear();
          fifthPhoneController.clear();
        } else if (contacts.length == 4) {
          firstNameController.text = contacts[0].name;
          firstPhoneController.text = contacts[0].phoneNumber;
          secondNameController.text = contacts[1].name;
          secondPhoneController.text = contacts[1].phoneNumber;
          thirdNameController.text = contacts[2].name;
          thirdPhoneController.text = contacts[2].phoneNumber;
          fourthNameController.text = contacts[3].name;
          fourthPhoneController.text = contacts[3].phoneNumber;
          fifthNameController.clear();
          fifthPhoneController.clear();
        } else if (contacts.length == 5) {
          firstNameController.text = contacts[0].name;
          firstPhoneController.text = contacts[0].phoneNumber;
          secondNameController.text = contacts[1].name;
          secondPhoneController.text = contacts[1].phoneNumber;
          thirdNameController.text = contacts[2].name;
          thirdPhoneController.text = contacts[2].phoneNumber;
          fourthNameController.text = contacts[3].name;
          fourthPhoneController.text = contacts[3].phoneNumber;
          fifthNameController.text = contacts[4].name;
          fifthPhoneController.text = contacts[4].phoneNumber;
        }
        emit(state.copyWith(
            emergencyContacts: contacts, status: DashboardsStates.success));
      },
    );
  }

  editEmergencyContacts(
      BuildContext context, EmergencyContactEntity contact, int index) async {
    showLoadingDialog(context);
    final Either<Failure, EmergencyContactEntity> result =
        await editEmergencyContactsUseCase(contact);

    result.fold(
      (failure) {
        context.pop();
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (data) async {
        context.pop();
        showSuccessMessage(
            context,
            context.isArabic
                ? 'تم تعديل جهة الاتصال بنجاح'
                : 'Emergency contact edited successfully');
        List<EmergencyContactEntity> contacts = state.emergencyContacts ?? [];
        contacts.removeAt(index);
        contacts.insert(index, data);
        if (index == 0) {
          firstNameController.text = data.name;
          firstPhoneController.text = data.phoneNumber;
        } else if (index == 1) {
          secondNameController.text = data.name;
          secondPhoneController.text = data.phoneNumber;
        } else if (index == 2) {
          thirdNameController.text = data.name;
          thirdPhoneController.text = data.phoneNumber;
        } else if (index == 3) {
          fourthNameController.text = data.name;
          fourthPhoneController.text = data.phoneNumber;
        } else if (index == 4) {
          fifthNameController.text = data.name;
          fifthPhoneController.text = data.phoneNumber;
        }
        emit(state.copyWith(
            emergencyContacts: contacts, status: DashboardsStates.success));
      },
    );
  }

  TextEditingController supportDescriptionController = TextEditingController();
  TextEditingController supportPhoneController = TextEditingController();

  requestEmergencySupport({
    required BuildContext context,
    required String driverId,
    required String tripId,
    required String clientId,
  }) async {
    FocusScope.of(context).requestFocus(FocusNode());
    emit(state.copyWith(status: DashboardsStates.loadingSubmitRequest));
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
    final Either<Failure, bool> result = await emergencySupportUseCase(
        EmergencySupportParams(
            driverId: driverId,
            description: supportDescriptionController.text,
            phone: supportPhoneController.text,
            type: 'driver',
            clientId: clientId,
            latitude: currentPosition?.latitude,
            tripId: tripId,
            longitude: currentPosition?.longitude));

    result.fold(
      (failure) {
        emit(state.copyWith(status: DashboardsStates.error, failure: failure));
      },
      (data) async {
        supportDescriptionController.clear();
        supportPhoneController.clear();
        FocusScope.of(context).requestFocus(FocusNode());
        emit(state.copyWith(
            status: DashboardsStates.success,
            supportStatus: RequestEmergencyStatus.pending.status));
      },
    );
  }

  ///record trip
  final record = AudioRecorder();

  // Start recording
  Future<void> startRecord() async {
    log('startRecorddd${await record.hasPermission()}');
    try {
      if (await record.hasPermission()) {
        log('record.hasPermission');
        Directory tempDir = await getTemporaryDirectory();
        String tempPath =
            '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';
        await record.start(
          const RecordConfig(),
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

  Future<String?> stopRecord(
      {required BuildContext context,
      required String subcategoryId,
      required String tripId}) async {
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

  changeReasonSelection(
      {bool? isOther, bool? isChangedMind, bool? isClientNotShown}) {
    if (isOther == true) {
      emit(state.copyWith(
          isOtherReason: true,
          isChangedMindReason: false,
          isClientNotShownReason: false,
          status: DashboardsStates.success));
    }
    if (isChangedMind == true) {
      emit(state.copyWith(
          isOtherReason: false,
          isChangedMindReason: true,
          isClientNotShownReason: false,
          status: DashboardsStates.success));
    }
    if (isClientNotShown == true) {
      emit(state.copyWith(
          isOtherReason: false,
          isChangedMindReason: false,
          isClientNotShownReason: true,
          status: DashboardsStates.success));
    }
  }
}
