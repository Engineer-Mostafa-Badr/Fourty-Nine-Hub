part of 'ride_register_cubit.dart';

enum RideRegisterStates {
  initState,
  loading,
  loadingSubmit,
  loadingSubmitSuccess,
  loadingModels,
  error,
  success,
}

extension RideRegisterStatex on RideRegisterState {
  bool get isInitial => status == RideRegisterStates.initState;
  bool get isLoading => status == RideRegisterStates.loading;
  bool get isLoadingModels => status == RideRegisterStates.loadingModels;
  bool get isLoadingSubmit => status == RideRegisterStates.loadingSubmit;
  bool get isError => status == RideRegisterStates.error;
  bool get isSuccess => status == RideRegisterStates.success;
}

class RideRegisterState {
  final RideRegisterStates status;
  final Failure? failure;
  final XFile? personalPicture;
  final XFile? driverLicensePicture;
  final XFile? backOfDriverLicensePicture;
  final XFile? selfieDriverLicensePicture;
  final XFile? personalFrontIdPicture;
  final XFile? personalBackIdPicture;
  final XFile? personalCriminalRecordPicture;
  final XFile? personalDrugAnalysisPicture;
  final XFile? personalTechnicalExaminationPicture;
  final XFile? vehicleFrontPicture;
  final XFile? vehicleBackPicture;
  final XFile? vehiclePicture;
  final RideCategoryEntityUpdated? rideCategory;
  final RideCategoryEntityUpdated? shippingCategory;
  final List<GovernorateEntity>? governorates;
  final GetLocationFromAddressEntity? currentLocation;
  final GetLocationFromAddressEntity? toLocation;
  final GetLocationFromAddressEntity? wayPointOne;
  final GetLocationFromAddressEntity? wayPointTwo;
  final RideExpectedPriceEntity? rideExpectedPrice;
  RideRequestTripEntity? requestedTrip;
  final List<CompletedTripsEntity>? completedTrips;
  final List<RunningTripsEntity>? runningTrips;
  final ActivityTripEntity ? activityTrips;
  final List<SubCategoryEntityUpdated>? rideSubCategories;
  final List<SubCategoryEntityUpdated>? shippingSubCategories;
  final List<GovernorateEntity>? govs;
  final List<RideColorEntity>? colors;
  final RideColorEntity? color;
  final GovernorateEntity? city;
  final List<RideBrandEntity>? brands;
  final List<RideModelEntity>? models;
  final String? selectedModel;
  final String? selectedBrand;
  final bool? isSmoking;
  final bool? hasAirCondition;
  final RideColorEntity? selectedColors;
  final String? selectedGov;
  final String? registerType;
  final String? selectedPlan;
  final DriverInfoEntity? driverInfo;
  final LoadingInfoEntity? loaderInfo;
  final DriverPictureOptionalEntity? pictureOptional;
  final List<String>? savedRideSubCategories;
  final bool? isApproved;
  final bool? isUploadDriverId;
  final bool? isUploadDriverImage;
  final bool? isUploadDriverLicense;
  final bool? isUploadConfirmIdentifier;
  final bool? isUploadCarImage;
  final bool? isUploadCarLicense;
  final bool? isUploadDrugAnalysis;
  final bool? isUploadCriminalRecord;
  final bool? isUploadTechnicalExamination;
  final bool? isShipping;
  final CostPerKmEntity? costPerKm;

  RideRegisterState({
    this.status = RideRegisterStates.initState,
    this.failure,
    this.personalPicture,
    this.driverLicensePicture,
    this.backOfDriverLicensePicture,
    this.selfieDriverLicensePicture,
    this.personalFrontIdPicture,
    this.personalBackIdPicture,
    this.personalCriminalRecordPicture,
    this.personalDrugAnalysisPicture,
    this.personalTechnicalExaminationPicture,
    this.vehicleFrontPicture,
    this.vehicleBackPicture,
    this.vehiclePicture,
    this.rideCategory,
    this.loaderInfo,
    this.savedRideSubCategories,
    this.rideSubCategories,
    this.shippingSubCategories,
    this.shippingCategory,
    this.governorates,
    this.currentLocation,
    this.toLocation,
    this.wayPointOne,
    this.wayPointTwo,
    this.rideExpectedPrice,
    this.requestedTrip,
    this.completedTrips,
    this.runningTrips,
    this.costPerKm,
    this.activityTrips,
    this.govs,
    this.brands,
    this.models,
    this.registerType='socket',
    this.driverInfo,
    this.colors,
    this.color,
    this.city,
    this.isSmoking=false,
    this.hasAirCondition=false,
    this.selectedModel,
    this.selectedBrand,
    this.selectedColors,
    this.selectedGov,
    this.selectedPlan,
    this.pictureOptional,
    this.isApproved,
    this.isUploadDriverId,
    this.isUploadDriverImage,
    this.isUploadDriverLicense,
    this.isUploadConfirmIdentifier,
    this.isUploadCarImage,
    this.isUploadCarLicense,
    this.isUploadDrugAnalysis,
    this.isUploadCriminalRecord,
    this.isUploadTechnicalExamination,
    this.isShipping,
  });

  RideRegisterState copyWith({
    RideRegisterStates? status,
    Failure? failure,
    XFile? personalPicture,
    XFile? driverLicensePicture,
    XFile? backOfDriverLicensePicture,
    XFile? selfieDriverLicensePicture,
    XFile? personalFrontIdPicture,
    XFile? personalBackIdPicture,
    XFile? personalCriminalRecordPicture,
    XFile? personalDrugAnalysisPicture,
    XFile? personalTechnicalExaminationPicture,
    XFile? vehicleFrontPicture,
    XFile? vehicleBackPicture,
    XFile? vehiclePicture,
    RideCategoryEntityUpdated? rideCategory,
    DriverInfoEntity? driverInfo,
    LoadingInfoEntity? loaderInfo,
    DriverPictureOptionalEntity? pictureOptional,
    List<SubCategoryEntityUpdated>? rideSubCategories,
    List<String>? savedRideSubCategories,
    List<SubCategoryEntityUpdated>? shippingSubCategories,
    List<GovernorateEntity>? govs,
    List<RideBrandEntity>? brands,
    List<RideModelEntity>? models,
    CostPerKmEntity? costPerKm,
    List<RideColorEntity>? colors,
    RideColorEntity? color,
    RideCategoryEntityUpdated? shippingCategory,
    List<GovernorateEntity>? governorates,
    GovernorateEntity? city,
    GetLocationFromAddressEntity? currentLocation,
    GetLocationFromAddressEntity? toLocation,
    GetLocationFromAddressEntity? wayPointOne,
    GetLocationFromAddressEntity? wayPointTwo,
    RideExpectedPriceEntity? rideExpectedPrice,
    RideRequestTripEntity? requestedTrip,
    List<CompletedTripsEntity>? completedTrips,
    List<RunningTripsEntity>? runningTrips,
    ActivityTripEntity ? activityTrips,
    String? selectedModel,
    String? selectedBrand,
    bool? isSmoking,
    String? registerType,
    bool? isShipping,
    bool? hasAirCondition,
    RideColorEntity? selectedColors,
    String? selectedGov,
    String? selectedPlan,
    bool? isApproved,
    bool? isUploadDriverId,
    bool? isUploadDriverImage,
    bool? isUploadDriverLicense,
    bool? isUploadConfirmIdentifier,
    bool? isUploadCarImage,
    bool? isUploadCarLicense,
    bool? isUploadDrugAnalysis,
    bool? isUploadCriminalRecord,
    bool? isUploadTechnicalExamination,
  }) {
    return RideRegisterState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      registerType: registerType ?? this.registerType,
      personalPicture: personalPicture ?? this.personalPicture,
      color: color ?? this.color,
      city: city ?? this.city,
      driverLicensePicture: driverLicensePicture ?? this.driverLicensePicture,
      backOfDriverLicensePicture: backOfDriverLicensePicture ?? this.backOfDriverLicensePicture,
      selfieDriverLicensePicture: selfieDriverLicensePicture ?? this.selfieDriverLicensePicture,
      personalFrontIdPicture: personalFrontIdPicture ?? this.personalFrontIdPicture,
      personalBackIdPicture: personalBackIdPicture ?? this.personalBackIdPicture,
      personalCriminalRecordPicture: personalCriminalRecordPicture ?? this.personalCriminalRecordPicture,
      personalDrugAnalysisPicture: personalDrugAnalysisPicture ?? this.personalDrugAnalysisPicture,
      personalTechnicalExaminationPicture: personalTechnicalExaminationPicture ?? this.personalTechnicalExaminationPicture,
      vehicleFrontPicture: vehicleFrontPicture ?? this.vehicleFrontPicture,
      vehicleBackPicture: vehicleBackPicture ?? this.vehicleBackPicture,
      vehiclePicture: vehiclePicture ?? this.vehiclePicture,
      rideCategory: rideCategory ?? this.rideCategory,
      shippingCategory: shippingCategory ?? this.shippingCategory,
      rideSubCategories: rideSubCategories ?? this.rideSubCategories,
      driverInfo: driverInfo ?? this.driverInfo,
      govs: govs ?? this.govs,
      brands: brands ?? this.brands,
      models: models ?? this.models,
      colors: colors ?? this.colors,
      isSmoking: isSmoking ?? this.isSmoking,
      hasAirCondition: hasAirCondition ?? this.hasAirCondition,
      selectedModel: selectedModel ?? this.selectedModel,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedColors: selectedColors ?? this.selectedColors,
      selectedGov: selectedGov ?? this.selectedGov,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      pictureOptional: pictureOptional ?? this.pictureOptional,
      isApproved: isApproved ?? this.isApproved,
      isUploadDriverId: isUploadDriverId ?? this.isUploadDriverId,
      isUploadDriverImage: isUploadDriverImage ?? this.isUploadDriverImage,
      isUploadDriverLicense: isUploadDriverLicense ?? this.isUploadDriverLicense,
      isUploadConfirmIdentifier: isUploadConfirmIdentifier ?? this.isUploadConfirmIdentifier,
      isUploadCarImage: isUploadCarImage ?? this.isUploadCarImage,
      isUploadCarLicense: isUploadCarLicense ?? this.isUploadCarLicense,
      isUploadDrugAnalysis: isUploadDrugAnalysis ?? this.isUploadDrugAnalysis,
      isUploadCriminalRecord: isUploadCriminalRecord ?? this.isUploadCriminalRecord,
      isUploadTechnicalExamination: isUploadTechnicalExamination ?? this.isUploadTechnicalExamination,
      governorates: governorates ?? this.governorates,
      currentLocation: currentLocation ?? this.currentLocation,
      toLocation: toLocation ?? this.toLocation,
      wayPointOne: wayPointOne ?? this.wayPointOne,
      wayPointTwo: wayPointTwo ?? this.wayPointTwo,
      rideExpectedPrice: rideExpectedPrice ?? this.rideExpectedPrice,
      requestedTrip: requestedTrip ?? this.requestedTrip,
      completedTrips: completedTrips ?? this.completedTrips,
      runningTrips: runningTrips ?? this.runningTrips,
      activityTrips: activityTrips ?? this.activityTrips,
      costPerKm: costPerKm ?? this.costPerKm,
      shippingSubCategories: shippingSubCategories ?? this.shippingSubCategories,
      isShipping: isShipping ?? this.isShipping,
      loaderInfo: loaderInfo ?? this.loaderInfo,
      savedRideSubCategories: savedRideSubCategories ?? this.savedRideSubCategories,
    );
  }
}
