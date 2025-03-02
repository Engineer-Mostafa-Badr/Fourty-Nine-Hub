import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/ride_category_entity.dart';

enum RideStates {
  initState,
  loading,
  error,
  success,
}

extension RideStatex on RideState {
  bool get isInitial => status == RideStates.initState;
  bool get isLoading => status == RideStates.loading;
  bool get isError => status == RideStates.error;
  bool get isSuccess => status == RideStates.success;
}

class RideState {
  final RideStates status;
  final Failure? failure;
  final XFile? personalPicture;
  final XFile? driverLicensePicture;
  final XFile? backOfDriverLicensePicture;
  final XFile? selfieDriverLicensePicture;
  final XFile? personalFrontIdPicture;
  final XFile? personalBackIdPicture;
  final XFile? personalCriminalRecordPicture;
  final XFile? personalDrugAnalysisPicture;
  final XFile? vehicleFrontPicture;
  final XFile? vehicleBackPicture;
  final XFile? vehiclePicture;
  final RideCategoryEntityUpdated? rideCategory;
  final RideCategoryEntityUpdated? shippingCategory;
  final List<SubCategoryEntityUpdated>? rideSubCategories;
  final List<GovernorateEntity>? govs;
  final List<RideColorEntity>? colors;
  final List<String>? brands;
  final List<String>? models;

  const RideState({
    this.status = RideStates.initState,
    this.failure,
    this.personalPicture,
    this.driverLicensePicture,
    this.backOfDriverLicensePicture,
    this.selfieDriverLicensePicture,
    this.personalFrontIdPicture,
    this.personalBackIdPicture,
    this.personalCriminalRecordPicture,
    this.personalDrugAnalysisPicture,
    this.vehicleFrontPicture,
    this.vehicleBackPicture,
    this.vehiclePicture,
    this.rideCategory,
    this.rideSubCategories,
    this.shippingCategory,
    this.govs,
    this.brands,
    this.models,
    this.colors,
  });

  RideState copyWith({
    RideStates? status,
    Failure? failure,
    XFile? personalPicture,
    XFile? driverLicensePicture,
    XFile? backOfDriverLicensePicture,
    XFile? selfieDriverLicensePicture,
    XFile? personalFrontIdPicture,
    XFile? personalBackIdPicture,
    XFile? personalCriminalRecordPicture,
    XFile? personalDrugAnalysisPicture,
    XFile? vehicleFrontPicture,
    XFile? vehicleBackPicture,
    XFile? vehiclePicture,
    RideCategoryEntityUpdated? rideCategory,
    List<SubCategoryEntityUpdated>? rideSubCategories,
    List<GovernorateEntity>? govs,
    List<String>? brands,
    List<String>? models,
    List<RideColorEntity>? colors,
    RideCategoryEntityUpdated? shippingCategory,
  }) {
    return RideState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      personalPicture: personalPicture ?? this.personalPicture,
      driverLicensePicture: driverLicensePicture ?? this.driverLicensePicture,
      backOfDriverLicensePicture: backOfDriverLicensePicture ?? this.backOfDriverLicensePicture,
      selfieDriverLicensePicture: selfieDriverLicensePicture ?? this.selfieDriverLicensePicture,
      personalFrontIdPicture: personalFrontIdPicture ?? this.personalFrontIdPicture,
      personalBackIdPicture: personalBackIdPicture ?? this.personalBackIdPicture,
      personalCriminalRecordPicture: personalCriminalRecordPicture ?? this.personalCriminalRecordPicture,
      personalDrugAnalysisPicture: personalDrugAnalysisPicture ?? this.personalDrugAnalysisPicture,
      vehicleFrontPicture: vehicleFrontPicture ?? this.vehicleFrontPicture,
      vehicleBackPicture: vehicleBackPicture ?? this.vehicleBackPicture,
      vehiclePicture: vehiclePicture ?? this.vehiclePicture,
      rideCategory: rideCategory ?? this.rideCategory,
      shippingCategory: shippingCategory ?? this.shippingCategory,
      rideSubCategories: rideSubCategories ?? this.rideSubCategories,
      govs: govs ?? this.govs,
      brands: brands ?? this.brands,
      models: models ?? this.models,
      colors: colors ?? this.colors,
    );
  }
}
