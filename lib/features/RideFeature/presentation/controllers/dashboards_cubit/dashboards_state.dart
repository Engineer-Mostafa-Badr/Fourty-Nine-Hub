part of 'dashboards_cubit.dart';

enum DashboardsStates {
  initState,
  loading,
  loadingSubmitRequest,
  loadingAcceptOffer,
  loadingAvailable,
  loadingAcceptTrip,
  loadingPast,
  loadingSettings,
  loadingCreateOffer,
  loadingRating,
  loadingModels,
  error,
  errorOffers,
  success,
  successAcceptTrip,
  successOffer,
  successRating,
}

extension DashboardsStatex on DashboardsState {
  bool get isInitial => status == DashboardsStates.initState;
  bool get isLoading => status == DashboardsStates.loading;
  bool get isLoadingSubmitRequest => status == DashboardsStates.loadingSubmitRequest;
  bool get isLoadingAcceptTrip => status == DashboardsStates.loadingAcceptTrip;
  bool get isLoadingAcceptOffer => status == DashboardsStates.loadingAcceptOffer;
  bool get isLoadingModels => status == DashboardsStates.loadingModels;
  bool get isLoadingAvailable => status == DashboardsStates.loadingAvailable;
  bool get isLoadingPast => status == DashboardsStates.loadingPast;
  bool get isLoadingSettings => status == DashboardsStates.loadingSettings;
  bool get isLoadingCreateOffer => status == DashboardsStates.loadingCreateOffer;
  bool get isLoadingRating => status == DashboardsStates.loadingRating;
  bool get isError => status == DashboardsStates.error;
  bool get isErrorOffers => status == DashboardsStates.errorOffers;
  bool get isSuccess => status == DashboardsStates.success;
  bool get isSuccessOffer => status == DashboardsStates.successOffer;
  bool get isSuccessRating => status == DashboardsStates.successRating;
  bool get isSuccessAcceptTrip => status == DashboardsStates.successAcceptTrip;
}

class DashboardsState
// extends Equatable
{
  final DashboardsStates status;
  final Failure? failure;
  final List<TripEntity>? availableTrips;
  final List<TripEntity>? pastTrips;
  final SettingsDashboardEntity? settings;
  final int? currentIndex;
  final List<AvailableRideTripEntity>? availableRideTrips;
  final String? tripStatus;
  final String? lastStatus;
  final bool? isChangedMindReason;
  final bool? isOtherReason;
  final bool? isClientNotShownReason;
  final List<AvailableRideNonSocketTripEntity>? availableRideNonSocketTrips;
  final List<AcceptedRideNonSocketTripEntity>? acceptedRideNonSocketTrips;
  final List<HistoryTripEntity>? pastRideNonSocketTrips;
  final List<EmergencyContactEntity>? emergencyContacts;
  final SupportDetailsEntity? supportDetails;
  final DateTime? remainingTime;
      final String? supportStatus;
  final CreateNonTrackOfferEntity? createNonTrackOfferEntity;
  final bool? offerCreatedShown;
  final UpdateDriverSettingsEntity? updateDriverSettingsEntity;
  final DriverSettingsEntity? driverSettingsEntity;
  final XFile? personalFrontIdPicture;
  final XFile? personalBackIdPicture;
  final XFile? personalCriminalRecordPicture;
  final XFile? personalDrugAnalysisPicture;
  final XFile? driverLicensePicture;
  final XFile? backOfDriverLicensePicture;
  final XFile? selfieDriverLicensePicture;
  final RateResponseEntity? rateResponseEntity;
  final XFile? vehiclePicture;
  final XFile? vehicleFrontPicture;
  final XFile? vehicleBackPicture;
  final XFile? personalTechnicalExaminationPicture;
  final List<GetLoadingAcceptedEntity>? loadingAcceptedNonSocket;
  final List<GetLoadingAvailableEntity >? loadingAvailableNonSocket;
  final List<GetLoadingHistoryEntity>? loadingHistoryNonSocket;
  final List<GovernorateEntity>? govs;
  final GovernorateEntity? selectedGov;
  final Duration? recordPosition;
  final PlayerState? playerState;
  final Duration? recordDuration;
  final DriverSettingLoadingEntity? driverSettingLoadingEntity;
  const DashboardsState(
      {this.failure,
      this.pastTrips,
      this.settings,
      this.recordPosition,
      this.currentIndex=0,
      this.status = DashboardsStates.initState,
      this.availableTrips,
      this.availableRideTrips,
      this.availableRideNonSocketTrips,
      this.acceptedRideNonSocketTrips,
      this.pastRideNonSocketTrips,
      this.tripStatus,
      this.remainingTime,
      this.lastStatus,
      this.supportDetails,
      this.supportStatus,
      this.emergencyContacts,
      this.isChangedMindReason=false,
      this.isOtherReason=false,
      this.isClientNotShownReason=false,
      this.createNonTrackOfferEntity,
        this.offerCreatedShown = false,
        this.updateDriverSettingsEntity ,
        this.driverSettingsEntity ,
        this.personalFrontIdPicture,
        this.personalBackIdPicture,
        this.personalCriminalRecordPicture,
        this.personalDrugAnalysisPicture,
        this.driverLicensePicture,
        this.backOfDriverLicensePicture,
        this.selfieDriverLicensePicture,
        this.rateResponseEntity,
        this.vehiclePicture,
        this.vehicleFrontPicture,
        this.vehicleBackPicture,
        this.personalTechnicalExaminationPicture,
        this.selectedGov,
        this.govs,
        this.playerState,
        this.recordDuration,
        this.loadingAcceptedNonSocket,
        this.loadingAvailableNonSocket,
        this.loadingHistoryNonSocket,
        this.driverSettingLoadingEntity,
      });
  DashboardsState copyWith(
      {DashboardsStates? status,
      Failure? failure,
      List<TripEntity>? pastTrips,
      List<TripEntity>? availableTrips,
      List<AvailableRideTripEntity>? availableRideTrips,
      SettingsDashboardEntity? settings,
      int? currentIndex,
        String? tripStatus,
        DateTime? remainingTime,
        String? lastStatus,
        bool? isChangedMindReason,
        bool? isOtherReason,
        bool? isClientNotShownReason,
        SupportDetailsEntity? supportDetails,
        List<EmergencyContactEntity>? emergencyContacts,
        String? supportStatus,
        List<AvailableRideNonSocketTripEntity>? availableRideNonSocketTrips,
        List<AcceptedRideNonSocketTripEntity>? acceptedRideNonSocketTrips,
        List<HistoryTripEntity >? pastRideNonSocketTrips,
        CreateNonTrackOfferEntity? createNonTrackOfferEntity,
        bool? offerCreatedShown,
        UpdateDriverSettingsEntity? updateDriverSettingsEntity,
        DriverSettingsEntity? driverSettingsEntity,
        XFile? personalBackIdPicture,
        XFile? personalFrontIdPicture,
        XFile? personalCriminalRecordPicture,
        XFile? personalDrugAnalysisPicture,
        XFile? driverLicensePicture,
        XFile? backOfDriverLicensePicture,
        XFile? selfieDriverLicensePicture,
        RateResponseEntity? rateResponseEntity,
        List<GovernorateEntity>? govs,
        GovernorateEntity? selectedGov,

        XFile? vehiclePicture,
        XFile? vehicleFrontPicture,
         XFile? vehicleBackPicture,
        XFile? personalTechnicalExaminationPicture,
        Duration? recordPosition,
        Duration? recordDuration,
        PlayerState? playerState,

        List<GetLoadingAcceptedEntity>? loadingAcceptedNonSocket,
        List<GetLoadingAvailableEntity>? loadingAvailableNonSocket,
        List<GetLoadingHistoryEntity>? loadingHistoryNonSocket,

        DriverSettingLoadingEntity? driverSettingLoadingEntity,
      }) {
    return DashboardsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      pastTrips: pastTrips ?? this.pastTrips,
      settings: settings ?? this.settings,
      currentIndex: currentIndex ?? this.currentIndex,
      availableTrips: availableTrips ?? this.availableTrips,
      availableRideTrips: availableRideTrips ?? this.availableRideTrips,
      availableRideNonSocketTrips: availableRideNonSocketTrips ?? this.availableRideNonSocketTrips,
      acceptedRideNonSocketTrips: acceptedRideNonSocketTrips ?? this.acceptedRideNonSocketTrips,
      pastRideNonSocketTrips: pastRideNonSocketTrips ?? this.pastRideNonSocketTrips,
      tripStatus: tripStatus ?? this.tripStatus,
      lastStatus: lastStatus ?? this.lastStatus,
      isChangedMindReason: isChangedMindReason ?? this.isChangedMindReason,
      isOtherReason: isOtherReason ?? this.isOtherReason,
      isClientNotShownReason: isClientNotShownReason ?? this.isClientNotShownReason,
      supportStatus: supportStatus ?? this.supportStatus,
      supportDetails: supportDetails ?? this.supportDetails,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      createNonTrackOfferEntity: createNonTrackOfferEntity ?? this.createNonTrackOfferEntity,
      offerCreatedShown: offerCreatedShown ?? this.offerCreatedShown,
      updateDriverSettingsEntity: updateDriverSettingsEntity ?? this.updateDriverSettingsEntity,
      driverSettingsEntity: driverSettingsEntity ?? this.driverSettingsEntity,
      personalFrontIdPicture: personalFrontIdPicture ?? this.personalFrontIdPicture,
      personalBackIdPicture: personalBackIdPicture ?? this.personalBackIdPicture,
      personalCriminalRecordPicture: personalCriminalRecordPicture ?? this.personalCriminalRecordPicture,
      personalDrugAnalysisPicture: personalDrugAnalysisPicture ?? this.personalDrugAnalysisPicture,
      driverLicensePicture: driverLicensePicture ?? this.driverLicensePicture,
      backOfDriverLicensePicture: backOfDriverLicensePicture ?? this.backOfDriverLicensePicture,
      selfieDriverLicensePicture: selfieDriverLicensePicture ?? this.selfieDriverLicensePicture,
      remainingTime: remainingTime ?? this.remainingTime,
      rateResponseEntity: rateResponseEntity ?? this.rateResponseEntity,
      vehiclePicture: vehiclePicture ?? this.vehiclePicture,
      vehicleFrontPicture: vehicleFrontPicture ?? this.vehicleFrontPicture,
      vehicleBackPicture: vehicleBackPicture ?? this.vehicleBackPicture,
      personalTechnicalExaminationPicture: personalTechnicalExaminationPicture ?? this.personalTechnicalExaminationPicture,
      govs: govs ?? this.govs,
      selectedGov: selectedGov ?? this.selectedGov,
      recordPosition: recordPosition ?? this.recordPosition,
      recordDuration: recordDuration ?? this.recordDuration,
      playerState: playerState ?? this.playerState,
      loadingAcceptedNonSocket: loadingAcceptedNonSocket ?? this.loadingAcceptedNonSocket,
      loadingAvailableNonSocket: loadingAvailableNonSocket ?? this.loadingAvailableNonSocket,
      loadingHistoryNonSocket: loadingHistoryNonSocket ?? this.loadingHistoryNonSocket,
      driverSettingLoadingEntity: driverSettingLoadingEntity ?? this.driverSettingLoadingEntity,
    );
  }

  // @override
  // List<Object> get props => [status, failure!, availableTrips!];
}

// final class DashboardsInitial extends DashboardsState {
//   DashboardsInitial(super.status);
// }
