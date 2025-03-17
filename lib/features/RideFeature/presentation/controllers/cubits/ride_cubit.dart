
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_image.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/ride_method_helper.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_picture_optional_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/check_real_amount_enough_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_driver_picture_optional.dart';
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
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_governorates.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_shipping_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/register_ride_special_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/entities/ride_category_entity.dart';
import '../../../domain/usecases/get_ride_categories_usecase.dart';

import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';



class RideCubit extends Cubit<RideState> {

  bool isComfort = false;
  bool isComfortIsAdded = false;
  bool isNonSmoker = false;
  bool isNonSmokerIsAdded = false;
  bool isAutoAccept = false;
  bool isAutoAcceptIsAdded = false;
  bool isRecord = false;

  bool showWaypointOne = false;
  bool showWaypointTwo = false;


  final GetRideCategoriesUseCase getRideCategories;
  final GetShippingCategoriesUsecase getShippingCategoriesUsecase;
  final GetRideGovernoratesUseCase getRideGovernoratesUseCase;
  final GetRideBrandsUseCase getRideBrandsUseCase;
  final GetRideModelsUseCase getRideModelsUseCase;
  final GetRideCarColorsUseCase getRideCarColorsUseCase;
  final RegisterRideSpecialUseCase registerRideSpecialUseCase;
  final GetRideDriverInfoUseCase getRideDriverInfoUseCase;
  final GetDriverPictureOptionalUseCase getDriverPictureOptionalUseCase;
  final GetLocationFromAddressUseCase getLocationFromAddressUseCase;
  final GetRideExpectedPriceUseCase getRideExpectedPriceUseCase;
  final GetAllCompletedTripsUseCase getAllCompletedTripsUseCase;
  final GetAllRunningTripsUseCase getAllRunningTripsUseCase;
  final GetAllActivityTripsUseCase getAllActivityTripsUseCase;
  final CheckRealAmountEnoughUseCase checkRealAmountEnoughUseCase;

  RideCubit(
    this.getRideCategories,
    this.getShippingCategoriesUsecase,
    this.getRideGovernoratesUseCase,
    this.getRideBrandsUseCase,
    this.getRideModelsUseCase,
    this.getRideCarColorsUseCase,
    this.registerRideSpecialUseCase,
    this.getRideDriverInfoUseCase,
    this.getDriverPictureOptionalUseCase,
      this.getLocationFromAddressUseCase,
      this.getRideExpectedPriceUseCase,
      this.getAllCompletedTripsUseCase,
      this.getAllRunningTripsUseCase,
      this.getAllActivityTripsUseCase,
      this.checkRealAmountEnoughUseCase,
  ) : super(const RideState()){
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    emit(state.copyWith(status: RideStates.loading));

    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      String address = placemarks.isNotEmpty
          ? "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}"
          : "Unknown current Location";

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
  TextEditingController ridePersonalDocExpireDateController = TextEditingController();
  TextEditingController rideVehicleLicenseNumController = TextEditingController();
  TextEditingController rideVehicleExpireDateController = TextEditingController();
  TextEditingController rideDragAnalysisExpireDateController = TextEditingController();
  TextEditingController rideTechnicalExaminationExpireDateController = TextEditingController();
  TextEditingController rideCriminalRecordExpireDateController = TextEditingController();
  TextEditingController rideVehicleProductionYearController = TextEditingController();
  TextEditingController rideVehiclePlateNumberController = TextEditingController();
  TextEditingController ridePricingPerKmController = TextEditingController();

  Future<void> fetchRideCategories(String userId) async {
    if (isClosed) return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result = await getRideCategories(userId);

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (rideCategory) {
        print("Suzccess");
        print("Suzccess${rideCategory.subCategories.length}");
        emit(state.copyWith(status: RideStates.success, rideCategory: rideCategory, rideSubCategories: rideCategory.subCategories));
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
        print("Failure ${getFailureMessage(failure, context)}");
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
        ));
      },
    );
  }

  Future<void> fetchRideDriverPictureOptional(BuildContext context) async {
    if (isClosed) return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, DriverPictureOptionalEntity> result = await getDriverPictureOptionalUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        print("Failure ${getFailureMessage(failure, context)}");
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
      (rideCategory) => emit(state.copyWith(status: RideStates.success, shippingCategory: rideCategory)),
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
        startLocation:[state.currentLocation!.lat!, state.currentLocation!.lng!],
        targetLocation: [state.toLocation!.lat!, state.toLocation!.lng!],
        // startLocation: [30.0445439,31.2326909],
        // targetLocation: [30.1186853,31.3609478],
        comfort: isComfort,
        nonSmoking: isNonSmoker,
        autoAccept: isAutoAccept,
        wayPointOne: (state.wayPointOne != null) ? [state.wayPointOne!.lat!, state.wayPointOne!.lng!] : null,
        wayPointTwo: (state.wayPointTwo != null) ? [state.wayPointTwo!.lat!, state.wayPointTwo!.lng!] : null,
        id: id
      ),
    );

    log(result.toString());

    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (rideExpectedPrice) => emit(state.copyWith(status: RideStates.success, rideExpectedPrice: rideExpectedPrice)),
    );
  }

  Future<bool> checkRealAmountIsEnough({required double price}) async{

    final Either<Failure, bool> result = await checkRealAmountEnoughUseCase(price);

    return result.fold(
      (failure) => false,
      (isEnough) => isEnough,
    );
  }

  Future<void> fetchAllCompletedTrips({required int limit, required int page}) async {
    //emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, List<CompletedTripsEntity>> result =
    await getAllCompletedTripsUseCase(GetAllCompletedTripsUseCaseParams(limit, page));

    result.fold(
          (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
          (completedTrips) {
        final List<CompletedTripsEntity> updatedTrips = page == 1
            ? completedTrips
            : [...?state.completedTrips, ...completedTrips];

        emit(state.copyWith(status: RideStates.success, completedTrips: updatedTrips));
      },
    );
  }


  Future<void> fetchAllRunningTrips({required int limit, required int page}) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, List<RunningTripsEntity>> result =
    await getAllRunningTripsUseCase(GetAllRunningTripsUseCaseParams(limit, page));

    result.fold(
          (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
          (runningTrips) {
        final List<RunningTripsEntity> updatedTrips = page == 1
            ? runningTrips
            : [...?state.runningTrips, ...runningTrips];

        emit(state.copyWith(status: RideStates.success, runningTrips: updatedTrips));
      },
    );
  }


  Future<void> fetchAllActivityTrips({required int limit, required int page}) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, ActivityTripEntity> result = await getAllActivityTripsUseCase(
        GetAllActivityTripsUseCaseParams(limit: limit, page: page)
    );
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

  void emitRefreshState(){
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

  void updateWayPointOne({required double lat, required double lng, required String address}) {

    GetLocationFromAddressEntity wayPointOne = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );

    emit(state.copyWith(status: RideStates.success, wayPointOne: wayPointOne));
  }

  void updateWayPointTwo({required double lat, required double lng, required String address}) {

    GetLocationFromAddressEntity wayPointTwo = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );

    emit(state.copyWith(status: RideStates.success, wayPointTwo: wayPointTwo));
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
    print("selectedPlan$selectedPlan");
    emit(state.copyWith(selectedPlan: selectedPlan, status: RideStates.success));
    print("selectedPlan${state.selectedPlan}");
  }

  Future<void> fetchModels(String brandId, BuildContext context) async {
    print("objectSSS${state.models?.length}");
    print("objectSSS${models.length}");
    models.clear();
    emit(state.copyWith(colors: [], status: RideStates.loadingModels));
    final Either<Failure, List<String>> result = await getRideModelsUseCase(brandId);

    result.fold(
      (failure) {
        print("failure${getFailureMessage(failure, context)}");
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
        print("failure${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (data) {
        print("data.length${data.length}");
        print("data.length${data[0].nameAr}");
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
        print('captain');
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
      print("object");
      if (state.personalFrontIdPicture == null) {
        showErrorMessage(context, "Please select front id picture");
        return;
      }
      if (state.personalBackIdPicture == null) {
        showErrorMessage(context, "Please select back id picture");
        return;
      }
      emit(state.copyWith(status: RideStates.loadingSubmit));
      await RideMethodHelper()
          .uploadDriverId(idImageInBehind: state.personalBackIdPicture!, idImageInFront: state.personalFrontIdPicture!, idExpiryDate: ridePersonalDocExpireDateController.text);
      Future.delayed(Duration(seconds: 3));
      driverInfo?.isUploadDriverId = true;
      emit(state.copyWith(status: RideStates.success, isUploadDriverId: true));
      context.pop();
    }
  }

  onSubmitUploadingDriverLicense(BuildContext context) async {
    if (driverLicenseFormKey.currentState!.validate()) {
      print("object");
      if (state.driverLicensePicture == null) {
        showErrorMessage(context, "Please select driver license picture");
        return;
      }
      if (state.backOfDriverLicensePicture == null) {
        showErrorMessage(context, "Please select back of driver license picture");
        return;
      }
      if (state.selfieDriverLicensePicture == null) {
        showErrorMessage(context, "Please select selfie driver license picture");
        return;
      }
      emit(state.copyWith(status: RideStates.loadingSubmit));
      await RideMethodHelper().uploadDriverLicense(
          drivingImageInFront: state.driverLicensePicture!, drivingImageBehind: state.backOfDriverLicensePicture!, drivingExpiryDate: rideDriverExpireDateController.text);
      await RideMethodHelper().confirmIdentity(verifyUserImage: state.selfieDriverLicensePicture!);
      emit(state.copyWith(status: RideStates.success,isUploadDriverLicense: true));
      context.pop();
    }
  }

  onSubmitUploadingCarLicense(BuildContext context) async {
    emit(state.copyWith(status: RideStates.loadingSubmit));
    await RideMethodHelper().uploadCarLicense(
        licenseExpiryDate: rideVehicleExpireDateController.text, carLicenseBehindImage: state.vehicleBackPicture!, carLicenseFrontImage: state.vehicleFrontPicture!);
    await RideMethodHelper().uploadCarImage(carImage: state.vehiclePicture!);
    emit(state.copyWith(status: RideStates.success,isUploadCarLicense: true));
    context.pop();
  }

  onSubmitUploadingDrugAnalysis(BuildContext context) async {
    if (drugAnalysisFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideStates.loadingSubmit));
      await RideMethodHelper().uploadDrugAnalysis(dragAnalysisDate: rideDragAnalysisExpireDateController.text, dragAnalysis: state.personalDrugAnalysisPicture!);
      emit(state.copyWith(status: RideStates.success,isUploadDrugAnalysis: true));
      context.pop();
    }
  }

  onSubmitUploadingCriminalRecord(BuildContext context) async {
    if (criminalRecordFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideStates.loadingSubmit));
      await RideMethodHelper().uploadCriminalRecord(criminalRecordDate: rideCriminalRecordExpireDateController.text, criminalRecordImage: state.personalCriminalRecordPicture!);
      emit(state.copyWith(status: RideStates.success,isUploadCriminalRecord: true));
      context.pop();
    }
  }

  onSubmitUploadingTechnicalExamination(BuildContext context) async {
    if (terminalExaminationFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideStates.loadingSubmit));
      await RideMethodHelper().uploadTechnicalExamination(
          technicalExaminationDate: rideTechnicalExaminationExpireDateController.text, technicalExaminationImage: state.personalTechnicalExaminationPicture!);
      emit(state.copyWith(status: RideStates.success,isUploadTechnicalExamination: true));
      context.pop();
    }
  }

  bool isLoadingSubmitRegister = false;

  onRegister(BuildContext context) async {
    // if(state.personalPicture==null){
    //   showErrorMessage(context, "Please select profile picture");
    //   return;
    // }
    if (formKey.currentState!.validate()) {
      print("objectaaa");
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
          idNumber: ridePersonalDocLicenseNumController.text,
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
          // await RideMethodHelper().uploadCarImage(carImage: state.vehiclePicture!);
          // await RideMethodHelper().uploadCarLicense(carLicenseFrontImage: state.vehicleFrontPicture!,carLicenseBehindImage: state.vehicleBackPicture!,licenseExpiryDate: rideVehicleExpireDateController.text);
          await RideMethodHelper().uploadDriverImage(driverImage: state.personalPicture!);
          // await RideMethodHelper().uploadDriverLicense(drivingImageInFront: state.driverLicensePicture!,drivingImageBehind: state.backOfDriverLicensePicture!,drivingExpiryDate: rideVehicleExpireDateController.text);
          // await RideMethodHelper().uploadDrugAnalysis(dragAnalysis: state.personalDrugAnalysisPicture!,dragAnalysisDate: rideDragAnalysisExpireDateController.text);
          // await RideMethodHelper().uploadCriminalRecord(criminalRecordImage: state.personalCriminalRecordPicture!,criminalRecordDate: rideCriminalRecordExpireDateController.text);
          showSuccessMessage(context, "message");
          context.pushReplacement(Routes.UploadRiderImages);
          isLoadingSubmitRegister = false;
          emit(state.copyWith(status: RideStates.success));
        },
      );
    }
  }
}
