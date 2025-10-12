import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/client/unread_offers_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/cost_per_km_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_brand_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_model_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_offer_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_request_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_picture_optional_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/sub_category_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import '../../../domain/entities/driver_ratings_entity.dart';
import '../../../domain/entities/ride_category_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

enum RideStates {
  initState,
  loading,
  loadingSubmit,
  loadingSubmitSuccess,
  loadingModels,
  error,
  success,
}

extension RideStatex on RideState {
  bool get isInitial => status == RideStates.initState;
  bool get isLoading => status == RideStates.loading;
  bool get isLoadingModels => status == RideStates.loadingModels;
  bool get isLoadingSubmit => status == RideStates.loadingSubmit;
  bool get isError => status == RideStates.error;
  bool get isSuccess => status == RideStates.success;
}

class RideState {
  final RideStates status;
  final Failure? failure;
  final DriverRatingsEntity? driverRatings;
  final UnreadOffersEntity? unreadOffers;
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
   GetLocationFromAddressEntity? currentLocation;
   GetLocationFromAddressEntity? toLocation;
   GetLocationFromAddressEntity? wayPointOne;
   GetLocationFromAddressEntity? wayPointTwo;
  RideExpectedPriceEntity? rideExpectedPrice;
  RideRequestTripEntity? requestedTrip;
  final List<CompletedTripsEntity>? completedTrips;
  List<RideOfferEntity> rideOffers;
  final List<RunningTripsEntity>? runningTrips;
  final List<HistoryTripsEntity>? historyTrips;
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
  final List<TripEntity>? offers;
  final String? selectedType;
  final bool? isChangedMindReason;
  final bool? isOtherReason;
  final bool? isClientNotShownReason;
  gmap.LatLng? driverLocation;
  gmap.LatLng? previousDriverLocation;

  RideState({
    this.status = RideStates.initState,
    this.failure,
    this.driverRatings,
    this.unreadOffers,
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
    this.offers,
    this.selectedType,
    required this.rideOffers,
    this.isChangedMindReason=false,
    this.isOtherReason=false,
    this.isClientNotShownReason=false,
    this.historyTrips,
    this.driverLocation,
    this.previousDriverLocation
  });

  RideState copyWith({
    RideStates? status,
    Failure? failure,
    DriverRatingsEntity? driverRatings,
    UnreadOffersEntity? unreadOffers,
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
    GetLocationFromAddressEntity? carLocation,
    RideExpectedPriceEntity? rideExpectedPrice,
    RideRequestTripEntity? requestedTrip,
    List<CompletedTripsEntity>? completedTrips,
    List<RunningTripsEntity>? runningTrips,
    ActivityTripEntity ? activityTrips,
    String? selectedModel,
    String? selectedBrand,
    bool? isSmoking,
    String? registerType,
    List<HistoryTripsEntity>? historyTrips,
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
    List<TripEntity>? offers,
    String? selectedType,
    List<RideOfferEntity>? rideOffers,
    bool? isChangedMindReason,
    bool? isOtherReason,
    bool? isClientNotShownReason,
    gmap.LatLng? driverLocation,
    gmap.LatLng? previousDriverLocation
  }) {
    return RideState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      driverRatings: driverRatings ?? this.driverRatings,
      unreadOffers: unreadOffers ?? this.unreadOffers,
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
      offers: offers ?? this.offers,
      rideOffers: rideOffers ?? this.rideOffers,
      selectedType: selectedType ?? this.selectedType,
      isChangedMindReason: isChangedMindReason ?? this.isChangedMindReason,
      isOtherReason: isOtherReason ?? this.isOtherReason,
      isClientNotShownReason: isClientNotShownReason ?? this.isClientNotShownReason,
      historyTrips: historyTrips ?? this.historyTrips,
      driverLocation: driverLocation ?? this.driverLocation,
      previousDriverLocation: previousDriverLocation ?? this.previousDriverLocation,
    );
  }
}
