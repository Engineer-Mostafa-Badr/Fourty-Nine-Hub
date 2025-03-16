import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_image.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/loading_method_helper.dart';
import 'package:fourtyninehub/core/utils/ride_method_helper.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/cost_per_km_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_picture_optional_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_register_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_cost_per_km_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_driver_picture_optional.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_loading_info_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_brands_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_car_colors_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_driver_information.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_governorates.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_models_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_activity_trips.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_completed_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_running_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_location_from_address_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_expexted_price_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_shipping_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/loading_register_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/register_ride_not_special_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/register_ride_special_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/upload_rider_images.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/ride_category_entity.dart';
import '../../../domain/usecases/get_ride_categories_usecase.dart';

class RideCubit extends Cubit<RideState> {
  bool isComfort = false;
  bool isComfortIsAdded = false;
  bool isNonSmoker = false;
  bool isNonSmokerIsAdded = false;
  bool isAutoAccept = false;
  bool isAutoAcceptIsAdded = false;
  bool isRecord = false;

  final GetRideCategoriesUseCase getRideCategories;
  final GetShippingCategoriesUsecase getShippingCategoriesUsecase;
  final GetRideGovernoratesUseCase getRideGovernoratesUseCase;
  final GetRideBrandsUseCase getRideBrandsUseCase;
  final GetRideModelsUseCase getRideModelsUseCase;
  final GetRideCarColorsUseCase getRideCarColorsUseCase;
  final RegisterRideSpecialUseCase registerRideSpecialUseCase;
  final RegisterRideNotSpecialUseCase registerRideNotSpecialUseCase;
  final GetRideDriverInfoUseCase getRideDriverInfoUseCase;
  final GetDriverPictureOptionalUseCase getDriverPictureOptionalUseCase;
  final GetLocationFromAddressUseCase getLocationFromAddressUseCase;
  final GetRideExpectedPriceUseCase getRideExpectedPriceUseCase;
  final GetAllCompletedTripsUseCase getAllCompletedTripsUseCase;
  final GetAllRunningTripsUseCase getAllRunningTripsUseCase;
  final GetAllActivityTripsUseCase getAllActivityTripsUseCase;
  final GetCostPerKmUseCase getCostPerKmUseCase;
  final LoadingRegisterUseCase loadingRegisterUseCase;
  final GetLoadingInfoUseCase getLoadingInfoUseCase;

  RideCubit(
    this.getRideCategories,
    this.getShippingCategoriesUsecase,
    this.getRideGovernoratesUseCase,
    this.getRideBrandsUseCase,
    this.getRideModelsUseCase,
    this.getRideCarColorsUseCase,
    this.registerRideSpecialUseCase,
    this.registerRideNotSpecialUseCase,
    this.getRideDriverInfoUseCase,
    this.getDriverPictureOptionalUseCase,
    this.getLocationFromAddressUseCase,
    this.getRideExpectedPriceUseCase,
    this.getAllCompletedTripsUseCase,
    this.getAllRunningTripsUseCase,
    this.getAllActivityTripsUseCase,
    this.getCostPerKmUseCase,
    this.loadingRegisterUseCase,
    this.getLoadingInfoUseCase,
  ) : super(const RideState());

  bool loadingHomeData = false;
  Future<void> initHome(BuildContext context) async {
    loadingHomeData=true;
    emit(state.copyWith(status: RideStates.loading));
    await Future.wait([
      _fetchUserLocation(),
      _fetchUserLocation(),
      fetchRideDriverInfo(context),
      getCostPerKm(),
    fetchLoaderInfo(context),
    fetchRideDriverPictureOptional(context),
    fetchRideCategories(UserCubit.to.state.data?.id ?? "", context),
    fetchShippingCategories(UserCubit.to.state.data?.id ?? ""),
    fetchRideGovernorates(),
    ]);
    loadingHomeData=false;
    emit(state.copyWith(status: RideStates.success));
  }

  Future<void> _fetchUserLocation() async {
    emit(state.copyWith(status: RideStates.loading));

    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      String address = placemarks.isNotEmpty ? "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}" : "Unknown current Location";

      GetLocationFromAddressEntity currentLocation = GetLocationFromAddressEntity(
        lat: position.latitude,
        lng: position.longitude,
        address: address,
      );

      emit(state.copyWith(status: RideStates.success, currentLocation: currentLocation));
    } catch (e) {
      emit(state.copyWith(status: RideStates.error));
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  final formKey = GlobalKey<FormState>();
  final idFormKey = GlobalKey<FormState>();
  final carLicenseFormKey = GlobalKey<FormState>();
  final driverLicenseFormKey = GlobalKey<FormState>();
  final drugAnalysisFormKey = GlobalKey<FormState>();
  final criminalRecordFormKey = GlobalKey<FormState>();
  final terminalExaminationFormKey = GlobalKey<FormState>();
  TextEditingController rideNameController = TextEditingController();
  TextEditingController rideSurNameController = TextEditingController();
  TextEditingController rideDateOfBirthController = TextEditingController();
  TextEditingController ridePhoneNumberController = TextEditingController();
  TextEditingController rideDriverLicenseNumController = TextEditingController();
  TextEditingController rideDriverExpireDateController = TextEditingController();
  TextEditingController ridePersonalDocLicenseNumController = TextEditingController();
  TextEditingController ridePersonalDocIdNumController = TextEditingController();
  TextEditingController ridePersonalDocExpireDateController = TextEditingController();
  TextEditingController rideVehicleLicenseNumController = TextEditingController();
  TextEditingController rideVehicleExpireDateController = TextEditingController();
  TextEditingController rideDragAnalysisExpireDateController = TextEditingController();
  TextEditingController rideTechnicalExaminationExpireDateController = TextEditingController();
  TextEditingController rideCriminalRecordExpireDateController = TextEditingController();
  TextEditingController rideVehicleProductionYearController = TextEditingController();
  TextEditingController rideVehiclePlateNumberController = TextEditingController();
  TextEditingController ridePricingPerKmController = TextEditingController();
  TextEditingController rideCarModelController = TextEditingController();

  Future<void> fetchRideCategories(String userId, BuildContext context) async {
    if (isClosed) return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result = await getRideCategories(userId);

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (rideCategory) {
        emit(state.copyWith(status: RideStates.success, rideCategory: rideCategory, rideSubCategories: rideCategory.subCategories));
      },
    );
  }

  Future<void> getCostPerKm() async {
    if (isClosed) return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, CostPerKmEntity> result = await getCostPerKmUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
      (data) {
        emit(state.copyWith(status: RideStates.success, costPerKm: data));
      },
    );
  }

  Future<void> fetchRideDriverInfo(BuildContext context) async {
    if (isClosed) return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, DriverInfoEntity> result = await getRideDriverInfoUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (info) {
        emit(state.copyWith(
          status: RideStates.success,
          driverInfo: info,
          isApproved: info.isApproved,
          isUploadCarImage: info.isUploadCarImage,
          isUploadDriverId: info.isUploadDriverId,
          isUploadDriverImage: info.isUploadDriverImage,
          isUploadDriverLicense: info.isUploadDriverLicense,
          isUploadConfirmIdentifier: info.isUploadConfirmIdentifier,
          isUploadCarLicense: info.isUploadCarLicense,
          isUploadDrugAnalysis: info.isUploadDrugAnalysis,
          isUploadCriminalRecord: info.isUploadCriminalRecord,
          isUploadTechnicalExamination: info.isUploadTechnicalExamination,
          registerType: info.driverType=='socket'?'socket':'noSocket',
            isShipping: false
        ));
      },
    );
  }

  Future<void> fetchLoaderInfo(BuildContext context) async {
    if (isClosed) return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, LoadingInfoEntity> result = await getLoadingInfoUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (info) {
        emit(state.copyWith(
          status: RideStates.success,
          loaderInfo: info,
          registerType: 'noSocket',
          isShipping: true
        ));
      },
    );
  }

  fetchRideUploadedImagesData(BuildContext context, UploadRiderImagesParams? params) async {
    if(params!=null)emit(state.copyWith(isShipping: params.isShipping,registerType: params.isSocket==true?'socket':'noSocket'));
    emit(state.copyWith(status: RideStates.loading));
    await Future.wait([fetchRideDriverPictureOptional(context),
      (state.isShipping==true||params?.isShipping==true)?fetchLoaderInfo(context):fetchRideDriverInfo(context)]);
    emit(state.copyWith(status: RideStates.success));
  }

  Future<void> fetchRideDriverPictureOptional(BuildContext context) async {
    if (isClosed) return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, DriverPictureOptionalEntity> result = await getDriverPictureOptionalUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (data) {
        emit(state.copyWith(status: RideStates.success, pictureOptional: data));
      },
    );
  }

  Future<void> fetchShippingCategories(String userId) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result = await getShippingCategoriesUsecase(userId);

    result.fold(
      (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
      (rideCategory) => emit(state.copyWith(status: RideStates.success, shippingCategory: rideCategory, shippingSubCategories: rideCategory.subCategories)),
    );
  }

  Future<void> fetchRideGovernorates() async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, List<GovernorateEntity>> result = await getRideGovernoratesUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
      (governorates) => emit(state.copyWith(status: RideStates.success, governorates: governorates)),
    );
  }

  Future<void> fetchRideExpectedPrice({required String id}) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideExpectedPriceEntity> result = await getRideExpectedPriceUseCase(
      RideExpectedPriceParams(
          startLocation: [state.currentLocation!.lat!, state.currentLocation!.lng!], targetLocation: [state.toLocation!.lat!, state.toLocation!.lng!], comfort: false, id: id),
    );

    log(result.toString());

    result.fold(
      (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
      (rideExpectedPrice) => emit(state.copyWith(status: RideStates.success, rideExpectedPrice: rideExpectedPrice)),
    );
  }

  Future<void> fetchAllCompletedTrips({required int limit, required int page}) async {
    //emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, List<CompletedTripsEntity>> result = await getAllCompletedTripsUseCase(GetAllCompletedTripsUseCaseParams(limit, page));

    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (completedTrips) {
        final List<CompletedTripsEntity> updatedTrips = page == 1 ? completedTrips : [...?state.completedTrips, ...completedTrips];

        emit(state.copyWith(status: RideStates.success, completedTrips: updatedTrips));
      },
    );
  }

  Future<void> fetchAllRunningTrips({required int limit, required int page}) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, List<RunningTripsEntity>> result = await getAllRunningTripsUseCase(GetAllRunningTripsUseCaseParams(limit, page));

    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (runningTrips) {
        final List<RunningTripsEntity> updatedTrips = page == 1 ? runningTrips : [...?state.runningTrips, ...runningTrips];

        emit(state.copyWith(status: RideStates.success, runningTrips: updatedTrips));
      },
    );
  }

  Future<void> fetchAllActivityTrips({required int limit, required int page}) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, ActivityTripEntity> result = await getAllActivityTripsUseCase(GetAllActivityTripsUseCaseParams(limit: limit, page: page));
    result.fold(
      (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
      (activityTrips) => emit(state.copyWith(status: RideStates.success, activityTrips: activityTrips)),
    );
  }

  void updateFromLocation({required double lat, required double lng, required String address}) {
    GetLocationFromAddressEntity currentLocation = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );

    emit(state.copyWith(status: RideStates.success, currentLocation: currentLocation));
  }

  void emitRefreshState() {
    emit(state.copyWith(status: RideStates.success));
  }

  void updateToLocation({required double lat, required double lng, required String address}) {
    GetLocationFromAddressEntity toLocation = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );

    emit(state.copyWith(status: RideStates.success, toLocation: toLocation));
  }

  loadRegisterData(BuildContext context) async {
    emit(state.copyWith(status: RideStates.loading));
    await Future.wait([fetchGovs(), fetchBrands(), fetchColors(context)]);
    emit(state.copyWith(status: RideStates.success));
  }

  Future<void> fetchGovs() async {
    final Either<Failure, List<GovernorateEntity>> result = await getRideGovernoratesUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
      (governorates) => emit(state.copyWith(status: RideStates.success, govs: governorates)),
    );
  }

  Future<void> fetchBrands() async {
    final Either<Failure, List<String>> result = await getRideBrandsUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
      (data) => emit(state.copyWith(status: RideStates.success, brands: data)),
    );
  }

  List<String> subscriptionPlans = [
    'Percentage',
    'Subscribe Package',
  ];

  List<String> models = [];
  onSelectBrand(String brand, BuildContext context) async {
    if (brand == state.selectedBrand) return;
    emit(state.copyWith(selectedBrand: brand, selectedModel: '', status: RideStates.loadingModels));
    await fetchModels(brand, context);
    emit(state.copyWith(status: RideStates.success));
  }

  onSelectModel(String model) {
    emit(state.copyWith(selectedModel: model, status: RideStates.success));
  }

  onSelectColor(RideColorEntity color) {
    emit(state.copyWith(selectedColors: color, status: RideStates.success));
  }

  onSelectGov(String gov) {
    emit(state.copyWith(selectedGov: gov, status: RideStates.success));
  }

  onSelectPlan(String plan) {
    String selectedPlan = plan == 'Percentage' ? 'percentage' : 'subscribePackage';
    emit(state.copyWith(selectedPlan: selectedPlan, status: RideStates.success));
  }

  Future<void> fetchModels(String brandId, BuildContext context) async {
    models.clear();
    emit(state.copyWith(colors: [], status: RideStates.loadingModels));
    final Either<Failure, List<String>> result = await getRideModelsUseCase(brandId);

    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (data) {
        models.addAll(data);
        emit(state.copyWith(status: RideStates.success, models: data));
      },
    );
  }

  Future<void> fetchColors(BuildContext context) async {
    final Either<Failure, List<RideColorEntity>> result = await getRideCarColorsUseCase(const NoParams());

    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (data) {
        emit(state.copyWith(status: RideStates.success, colors: data));
      },
    );
  }

  onUploadPersonalPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalPicture: file));
        });
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

  onUploadPersonalCriminalRecordPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalCriminalRecordPicture: file));
        });
  }

  onUploadPersonalDrugAnalysisPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalDrugAnalysisPicture: file));
        });
  }

  onUploadPersonalTechnicalExaminationPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalTechnicalExaminationPicture: file));
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

  onUploadVehiclePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(vehiclePicture: file));
        });
  }

  String captain = '62c8ba9f8e28a58a3edf57eb';
  String lady = '62ea012a69ea29c91dfc3917';
  String intercity = '62c8baa08e28a58a3edf57ed';
  String premium = '62c8baa38e28a58a3edf57f3';
  String taxi = '62c8ba9e8e28a58a3edf57e9';
  String suv = '62c8baa28e28a58a3edf57f1';
  String scooter = '6698736fdaa111da2d775627';

  onSubmitSelectSubCategories(BuildContext context) async {
    final categoriesToCheck = {
      captain,
      lady,
      premium,
      intercity,
      taxi,
      suv,
      scooter,
    };

    if ((state.rideSubCategories ?? []).any((element) => categoriesToCheck.contains(element.subCategoryId) && element.isSelected == true)) {
      emit(state.copyWith(registerType: 'socket', isShipping: false));
      context.push(Routes.personalInformationScreen);
    } else {
      emit(state.copyWith(registerType: 'noSocket', isShipping: false));
      context.push(Routes.personalInformationScreen);
    }
  }

  onSubmitSelectShippingSubCategories(BuildContext context) async {
    emit(state.copyWith(registerType: 'noSocket', isShipping: true));
    context.push(Routes.personalInformationScreen);
  }

  onNavigateToWelcomeScreen({required bool fromShipping, required BuildContext context}) {
    if (fromShipping == true) {
      emit(state.copyWith(isShipping: true, status: RideStates.success));
      context.push(Routes.welcomeRideRegister, extra: state.shippingSubCategories);
    } else {
      emit(state.copyWith(isShipping: false, status: RideStates.success));
      context.push(Routes.welcomeRideRegister, extra: state.rideSubCategories);
    }
  }

  onSelectShippingSubCategory(String id, BuildContext context) {
    List<SubCategoryEntityUpdated> subCategories = [];
    subCategories.addAll(state.shippingSubCategories ?? []);
    SubCategoryEntityUpdated selectedItem = subCategories.firstWhere((element) => element.subCategoryId == id);
    if (selectedItem.isSelected == true) {
      selectedItem.isSelected = false;
      subCategories.where((e) => e.isEnabled = true).toList();
    } else {
      subCategories.where((e) => e.isEnabled = false).toList();
      selectedItem.isSelected = true;
      selectedItem.isEnabled = true;
    }
    emit(state.copyWith(rideSubCategories: subCategories));
  }

  onSelectSubCategory(String id, BuildContext context) {
    bool isMale = UserCubit.to.state.data?.gender == 'male';
    List<SubCategoryEntityUpdated> subCategories = [];
    subCategories.addAll(state.rideSubCategories ?? []);
    SubCategoryEntityUpdated selectedItem = subCategories.firstWhere((element) => element.subCategoryId == id);
    SubCategoryEntityUpdated captainCategory = subCategories.firstWhere((element) => element.subCategoryId == captain);
    SubCategoryEntityUpdated ladyCategory = subCategories.firstWhere((element) => element.subCategoryId == lady);
    SubCategoryEntityUpdated premiumCategory = subCategories.firstWhere((element) => element.subCategoryId == premium);
    SubCategoryEntityUpdated intercityCategory = subCategories.firstWhere((element) => element.subCategoryId == intercity);
    if (id == captain) {
      if (!isMale) {
        showErrorMessage(context, "You are female, try register as a lady or change your gender from setting.");
        return;
      }
      if (selectedItem.isSelected == true) {
        if (premiumCategory.isSelected == true || intercityCategory.isSelected == true) {
          ladyCategory.isEnabled = true;
          captainCategory.isEnabled = true;
          captainCategory.isSelected = false;
        } else {
          captainCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (premiumCategory.isSelected == true || intercityCategory.isSelected == true) {
          ladyCategory.isEnabled = false;
          ladyCategory.isSelected = false;
          captainCategory.isEnabled = true;
          captainCategory.isSelected = true;
        } else {
          subCategories.where((e) => e.isEnabled = false).toList();
          subCategories.where((e) => e.isSelected = false).toList();
          captainCategory.isEnabled = true;
          captainCategory.isSelected = true;
          premiumCategory.isEnabled = true;
          intercityCategory.isEnabled = true;
        }
      }
    } else if (id == lady) {
      if (isMale) {
        showErrorMessage(context, "You are male, try register as a captain or change your gender from setting.");
        return;
      }
      if (selectedItem.isSelected == true) {
        if (premiumCategory.isSelected == true || intercityCategory.isSelected == true) {
          captainCategory.isEnabled = true;
          ladyCategory.isEnabled = true;
          ladyCategory.isSelected = false;
        } else {
          ladyCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (premiumCategory.isSelected == true || intercityCategory.isSelected == true) {
          captainCategory.isEnabled = false;
          captainCategory.isSelected = false;
          ladyCategory.isEnabled = true;
          ladyCategory.isSelected = true;
        } else {
          subCategories.where((e) => e.isEnabled = false).toList();
          subCategories.where((e) => e.isSelected = false).toList();
          ladyCategory.isEnabled = true;
          ladyCategory.isSelected = true;
          premiumCategory.isEnabled = true;
          intercityCategory.isEnabled = true;
        }
      }
    } else if (id == premium) {
      if (selectedItem.isSelected == true) {
        if (captainCategory.isSelected == true || ladyCategory.isSelected == true || intercityCategory.isSelected == true) {
          premiumCategory.isSelected = false;
        } else {
          premiumCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (captainCategory.isSelected == true || ladyCategory.isSelected == true || intercityCategory.isSelected == true) {
          premiumCategory.isSelected = true;
        } else {
          subCategories.where((e) => e.isEnabled = false).toList();
          premiumCategory.isSelected = true;
          premiumCategory.isEnabled = true;
          intercityCategory.isEnabled = true;
          captainCategory.isEnabled = true;
          ladyCategory.isEnabled = true;
        }
      }
    } else if (id == intercity) {
      if (selectedItem.isSelected == true) {
        if (captainCategory.isSelected == true || ladyCategory.isSelected == true || premiumCategory.isSelected == true) {
          intercityCategory.isSelected = false;
        } else {
          intercityCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (captainCategory.isSelected == true || ladyCategory.isSelected == true || premiumCategory.isSelected == true) {
          intercityCategory.isSelected = true;
        } else {
          subCategories.where((e) => e.isEnabled = false).toList();
          intercityCategory.isSelected = true;
          intercityCategory.isEnabled = true;
          premiumCategory.isEnabled = true;
          captainCategory.isEnabled = true;
          ladyCategory.isEnabled = true;
        }
      }
    } else {
      if (selectedItem.isSelected == true) {
        selectedItem.isSelected = false;
        subCategories.where((e) => e.isEnabled = true).toList();
      } else {
        subCategories.where((e) => e.isEnabled = false).toList();
        selectedItem.isSelected = true;
        selectedItem.isEnabled = true;
      }
    }
    emit(state.copyWith(rideSubCategories: subCategories));
  }

  onChangeSmokingValue() {
    emit(state.copyWith(isSmoking: !(state.isSmoking ?? false), status: RideStates.success));
  }

  onChangeAirCondition() {
    emit(state.copyWith(hasAirCondition: !(state.hasAirCondition ?? false), status: RideStates.success));
  }

  onSubmitUploadingId(BuildContext context) async {
    emit(state.copyWith(status: RideStates.loadingSubmit));
    DriverInfoEntity? driverInfo = state.driverInfo;
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
      emit(state.copyWith(status: RideStates.loadingSubmit));
      state.isShipping == true
          ? await LoadingMethodHelper().uploadDriverId(
              idImageInBehind: state.personalBackIdPicture!,
              idImageInFront: state.personalFrontIdPicture!,
              idExpiryDate: ridePersonalDocExpireDateController.text,
              onSuccessUploaded: (bool isSuccess) {
                if (isSuccess == true) {
                  showSuccessMessage(context, context.isArabic ? 'تم رفع الصور بنجاح' : "Successfully uploaded images");
                  context.pop();
                  context.pop();
                } else {
                  context.pop();
                  showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
                }
              })
          : await RideMethodHelper()
              .uploadDriverId(idImageInBehind: state.personalBackIdPicture!, idImageInFront: state.personalFrontIdPicture!, idExpiryDate: ridePersonalDocExpireDateController.text);
      Future.delayed(const Duration(seconds: 3));
      driverInfo?.isUploadDriverId = true;
    }
  }

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
      if (state.selfieDriverLicensePicture == null && state.isShipping != true) {
        showErrorMessage(context, "Please select selfie driver license picture");
        return;
      }
      showLoadingDialog(context, canPop: false);
      state.isShipping == true
          ? await LoadingMethodHelper().uploadDriverLicense(
              onSuccessUploaded: (isSuccess) {
                if (isSuccess == true) {
                  showSuccessMessage(context, context.isArabic ? 'تم رفع الصور بنجاح' : "Successfully uploaded images");
                  context.pop();
                  context.pop();
                } else {
                  context.pop();
                  showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
                }
              },
              drivingImageInFront: state.driverLicensePicture!,
              drivingImageBehind: state.backOfDriverLicensePicture!,
              drivingExpiryDate: rideDriverExpireDateController.text)
          : await RideMethodHelper().uploadDriverLicense(
              drivingImageInFront: state.driverLicensePicture!, drivingImageBehind: state.backOfDriverLicensePicture!, drivingExpiryDate: rideDriverExpireDateController.text);
      emit(state.copyWith(status: RideStates.success));
      if (state.isShipping != true) await RideMethodHelper().confirmIdentity(verifyUserImage: state.selfieDriverLicensePicture!);
      emit(state.copyWith(status: RideStates.success));
    }
  }

  onSubmitUploadingCarLicense(BuildContext context) async {
    emit(state.copyWith(status: RideStates.loadingSubmit));
    showLoadingDialog(context, canPop: false);
    state.isShipping == true
        ? await LoadingMethodHelper().uploadCarLicense(
            licenseExpiryDate: rideVehicleExpireDateController.text,
            carLicenseBehindImage: state.vehicleBackPicture!,
            carLicenseFrontImage: state.vehicleFrontPicture!,
            onSuccessUploaded: (bool isSuccess) {
              if (isSuccess == true) {
                showSuccessMessage(context, context.isArabic ? 'تم رفع الصور بنجاح' : "Successfully uploaded images");
                context.pop();
                context.pop();
              } else {
                context.pop();
                showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
              }
            })
        : await RideMethodHelper().uploadCarLicense(
            licenseExpiryDate: rideVehicleExpireDateController.text, carLicenseBehindImage: state.vehicleBackPicture!, carLicenseFrontImage: state.vehicleFrontPicture!);
    state.isShipping == true
        ? await LoadingMethodHelper().uploadCarImage(
            carImage: state.vehiclePicture!,
            onSuccessUploaded: (bool isSuccess) {
              emit(state.copyWith(status: RideStates.success, isUploadCarImage: isSuccess));
            })
        : await RideMethodHelper().uploadCarImage(carImage: state.vehiclePicture!);
    emit(state.copyWith(status: RideStates.success));
  }

  onSubmitUploadingDrugAnalysis(BuildContext context) async {
    if (drugAnalysisFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideStates.loadingSubmit));
      await RideMethodHelper().uploadDrugAnalysis(dragAnalysisDate: rideDragAnalysisExpireDateController.text, dragAnalysis: state.personalDrugAnalysisPicture!);
      emit(state.copyWith(status: RideStates.success, isUploadDrugAnalysis: true));
      context.pop();
    }
  }

  onSubmitUploadingCriminalRecord(BuildContext context) async {
    if (criminalRecordFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideStates.loadingSubmit));
      await RideMethodHelper().uploadCriminalRecord(criminalRecordDate: rideCriminalRecordExpireDateController.text, criminalRecordImage: state.personalCriminalRecordPicture!);
      emit(state.copyWith(status: RideStates.success, isUploadCriminalRecord: true));
      context.pop();
    }
  }

  onSubmitUploadingTechnicalExamination(BuildContext context) async {
    if (terminalExaminationFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideStates.loadingSubmit));
      await RideMethodHelper().uploadTechnicalExamination(
          technicalExaminationDate: rideTechnicalExaminationExpireDateController.text, technicalExaminationImage: state.personalTechnicalExaminationPicture!);
      emit(state.copyWith(status: RideStates.success, isUploadTechnicalExamination: true));
      context.pop();
    }
  }

  bool isLoadingSubmitRegister = false;

  onRegister(BuildContext context) async {
    if (state.personalPicture == null) {
      showErrorMessage(context, "Please select profile picture");
      return;
    }
    if (formKey.currentState!.validate()) {
      if (state.selectedBrand == null || (state.selectedBrand?.isEmpty ?? false)) {
        showErrorMessage(context, "Please select vehicle brand");
        return;
      }

      if (state.selectedModel == null || (state.selectedModel?.isEmpty ?? false)) {
        showErrorMessage(context, "Please select vehicle Model");
        return;
      }
      if (state.selectedColors == null || (state.selectedColors?.id.isEmpty ?? false)) {
        showErrorMessage(context, "Please select color");
        return;
      }

      if (state.selectedPlan == null || (state.selectedPlan?.isEmpty ?? false)) {
        showErrorMessage(context, "Please select plan");
        return;
      }
      if (state.selectedGov == null || (state.selectedGov?.isEmpty ?? false)) {
        showErrorMessage(context, "Please select city");
        return;
      }

      isLoadingSubmitRegister = true;
      emit(state.copyWith(status: RideStates.loadingSubmit));

      RegisterRideSpecialEntity params = RegisterRideSpecialEntity(
          driverFirstName: rideNameController.text,
          driverLastName: rideSurNameController.text,
          airConditioner: state.hasAirCondition ?? false,
          birthday: rideDateOfBirthController.text,
          city: state.selectedGov ?? '',
          driverLicenseNumber: ridePersonalDocLicenseNumController.text,
          idNumber: ridePersonalDocIdNumController.text,
          phone: ridePhoneNumberController.text,
          plateInfo: rideVehiclePlateNumberController.text,
          pricingPerKm: ridePricingPerKmController.text,
          smoker: state.isSmoking ?? false,
          vehicleBrand: state.selectedBrand ?? '',
          vehicleColor: state.selectedColors?.id ?? '',
          vehicleModel: state.selectedModel ?? '',
          vehicleYear: rideVehicleProductionYearController.text,
          workingType: state.selectedPlan ?? '',
          subcategoryIds: (state.rideSubCategories ?? []).where((e) => e.isEnabled == true).toList().map((e) => e.subCategoryId).toList());
      final Either<Failure, bool> result = await registerRideSpecialUseCase(params);

      result.fold(
        (failure) {
          showErrorMessage(context, getFailureMessage(failure, context));
          isLoadingSubmitRegister = false;
          emit(state.copyWith(status: RideStates.error, failure: failure));
        },
        (data) async {
          await RideMethodHelper().uploadDriverImage(driverImage: state.personalPicture!);
          await fetchRideDriverInfo(context);
          await fetchRideDriverPictureOptional(context);
          showSuccessMessage(context, context.isArabic ? "تم التسجيل بنجاح" : "Registered successfully");
          context.pushReplacement(Routes.UploadRiderImages);
          isLoadingSubmitRegister = false;
          emit(state.copyWith(status: RideStates.success));
        },
      );
    }
  }

  onNoSocketRegister(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoadingSubmitRegister = true;
      emit(state.copyWith(status: RideStates.loadingSubmit));

      RegisterRideNotSpecialEntity params = RegisterRideNotSpecialEntity(
          driverFirstName: rideNameController.text,
          driverLastName: rideSurNameController.text,
          birthday: rideDateOfBirthController.text,
          driverLicenseNumber: ridePersonalDocLicenseNumController.text,
          idNumber: ridePersonalDocIdNumController.text,
          phone: ridePhoneNumberController.text,
          plateInfo: rideVehiclePlateNumberController.text,
          // subcategoryId: "62c8baa08e28a58a3edf57ed",
          subcategoryId: (state.rideSubCategories ?? []).firstWhere((e) => e.isEnabled == true).subCategoryId,
          carModel: rideCarModelController.text);
      final Either<Failure, bool> result = await registerRideNotSpecialUseCase(params);

      result.fold(
        (failure) {
          showErrorMessage(context, getFailureMessage(failure, context));
          isLoadingSubmitRegister = false;
          emit(state.copyWith(status: RideStates.error, failure: failure));
        },
        (data) async {
          isLoadingSubmitRegister = false;
          await fetchRideDriverInfo(context);
          emit(state.copyWith(status: RideStates.success));
          showSuccessMessage(context, context.isArabic ? "تم التسجيل بنجاح" : "Registered successfully");
          context.pushReplacement(Routes.UploadRiderImages);
        },
      );
    }
  }

  onLoadingRegister(BuildContext context) async {
    context.pushReplacement(Routes.completeRegisterScreen);

    if (formKey.currentState!.validate()) {
      isLoadingSubmitRegister = true;
      emit(state.copyWith(status: RideStates.loadingSubmit));

      LoadingRegisterEntity params = LoadingRegisterEntity(
          idNumber: ridePersonalDocIdNumController.text,
          phone: ridePhoneNumberController.text,
          plateInformation: rideVehiclePlateNumberController.text,
          location: state.selectedGov ?? '',
          firstName: rideNameController.text,
          lastName: rideSurNameController.text,
          categoryId: (state.shippingSubCategories ?? []).firstWhere((e) => e.isEnabled == true).subCategoryId,
          carModel: rideCarModelController.text);
      final Either<Failure, bool> result = await loadingRegisterUseCase(params);

      result.fold(
        (failure) {
          showErrorMessage(context, getFailureMessage(failure, context));
          isLoadingSubmitRegister = false;
          emit(state.copyWith(status: RideStates.error, failure: failure));
        },
        (data) async {
          isLoadingSubmitRegister = false;
          await fetchLoaderInfo(context);
          emit(state.copyWith(status: RideStates.success));
          showSuccessMessage(context, context.isArabic ? "تم التسجيل بنجاح" : "Registered successfully");
          context.pushReplacement(Routes.completeRegisterScreen);
        },
      );
    }
  }
}
