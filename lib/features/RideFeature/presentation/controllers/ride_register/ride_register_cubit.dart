import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/functions/global/upload_image.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/storage.dart';
import 'package:fourtyninehub/core/utils/loading_method_helper.dart';
import 'package:fourtyninehub/core/utils/ride_method_helper.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_brand_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_car_model_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/cost_per_km_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_picture_optional_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_register_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_brand_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_model_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_request_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/add_car_brand_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/add_car_model_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_cost_per_km_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_driver_picture_optional.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_loading_info_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_brands_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_car_colors_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_driver_information.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_governorates.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_models_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_non_tracking_models_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_shipping_models_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_shipping_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/loading_register_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/register_ride_not_special_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/register_ride_special_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/personal_information_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/upload_rider_images.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failure.dart';

part 'ride_register_state.dart';

class RideRegisterCubit extends Cubit<RideRegisterState> {
  final GetRideGovernoratesUseCase getRideGovernoratesUseCase;
  final GetShippingCategoriesUsecase getShippingCategoriesUsecase;
  final GetRideCategoriesUseCase getRideCategories;
  final GetRideBrandsUseCase getRideBrandsUseCase;
  final GetRideModelsUseCase getRideModelsUseCase;
  final GetRideNonTrackingModelsUseCase getRideNonTrackingModelsUseCase;
  final GetRideCarColorsUseCase getRideCarColorsUseCase;
  final RegisterRideSpecialUseCase registerRideSpecialUseCase;
  final RegisterRideNotSpecialUseCase registerRideNotSpecialUseCase;
  final GetRideDriverInfoUseCase getRideDriverInfoUseCase;
  final GetDriverPictureOptionalUseCase getDriverPictureOptionalUseCase;
  final GetCostPerKmUseCase getCostPerKmUseCase;
  final LoadingRegisterUseCase loadingRegisterUseCase;
  final GetLoadingInfoUseCase getLoadingInfoUseCase;
  final AddCarModelUseCase addCarModelUseCase;
  final AddCarBrandUseCase addCarBrandUseCase;
  final GetRideShippingModelsUseCase getRideShippingModelsUseCase;

  final formKey = GlobalKey<FormState>();

  final idFormKey = GlobalKey<FormState>();

  final carLicenseFormKey = GlobalKey<FormState>();

  final driverLicenseFormKey = GlobalKey<FormState>();

  final drugAnalysisFormKey = GlobalKey<FormState>();

  final criminalRecordFormKey = GlobalKey<FormState>();
  final terminalExaminationFormKey = GlobalKey<FormState>();
  final personalPhotoFormKey = GlobalKey<FormState>();
  TextEditingController rideNameController = TextEditingController();
  TextEditingController rideSurNameController = TextEditingController();
  TextEditingController rideDateOfBirthController = TextEditingController();
  TextEditingController ridePhoneNumberController = TextEditingController();
  TextEditingController rideDriverLicenseNumController =
      TextEditingController();
  TextEditingController rideDriverExpireDateController =
      TextEditingController();
  TextEditingController ridePersonalDocLicenseNumController =
      TextEditingController();
  TextEditingController ridePersonalDocIdNumController =
      TextEditingController();
  TextEditingController ridePersonalDocExpireDateController =
      TextEditingController();
  TextEditingController rideVehicleLicenseNumController =
      TextEditingController();
  TextEditingController rideVehicleExpireDateController =
      TextEditingController();
  TextEditingController rideDragAnalysisExpireDateController =
      TextEditingController();
  TextEditingController rideTechnicalExaminationExpireDateController =
      TextEditingController();
  TextEditingController personalPhotoDateController = TextEditingController();
  TextEditingController rideCriminalRecordExpireDateController =
      TextEditingController();
  TextEditingController rideVehicleProductionYearController =
      TextEditingController();
  TextEditingController rideVehiclePlateNumberController =
      TextEditingController();
  TextEditingController ridePricingPerKmController = TextEditingController();
  TextEditingController rideCarModelController = TextEditingController();
  TextEditingController personalPhotoController = TextEditingController();
  bool loadingRegister = false;
  List<String> subscriptionPlans = [
    'Percentage',
    'Subscribe Package',
  ];
  List<String> subscriptionPlansAr = [
    'نظام النسبة',
    'باقة الاشتراك',
  ];
  List<RideModelEntity> models = [];
  TextEditingController modelNameController = TextEditingController();
  var modelFormKey = GlobalKey<FormState>();

  TextEditingController newModelAddedController = TextEditingController();

  TextEditingController newBrandAddedController = TextEditingController();

  TextEditingController brandNameController = TextEditingController();

  var brandFormKey = GlobalKey<FormState>();

  //model brand color city plan

  bool isLoadingSubmitRegister = false;

  String captain = '62c8ba9f8e28a58a3edf57eb';

  String lady = '62ea012a69ea29c91dfc3917';

  String intercity = '62c8baa08e28a58a3edf57ed';
  String premium = '62c8baa38e28a58a3edf57f3';

  String taxi = '62c8ba9e8e28a58a3edf57e9';

  String suv = '62c8baa28e28a58a3edf57f1';

  String scooter = '6698736fdaa111da2d775627';

  RideRegisterCubit(
    this.getRideGovernoratesUseCase,
    this.getRideBrandsUseCase,
    this.getRideModelsUseCase,
    this.getRideCarColorsUseCase,
    this.registerRideSpecialUseCase,
    this.registerRideNotSpecialUseCase,
    this.getRideDriverInfoUseCase,
    this.getDriverPictureOptionalUseCase,
    this.getCostPerKmUseCase,
    this.loadingRegisterUseCase,
    this.getLoadingInfoUseCase,
    this.getShippingCategoriesUsecase,
    this.getRideCategories,
    this.addCarModelUseCase,
    this.addCarBrandUseCase,
    this.getRideNonTrackingModelsUseCase,
    this.getRideShippingModelsUseCase,
  ) : super(RideRegisterState());
  Future<void> addNewBrand(
      {required BuildContext context, required String brandName}) async {
    //addCarModelUseCase
    showLoadingDialog(context);
    emit(state.copyWith(
        status: RideRegisterStates.initState,
        selectedBrand: RideBrandEntity(
            id: '', brandNameEn: '', brandNameAr: '', logoUrl: '')));
    final Either<Failure, String> result = await addCarBrandUseCase(brandName);

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        context.pop();
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (data) async {
        context.pop();
        showSuccessMessage(
            context,
            context.isArabic
                ? "تم اضافة الماركة بنجاح"
                : "Model added successfully");
        RideBrandModel newBrand = RideBrandModel(
            id: data,
            brandNameAr: brandName,
            brandNameEn: brandName,
            logoUrl: '');
        newBrandAddedController.text = brandName;
        emit(state.copyWith(
            status: RideRegisterStates.success, newBrand: newBrand));
      },
    );
  }

  Future<void> addNewModel(
      {required BuildContext context,
      required String modelName,
      required String brandId,
      required RideFeatureRegisterParams params}) async {
    bool isScooter = params.subCategoriesId.contains(scooter);
    //addCarModelUseCase
    showLoadingDialog(context);
    emit(state.copyWith(
        status: RideRegisterStates.initState,
        selectedModel: RideModelEntity(id: '', modelAr: '', modelEn: '')));
    final Either<Failure, String> result =
        await addCarModelUseCase(AddCarModelParams(
            modelName: modelName,
            type: isScooter
                ? 'scooter'
                : params.isShipping
                    ? 'truck'
                    : params.isSocket
                        ? "car"
                        : 'bus',
            //
            carBrandId: brandId));

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        context.pop();
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (data) async {
        context.pop();
        showSuccessMessage(
            context,
            context.isArabic
                ? "تم اضافة الموديل بنجاح"
                : "Model added successfully");
        RideCarModelModel newModel = RideCarModelModel(
          id: data,
          modelAr: modelName,
          modelEn: modelName,
        );
        newModelAddedController.text = modelName;
        emit(state.copyWith(
            status: RideRegisterStates.success, newModel: newModel));
      },
    );
  }

  void emitRefreshState() {
    emit(state.copyWith(status: RideRegisterStates.success));
  }

  Future<void> fetchBrands(BuildContext context, {required String type}) async {
    final Either<Failure, List<RideBrandEntity>> result =
        await getRideBrandsUseCase(const NoParams());

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        log("messageFailure ${getFailureMessage(failure, context)}");
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (data) async {
        log("messageData $data ${data.length}");
        RegisterRideSpecialEntity? cachedData =
            await Storage().getDriverEntity();
        String? brand = cachedData?.vehicleBrand;
        if (brand != null && (brand.isNotEmpty))
          await onSelectBrand(brand, context, type: type);
        RideBrandEntity? selectedBrand =
            data.firstWhereOrNull((element) => element.id == brand);
        emit(state.copyWith(
            status: RideRegisterStates.success,
            brands: data,
            selectedBrand: selectedBrand));
      },
    );
  }

  Future<void> fetchColors(BuildContext context) async {
    final Either<Failure, List<RideColorEntity>> result =
        await getRideCarColorsUseCase(const NoParams());

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (data) async {
        RegisterRideSpecialEntity? cachedData =
            await Storage().getDriverEntity();
        String? color = cachedData?.vehicleColor;
        RideColorEntity? selectedColor;
        if (color != null && (color.isNotEmpty)) {
          selectedColor = data.firstWhere((element) => element.id == color);
          onSelectColor(selectedColor);
        }
        emit(state.copyWith(
            status: RideRegisterStates.success,
            colors: data,
            color: selectedColor));
      },
    );
  }

  Future<void> fetchGovs(RideFeatureRegisterParams params) async {
    final Either<Failure, List<GovernorateEntity>> result =
        await getRideGovernoratesUseCase(const NoParams());

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (governorates) async {
        RegisterRideSpecialEntity? cachedData =
            await Storage().getDriverEntity();
        LoadingRegisterEntity? cachedLoadingData =
            await Storage().getLoaderEntity();
        String? cityId = '';
        print("cachedDataCC${cachedData?.city}");
        print("cachedLoadingDataCC${cachedLoadingData?.location}");
        if (params.isShipping == true) {
          cityId = cachedLoadingData?.location;
        } else {
          if (params.isSocket == false) {
            cityId = '';
          } else {
            cityId = cachedData?.city;
          }
        }
        GovernorateEntity? selectedCity;
        if (cityId != null && (cityId.isNotEmpty)) {
          selectedCity =
              governorates.firstWhereOrNull((element) => element.id == cityId);
          onSelectGov(cityId);
        }
        emit(state.copyWith(
            status: RideRegisterStates.success,
            govs: governorates,
            city: selectedCity));
      },
    );
  }

  Future<void> fetchLoaderInfo(BuildContext context, bool refresh) async {
    if (isClosed)
      return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, LoadingInfoEntity> result =
        await getLoadingInfoUseCase(refresh);

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (info) {
        emit(state.copyWith(
            status: RideRegisterStates.success,
            loaderInfo: info,
            registerType: 'noSocket',
            isShipping: true));
      },
    );
  }

  Future<void> fetchModels(String brandId, BuildContext context) async {
    models.clear();
    emit(state.copyWith(status: RideRegisterStates.loadingModels));
    final Either<Failure, List<RideModelEntity>> result =
        await getRideModelsUseCase(brandId);

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (data) async {
        models.addAll(data);
        emit(state.copyWith(status: RideRegisterStates.success, models: data));
      },
    );
  }

  Future<void> fetchNonSocketModels(
      String brandId, BuildContext context) async {
    models.clear();
    emit(state.copyWith(status: RideRegisterStates.loadingModels));
    final Either<Failure, List<RideModelEntity>> result =
        await getRideNonTrackingModelsUseCase(brandId);

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (data) async {
        models.addAll(data);
        emit(state.copyWith(status: RideRegisterStates.success, models: data));
      },
    );
  }

  Future<void> fetchRideCategories(String userId, bool refresh) async {
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result =
        await getRideCategories(
            GetRideCategoriesParams(userId: userId, refresh: refresh));

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (rideCategory) async {
        RegisterRideSpecialEntity? rideSocketCachedData =
            await Storage().getDriverEntity();
        RegisterRideNotSpecialEntity? rideNonSocketCachedData =
            await Storage().getDriverNoSocketEntity();
        List<SubCategoryEntityUpdated>? rideSubCategories =
            rideCategory.subCategories;
        List<String> subcategoryIds = [];
        subcategoryIds.addAll(rideSocketCachedData?.subcategoryIds ?? []);
        subcategoryIds.add(rideNonSocketCachedData?.subcategoryId ?? '');
        if (subcategoryIds == []) {
          log("subcategoryIds==[] $subcategoryIds");
          for (var item in rideSubCategories) {
            if (subcategoryIds.contains(item.subCategoryId)) {
              item.isSelected = true;
              item.isEnabled = true;
            } else {
              item.isSelected = false;
              item.isEnabled = false;
            }
          }
        }
        emit(state.copyWith(
            status: RideRegisterStates.success,
            rideCategory: rideCategory,
            rideSubCategories: rideSubCategories));
      },
    );
  }

  Future<void> fetchRideDriverInfo(BuildContext context, bool refresh) async {
    if (isClosed)
      return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, DriverInfoEntity> result =
        await getRideDriverInfoUseCase(refresh);

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (info) {
        print("info.toJson()${info.toJson()}");
        emit(state.copyWith(
            status: RideRegisterStates.success,
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
            registerType: info.driverType == 'socket' ? 'socket' : 'noSocket',
            isShipping: false));
      },
    );
  }

  Future<void> fetchRideDriverPictureOptional(BuildContext context) async {
    if (isClosed)
      return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, DriverPictureOptionalEntity> result =
        await getDriverPictureOptionalUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (data) {
        emit(state.copyWith(
            status: RideRegisterStates.success, pictureOptional: data));
      },
    );
  }

  Future<void> fetchRideGovernorates(RideFeatureRegisterParams params) async {
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, List<GovernorateEntity>> result =
        await getRideGovernoratesUseCase(const NoParams());

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (governorates) async {
        RegisterRideSpecialEntity? data = await Storage().getDriverEntity();
        GovernorateEntity? selectedCity;
        if (data?.city != null && (data?.city.isNotEmpty ?? false)) {
          selectedCity = governorates
              .firstWhereOrNull((element) => element.id == data?.city);
        }
        emit(state.copyWith(
            status: RideRegisterStates.success,
            governorates: governorates,
            city: selectedCity));
      },
    );
  }

  fetchRideUploadedImagesData(
      BuildContext context, UploadRiderImagesParams? params) async {
    if (params != null)
      emit(state.copyWith(
          isShipping: params.isShipping,
          registerType: params.isSocket == true ? 'socket' : 'noSocket'));
    emit(state.copyWith(status: RideRegisterStates.loading));
    await Future.wait([
      fetchRideDriverPictureOptional(context),
      if (state.isShipping == true || params?.isShipping == true)
        fetchLoaderInfo(context, false),
      if (state.isShipping == true || params?.isShipping == true)
        fetchLoaderInfo(context, true),
      if (state.isShipping == false || params?.isShipping == false)
        fetchRideDriverInfo(context, false),
      if (state.isShipping == false || params?.isShipping == false)
        fetchRideDriverInfo(context, true)
    ]);
    emit(state.copyWith(status: RideRegisterStates.success));
  }

  Future<void> fetchShippingCategories(String userId, bool refresh) async {
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result =
        await getShippingCategoriesUsecase(
            GetRideCategoriesParams(userId: userId, refresh: refresh));

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (rideCategory) async {
        LoadingRegisterEntity? loadingCachedData =
            await Storage().getLoaderEntity();
        List<SubCategoryEntityUpdated>? rideSubCategories = [];
        rideSubCategories.addAll(rideCategory.subCategories ?? []);
        List<String> subcategoryIds = [];
        subcategoryIds.add(loadingCachedData?.categoryId ?? '');
        log("subcategoryIds$subcategoryIds");
        log("subcategoryIds${rideCategory.subCategories}");
        if (subcategoryIds == []) {
          log("subcategoryIdsTrue${rideCategory.subCategories}");
          for (var item in rideSubCategories) {
            if (subcategoryIds.contains(item.subCategoryId)) {
              item.isSelected = true;
              item.isEnabled = true;
            } else {
              item.isSelected = false;
              item.isEnabled = false;
            }
          }
        }
        emit(state.copyWith(
            status: RideRegisterStates.success,
            shippingCategory: rideCategory,
            shippingSubCategories: rideSubCategories));
      },
    );
  }

  Future<void> fetchShippingModels(String brandId, BuildContext context) async {
    models.clear();
    emit(state.copyWith(status: RideRegisterStates.loadingModels));
    final Either<Failure, List<RideModelEntity>> result =
        await getRideShippingModelsUseCase(brandId);

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (data) async {
        models.addAll(data);
        emit(state.copyWith(status: RideRegisterStates.success, models: data));
      },
    );
  }

  Future<void> getCostPerKm() async {
    if (isClosed)
      return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, CostPerKmEntity> result =
        await getCostPerKmUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
            state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
      (data) {
        emit(state.copyWith(
            status: RideRegisterStates.success, costPerKm: data));
      },
    );
  }

  loadRegisterData(
      BuildContext context, RideFeatureRegisterParams params) async {
    loadingRegister = true;
    print("params.isSocketparams.isSocket${params.isSocket}");
    emit(state.copyWith(status: RideRegisterStates.loading));
    if (params.isShipping == true) {
      context.read<RideRegisterCubit>().onSetSavedLoadingData(params);
    } else {
      if (params.isSocket == false) {
        context.read<RideRegisterCubit>().onSetSavedNoSocketData(params);
      } else {
        context.read<RideRegisterCubit>().onSetSavedData(params);
      }
    }
    await Future.wait([
      fetchGovs(params),
      fetchBrands(context,
          type: params.isSocket == true
              ? 'socket'
              : params.isShipping == true
                  ? 'loading'
                  : 'nonSocket'),
      getCostPerKm(),
      fetchColors(context)
    ]);
    loadingRegister = false;
    emit(state.copyWith(status: RideRegisterStates.success));
  }

  onChangeAirCondition() {
    emit(state.copyWith(
        hasAirCondition: !(state.hasAirCondition ?? false),
        status: RideRegisterStates.success));
  }

  onChangeSmokingValue() {
    emit(state.copyWith(
        isSmoking: !(state.isSmoking ?? false),
        status: RideRegisterStates.success));
  }

  onLoadingRegister(BuildContext context, String categoryId, bool isSocket,
      bool isShipping) async {
    if (formKey.currentState!.validate()) {
      if (state.personalPicture == null ||
          (state.personalPicture?.path.isEmpty ?? false)) {
        showErrorMessage(
            context,
            context.isArabic
                ? "برجاء اختيار صورة الملف الشخصي"
                : "Please select profile picture");
        return;
      }
      showLoadingDialog(context);
      isLoadingSubmitRegister = true;
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));

      LoadingRegisterEntity params = LoadingRegisterEntity(
        idNumber: ridePersonalDocIdNumController.text,
        phone: ridePhoneNumberController.text,
        plateInformation: rideVehiclePlateNumberController.text,
        location: state.selectedGov ?? '',
        firstName: rideNameController.text,
        lastName: rideSurNameController.text,
        categoryId: categoryId,
        vehicleBrand: state.selectedBrand?.id ?? '',
        vehicleColor: state.selectedColors?.id ?? '',
        vehicleModel: (state.newModel?.id.isNotEmpty ?? false)
            ? state.newModel?.id ?? ''
            : state.selectedModel?.id ?? '',
        vehicleYear: rideVehicleProductionYearController.text,
      );
      showLoadingDialog(context);
      final Either<Failure, bool> result = await loadingRegisterUseCase(params);

      result.fold(
        (failure) {
          context.pop();
          showErrorMessage(context, getFailureMessage(failure, context));
          isLoadingSubmitRegister = false;
          emit(state.copyWith(
              status: RideRegisterStates.error, failure: failure));
        },
        (data) async {
          await LoadingMethodHelper().uploadDriverImage(
              driverImage: state.personalPicture!,
              onSuccessUploaded: (bool isSuccess) async {
                if (isSuccess) {
                  context.pop();
                  emit(state.copyWith(status: RideRegisterStates.success));
                } else {
                  context.pop();
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                          : 'An error occurred while uploading images. Please try again.');
                }
              });
          isLoadingSubmitRegister = false;
          context.pop();
          await fetchLoaderInfo(context, false);
          emit(state.copyWith(status: RideRegisterStates.success));
          showSuccessMessage(
              context,
              context.isArabic
                  ? "تم التسجيل بنجاح"
                  : "Registered successfully");
          context.pushReplacement(Routes.completeRegisterScreen,
              extra: UploadRiderImagesParams(
                  isSocket: isSocket, isShipping: isShipping));
        },
      );
    }
  }

  onNoSocketRegister(BuildContext context, String categoryId, bool isSocket,
      bool isShipping) async {
    if (formKey.currentState!.validate()) {
      if (state.personalPicture == null ||
          (state.personalPicture?.path.isEmpty ?? false)) {
        showErrorMessage(
            context,
            context.isArabic
                ? "برجاء اختيار صورة الملف الشخصي"
                : "Please select profile picture");
        return;
      }
      isLoadingSubmitRegister = true;
      showLoadingDialog(context);
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
      print("state.selectedModel cubit ${state.selectedModel?.id}");

      RegisterRideNotSpecialEntity params = RegisterRideNotSpecialEntity(
          driverFirstName: rideNameController.text,
          driverLastName: rideSurNameController.text,
          birthday: rideDateOfBirthController.text,
          driverLicenseNumber: ridePersonalDocLicenseNumController.text,
          idNumber: ridePersonalDocIdNumController.text,
          phone: ridePhoneNumberController.text,
          plateInfo: rideVehiclePlateNumberController.text,
          vehicleBrand: state.selectedBrand?.id ?? '',
          vehicleColor: state.selectedColors?.id ?? '',
          vehicleModel: (state.newModel?.id.isNotEmpty ?? false)
              ?state.newModel?.id??''
              :(state.selectedModel?.id.isNotEmpty ?? false)
              ?state.selectedModel?.id??''
              : '',
              // ?? state.selectedModel?.id ?? '',
          vehicleYear: rideVehicleProductionYearController.text,

          // subcategoryId: "62c8baa08e28a58a3edf57ed",
          subcategoryId: categoryId,
          carModel: rideCarModelController.text);
      final Either<Failure, bool> result =
          await registerRideNotSpecialUseCase(params);

      result.fold(
        (failure) {
          context.pop();
          showErrorMessage(context, getFailureMessage(failure, context));
          isLoadingSubmitRegister = false;
          emit(state.copyWith(
              status: RideRegisterStates.error, failure: failure));
        },
        (data) async {
          isLoadingSubmitRegister = false;
          await RideMethodHelper().uploadDriverImage(
              driverImage: state.personalPicture!,
              onSuccessUploaded: (bool isSuccess) async {
                if (isSuccess) {
                  context.pop();
                  context.pop();
                  emit(state.copyWith(status: RideRegisterStates.success));
                } else {
                  context.pop();
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                          : 'An error occurred while uploading images. Please try again.');
                }
              });
          context.pop();
          await fetchRideDriverInfo(context, false);
          emit(state.copyWith(status: RideRegisterStates.success));
          showSuccessMessage(
              context,
              context.isArabic
                  ? "تم التسجيل بنجاح"
                  : "Registered successfully");
          context.pushReplacement(Routes.completeRegisterScreen,
              extra: UploadRiderImagesParams(
                  isSocket: isSocket, isShipping: isShipping));
        },
      );
    }
  }

  onRegister(BuildContext context, List<String> subCategoryIds, bool isSocket,
      bool isShipping) async {
    DriverInfoEntity? driverInfo = state.driverInfo;
    print("state.personalPicture${state.personalPicture?.path}");
    if (state.personalPicture == null ||
        (state.personalPicture?.path.isEmpty ?? false)) {
      showErrorMessage(
          context,
          context.isArabic
              ? "برجاء اختيار صورة الملف الشخصي"
              : "Please select profile picture");
      return;
    }
    if (formKey.currentState!.validate()) {
      if (state.selectedBrand == null ||
          (state.selectedBrand?.id.isEmpty ?? false)) {
        showErrorMessage(
            context,
            context.isArabic
                ? "برجاء اختيار ماركة السيارة"
                : "Please select vehicle brand");
        return;
      }

      if ((state.newModel==null||(state.newModel?.id.isEmpty ?? false))&&(state.selectedModel == null ||
          (state.selectedModel?.id.isEmpty ?? false))) {
        showErrorMessage(
            context,
            context.isArabic
                ? "برجاء اختيار موديل السيارة"
                : "Please select vehicle Model");
        return;
      }

      if (state.selectedColors == null ||
          (state.selectedColors?.id.isEmpty ?? false)) {
        showErrorMessage(
            context,
            context.isArabic
                ? "برجاء اختيار لون السيارة"
                : "Please select color");
        return;
      }

      if (state.selectedPlan == null ||
          (state.selectedPlan?.isEmpty ?? false)) {
        showErrorMessage(
            context,
            context.isArabic
                ? "برجاء اختيار نوع الرحلة"
                : "Please select plan");
        return;
      }

      if (state.selectedGov == null || (state.selectedGov?.isEmpty ?? false)) {
        showErrorMessage(context,
            context.isArabic ? "برجاء اختيار المدينة" : "Please select city");
        return;
      }

      isLoadingSubmitRegister = true;
      showLoadingDialog(context);
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));

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
          vehicleBrand: state.selectedBrand?.id ?? '',
          vehicleColor: state.selectedColors?.id ?? '',
          vehicleModel: state.newModel!=null?(state.newModel?.id??''):state.selectedModel?.id ?? '',
          vehicleYear: rideVehicleProductionYearController.text,
          workingType: state.selectedPlan ?? '',
          subcategoryIds: subCategoryIds);

      final Either<Failure, bool> result =
          await registerRideSpecialUseCase(params);

      result.fold(
        (failure) {
          showErrorMessage(context, getFailureMessage(failure, context));
          isLoadingSubmitRegister = false;
          context.pop();
          emit(state.copyWith(
              status: RideRegisterStates.error, failure: failure));
        },
        (data) async {
          await RideMethodHelper().uploadDriverImage(
              driverImage: state.personalPicture!,
              onSuccessUploaded: (bool isSuccess) async {
                if (isSuccess) {
                  driverInfo?.isUploadDriverImage = true;
                  emit(state.copyWith(
                      driverInfo: driverInfo,
                      status: RideRegisterStates.success));
                  if (state.driverInfo?.isUploadDriverLicense == true &&
                      state.driverInfo?.isUploadDriverId == true &&
                      state.driverInfo?.isUploadCarLicense == true &&
                      state.driverInfo?.isUploadConfirmIdentifier == true &&
                      state.driverInfo?.isUploadDriverImage == true &&
                      state.driverInfo?.isUploadCarImage == true) {
                    await fetchRideDriverInfo(context, false);
                    showSuccessMessage(
                        context,
                        context.isArabic
                            ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                            : "Successfully uploaded images, please wait for the approval of all data.");
                  }
                  context.pop();
                  context.pop();
                  emit(state.copyWith(status: RideRegisterStates.success));
                } else {
                  context.pop();
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                          : 'An error occurred while uploading images. Please try again.');
                }
              });
          await fetchRideDriverInfo(context, false);
          await fetchRideDriverPictureOptional(context);
          context.pop();
          showSuccessMessage(
              context,
              context.isArabic
                  ? "تم التسجيل بنجاح"
                  : "Registered successfully");
          context.pushReplacement(Routes.completeRegisterScreen,
              extra: UploadRiderImagesParams(
                  isSocket: isSocket, isShipping: isShipping));
          isLoadingSubmitRegister = false;
          emit(state.copyWith(status: RideRegisterStates.success));
        },
      );
    }
  }

  onRemoveDriverData(BuildContext context) async {
    await Storage().removeDriverEntity();
    context.push(Routes.RIDE_HOME);
  }

  onRemoveLoaderData(BuildContext context) async {
    await Storage().removeLoaderEntity();
    context.push(Routes.RIDE_HOME);
  }

  onRemoveModel() {
    RideModelEntity? selectedModel =
        RideModelEntity(id: '', modelAr: '', modelEn: '');
    emit(state.copyWith(
        selectedModel: selectedModel, status: RideRegisterStates.success));
  }

  onRemoveNoSocketData(BuildContext context) async {
    await Storage().removeDriverNoSocketEntity();
    context.push(Routes.RIDE_HOME);
  }

  onSaveRegisterData(BuildContext context, List<String> subCategories) async {
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
        vehicleBrand: (state.newBrand?.id.isNotEmpty ?? false)
            ? state.newBrand?.id ?? ''
            : state.selectedBrand?.id ?? '',
        vehicleColor: state.selectedColors?.id ?? '',
        vehicleModel: (state.newModel?.id.isNotEmpty ?? false)
            ? state.newModel?.id ?? ''
            : state.selectedModel?.id ?? '',
        vehicleYear: rideVehicleProductionYearController.text,
        workingType: state.selectedPlan ?? '',
        personalPicture: state.personalPicture?.path,
        isShipping: state.isShipping,
        subcategoryIds: subCategories);
    await Storage().saveDriverEntity(params);
    await Storage().removeDriverNoSocketEntity();
    context.push(Routes.RIDE_HOME);
  }

  onSaveRegisterLoaderData(
      BuildContext context, List<String> subCategories) async {
    LoadingRegisterEntity params = LoadingRegisterEntity(
      idNumber: ridePersonalDocIdNumController.text,
      phone: ridePhoneNumberController.text,
      plateInformation: rideVehiclePlateNumberController.text,
      location: state.selectedGov ?? '',
      firstName: rideNameController.text,
      lastName: rideSurNameController.text,
      categoryId: subCategories[0],
      vehicleBrand: state.selectedBrand?.id ?? '',
      vehicleColor: state.selectedColors?.id ?? '',
      vehicleModel: state.selectedModel?.id ?? '',
      vehicleYear: rideVehicleProductionYearController.text,
    );
    await Storage().saveLoaderEntity(params);
    context.push(Routes.RIDE_HOME);
  }

  onSaveRegisterNoSocketData(
      BuildContext context, List<String> subCategories) async {
    RegisterRideNotSpecialEntity params = RegisterRideNotSpecialEntity(
        driverFirstName: rideNameController.text,
        driverLastName: rideSurNameController.text,
        birthday: rideDateOfBirthController.text,
        driverLicenseNumber: ridePersonalDocLicenseNumController.text,
        idNumber: ridePersonalDocIdNumController.text,
        phone: ridePhoneNumberController.text,
        plateInfo: rideVehiclePlateNumberController.text,
        vehicleBrand: state.selectedBrand?.id ?? '',
        vehicleColor: state.selectedColors?.id ?? '',
        vehicleModel: state.selectedModel?.id ?? '',
        vehicleYear: rideVehicleProductionYearController.text,
        subcategoryId: subCategories[0],
        carModel: rideCarModelController.text);
    print("params.ssss${params.toJson()}");
    await Storage().saveDriverNoSocketEntity(params);
    await Storage().removeDriverEntity();
    RegisterRideNotSpecialEntity? data =
        await Storage().getDriverNoSocketEntity();
    print("data?.papappa${data?.toJson()}");
    context.push(Routes.RIDE_HOME);
  }

  onSelectBrand(String brand, BuildContext context,
      {required String type}) async {
    RideBrandEntity? selectedBrand =
        state.brands?.firstWhereOrNull((element) => element.id == brand);
    if (selectedBrand == state.selectedBrand) return;
    emit(state.copyWith(
        selectedBrand: selectedBrand,
        selectedModel: RideModelEntity(id: '', modelAr: '', modelEn: ''),
        status: RideRegisterStates.loadingModels));
    if (type == 'socket') await fetchModels(brand, context);
    if (type == 'nonSocket') await fetchNonSocketModels(brand, context);
    if (type == 'loading') await fetchShippingModels(brand, context);
    emit(state.copyWith(status: RideRegisterStates.success));
  }

  onSelectColor(RideColorEntity color) {
    emit(state.copyWith(
        selectedColors: color, status: RideRegisterStates.success));
  }

  onSelectGov(String gov) {
    emit(state.copyWith(selectedGov: gov, status: RideRegisterStates.success));
  }

  onSelectModel(String model) {
    RideModelEntity? selectedModel =
        state.models?.firstWhereOrNull((element) => element.id == model);
    emit(state.copyWith(
        selectedModel: selectedModel, status: RideRegisterStates.success));
  }

  onSelectPlan(String plan) {
    String selectedPlan =
        plan == 'Percentage' ? 'percentage' : 'subscribePackage';
    emit(state.copyWith(
        selectedPlan: selectedPlan, status: RideRegisterStates.success));
  }

  onSelectShippingSubCategory(String id, BuildContext context) {
    List<SubCategoryEntityUpdated> subCategories = [];
    subCategories.addAll(state.shippingSubCategories ?? []);
    SubCategoryEntityUpdated selectedItem =
        subCategories.firstWhere((element) => element.subCategoryId == id);
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
    SubCategoryEntityUpdated selectedItem =
        subCategories.firstWhere((element) => element.subCategoryId == id);
    SubCategoryEntityUpdated captainCategory =
        subCategories.firstWhere((element) => element.subCategoryId == captain);
    SubCategoryEntityUpdated ladyCategory =
        subCategories.firstWhere((element) => element.subCategoryId == lady);
    SubCategoryEntityUpdated premiumCategory =
        subCategories.firstWhere((element) => element.subCategoryId == premium);
    SubCategoryEntityUpdated intercityCategory = subCategories
        .firstWhere((element) => element.subCategoryId == intercity);
    if (id == captain) {
      if (!isMale) {
        showErrorMessage(
            context,
            context.isArabic
                ? "انت فتاة , يرجى التسجيل في السيدات او تغيير الجنس من الاعدادات"
                : "You are female, try register as a lady or change your gender from setting.");
        return;
      }
      if (selectedItem.isSelected == true) {
        if (premiumCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
          ladyCategory.isEnabled = true;
          captainCategory.isEnabled = true;
          captainCategory.isSelected = false;
        } else {
          captainCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (premiumCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
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
        showErrorMessage(
            context,
            context.isArabic
                ? "انت رجل , يرجى التسجيل في كابتن او تغيير الجنس من الاعدادات"
                : "You are male, try register as a captain or change your gender from setting.");
        return;
      }
      if (selectedItem.isSelected == true) {
        if (premiumCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
          captainCategory.isEnabled = true;
          ladyCategory.isEnabled = true;
          ladyCategory.isSelected = false;
        } else {
          ladyCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (premiumCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
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
        if (captainCategory.isSelected == true ||
            ladyCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
          premiumCategory.isSelected = false;
        } else {
          premiumCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (captainCategory.isSelected == true ||
            ladyCategory.isSelected == true ||
            intercityCategory.isSelected == true) {
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
        if (captainCategory.isSelected == true ||
            ladyCategory.isSelected == true ||
            premiumCategory.isSelected == true) {
          intercityCategory.isSelected = false;
        } else {
          intercityCategory.isSelected = false;
          subCategories.where((e) => e.isEnabled = true).toList();
        }
      } else {
        if (captainCategory.isSelected == true ||
            ladyCategory.isSelected == true ||
            premiumCategory.isSelected == true) {
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

  onSetSavedData(RideFeatureRegisterParams params) async {
    RegisterRideSpecialEntity? data = await Storage().getDriverEntity();
    print("data?.personalPicture${data?.personalPicture}");
    rideNameController.text = data?.driverFirstName ?? '';
    rideSurNameController.text = data?.driverLastName ?? '';
    rideDateOfBirthController.text = data?.birthday ?? '';
    ridePersonalDocLicenseNumController.text = data?.driverLicenseNumber ?? '';
    ridePersonalDocIdNumController.text = data?.idNumber ?? '';
    rideVehiclePlateNumberController.text = data?.plateInfo ?? '';
    ridePhoneNumberController.text = data?.phone ?? '';
    ridePricingPerKmController.text = data?.pricingPerKm ?? '';
    rideVehicleProductionYearController.text = data?.vehicleYear ?? '';
    RideBrandEntity? selectedBrand =
        state.brands?.firstWhere((element) => element.id == data?.vehicleBrand);
    RideModelEntity? selectedModel =
        state.models?.firstWhere((element) => element.id == data?.vehicleModel);
    emit(state.copyWith(
        hasAirCondition: data?.airConditioner,
        selectedGov: data?.city,
        isSmoking: data?.smoker,
        selectedBrand: selectedBrand,
        selectedColors:
            (state.colors != null || (state.colors?.isNotEmpty ?? false))
                ? state.colors?.firstWhere((e) => e.id == data?.vehicleColor)
                : null,
        selectedModel: selectedModel,
        selectedPlan: data?.workingType,
        personalPicture: XFile(data?.personalPicture ?? ''),
        savedRideSubCategories: data?.subcategoryIds ?? [],
        registerType: params.isSocket == true ? 'socket' : 'noSocket',
        isShipping: params.isShipping));
  }

  onSetSavedLoadingData(RideFeatureRegisterParams params) async {
    LoadingRegisterEntity? data = await Storage().getLoaderEntity();
    ridePersonalDocIdNumController.text = data?.idNumber ?? '';
    ridePhoneNumberController.text = data?.phone ?? '';
    rideVehiclePlateNumberController.text = data?.plateInformation ?? '';
    rideNameController.text = data?.firstName ?? '';
    rideSurNameController.text = data?.lastName ?? '';
    emit(state.copyWith(
      selectedGov: data?.location,
      savedRideSubCategories: (data?.categoryId.isNotEmpty ?? false)
          ? [data?.categoryId ?? '']
          : [],
      registerType: params.isSocket == true ? 'socket' : 'noSocket',
      isShipping: params.isShipping,
    ));
  }

  onSetSavedNoSocketData(RideFeatureRegisterParams params) async {
    RegisterRideNotSpecialEntity? data =
        await Storage().getDriverNoSocketEntity();
    print("RegisterRideNotSpecialEntity ${data?.toJson()}");
    rideNameController.text = data?.driverFirstName ?? '';
    rideSurNameController.text = data?.driverLastName ?? '';
    rideDateOfBirthController.text = data?.birthday ?? '';
    ridePersonalDocLicenseNumController.text = data?.driverLicenseNumber ?? '';
    ridePersonalDocIdNumController.text = data?.idNumber ?? '';
    rideVehiclePlateNumberController.text = data?.plateInfo ?? '';
    ridePhoneNumberController.text = data?.phone ?? '';
    emit(state.copyWith(
        savedRideSubCategories: (data?.subcategoryId.isNotEmpty ?? false)
            ? [data?.subcategoryId ?? '']
            : [],
        registerType: params.isSocket == true ? 'socket' : 'noSocket',
        isShipping: params.isShipping));
  }

  onSubmitSelectShippingSubCategories(BuildContext context) async {
    emit(state.copyWith(registerType: 'noSocket', isShipping: true));
    context.push(Routes.personalInformationScreen,
        extra: RideFeatureRegisterParams(
            isSocket: false,
            isShipping: true,
            subCategoriesId: (state.shippingSubCategories ?? [])
                .where((e) => e.isEnabled == true && e.isSelected == true)
                .toList()
                .map((e) => e.subCategoryId)
                .toList()));
  }

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

    if ((state.rideSubCategories ?? []).any((element) =>
        categoriesToCheck.contains(element.subCategoryId) &&
        element.isSelected == true)) {
      List<String> selectedSubCategories = (state.rideSubCategories ?? [])
          .where((e) => e.isEnabled == true && e.isSelected == true)
          .toList()
          .map((e) => e.subCategoryId)
          .toList();
      emit(state.copyWith(registerType: 'socket', isShipping: false));
      print("selectedSubCategories $selectedSubCategories");
      context.push(Routes.personalInformationScreen,
          extra: RideFeatureRegisterParams(
              isSocket: true,
              isShipping: false,
              subCategoriesId: selectedSubCategories));
    } else {
      emit(state.copyWith(registerType: 'noSocket', isShipping: false));
      context.push(Routes.personalInformationScreen,
          extra: RideFeatureRegisterParams(
              isSocket: false,
              isShipping: false,
              subCategoriesId: (state.rideSubCategories ?? [])
                  .where((e) => e.isEnabled == true && e.isSelected == true)
                  .toList()
                  .map((e) => e.subCategoryId)
                  .toList()));
    }
  }

  onSubmitUploadingCarLicense(
      BuildContext context, UploadRiderImagesParams params) async {
    emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
    DriverInfoEntity? driverInfo = state.driverInfo;
    LoadingInfoEntity? loaderInfo = state.loaderInfo;
    log('params.isShipping:=>:${params.isShipping}');
    showLoadingDialog(context, canPop: false);
    params.isShipping == true
        ? await LoadingMethodHelper().uploadCarLicense(
            licenseExpiryDate: rideVehicleExpireDateController.text,
            carLicenseBehindImage: state.vehicleBackPicture!,
            carLicenseFrontImage: state.vehicleFrontPicture!,
            onSuccessUploaded: (bool isSuccess) async {
              if (isSuccess == true) {
                loaderInfo?.isUploadCarLicense = true;
                emit(state.copyWith(
                    loaderInfo: loaderInfo,
                    status: RideRegisterStates.success));
                if (state.loaderInfo?.isUploadDriverLicense == true &&
                    state.loaderInfo?.isUploadDriverId == true &&
                    state.loaderInfo?.isUploadCarLicense == true &&
                    state.loaderInfo?.isUploadCarImage == true) {
                  await fetchLoaderInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع الصور بنجاح'
                        : "Successfully uploaded images");
              } else {
                context.pop();
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            })
        : await RideMethodHelper().uploadCarLicense(
            licenseExpiryDate: rideVehicleExpireDateController.text,
            carLicenseBehindImage: state.vehicleBackPicture!,
            carLicenseFrontImage: state.vehicleFrontPicture!,
            onSuccessUploaded: (bool isSuccess) async {
              if (isSuccess) {
                driverInfo?.isUploadCarLicense = true;
                emit(state.copyWith(
                    driverInfo: driverInfo,
                    status: RideRegisterStates.success));
                if (state.driverInfo?.isUploadDriverLicense == true &&
                    state.driverInfo?.isUploadDriverId == true &&
                    state.driverInfo?.isUploadCarLicense == true &&
                    state.driverInfo?.isUploadConfirmIdentifier == true &&
                    state.driverInfo?.isUploadDriverImage == true &&
                    state.driverInfo?.isUploadCarImage == true) {
                  await fetchRideDriverInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                emit(state.copyWith(status: RideRegisterStates.success));
              } else {
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            });
    params.isShipping == true
        ? await LoadingMethodHelper().uploadCarImage(
            carImage: state.vehiclePicture!,
            onSuccessUploaded: (bool isSuccess) async {
              if (isSuccess) {
                loaderInfo?.isUploadCarImage = true;
                emit(state.copyWith(
                    loaderInfo: loaderInfo,
                    status: RideRegisterStates.success));
                if (state.loaderInfo?.isUploadDriverLicense == true &&
                    state.loaderInfo?.isUploadDriverId == true &&
                    state.loaderInfo?.isUploadCarLicense == true &&
                    state.loaderInfo?.isUploadCarImage == true) {
                  await fetchLoaderInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                context.pop();
                context.pop();
                emit(state.copyWith(
                    status: RideRegisterStates.success,
                    isUploadCarImage: isSuccess));
              } else {
                context.pop();
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            })
        : await RideMethodHelper().uploadCarImage(
            carImage: state.vehiclePicture!,
            onSuccessUploaded: (bool isSuccess) async {
              log('uploadCarImageSuccessCubit $isSuccess');

              if (isSuccess) {
                driverInfo?.isUploadCarImage = true;
                emit(state.copyWith(
                    driverInfo: driverInfo,
                    status: RideRegisterStates.success));
                if (state.driverInfo?.isUploadDriverLicense == true &&
                    state.driverInfo?.isUploadDriverId == true &&
                    state.driverInfo?.isUploadCarLicense == true &&
                    state.driverInfo?.isUploadConfirmIdentifier == true &&
                    state.driverInfo?.isUploadDriverImage == true &&
                    state.driverInfo?.isUploadCarImage == true) {
                  await fetchRideDriverInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                context.pop();
                context.pop();
                emit(state.copyWith(status: RideRegisterStates.success));
              } else {
                context.pop();
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            });
    emit(state.copyWith(status: RideRegisterStates.success));
  }

  onSubmitUploadingCriminalRecord(BuildContext context) async {
    if (criminalRecordFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
      DriverInfoEntity? driverInfo = state.driverInfo;
      showLoadingDialog(context, canPop: false);
      await RideMethodHelper().uploadCriminalRecord(
          criminalRecordDate: rideCriminalRecordExpireDateController.text,
          criminalRecordImage: state.personalCriminalRecordPicture!,
          onSuccessUploaded: (bool isSuccess) async {
            if (isSuccess) {
              driverInfo?.isUploadCriminalRecord = true;
              emit(state.copyWith(
                  driverInfo: driverInfo, status: RideRegisterStates.success));
              if (state.driverInfo?.isUploadDriverLicense == true &&
                  state.driverInfo?.isUploadDriverId == true &&
                  state.driverInfo?.isUploadCarLicense == true &&
                  state.driverInfo?.isUploadConfirmIdentifier == true &&
                  state.driverInfo?.isUploadDriverImage == true &&
                  state.driverInfo?.isUploadCarImage == true) {
                await fetchRideDriverInfo(context, false);
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                        : "Successfully uploaded images, please wait for the approval of all data.");
              }
              context.pop();
              context.pop();
              emit(state.copyWith(status: RideRegisterStates.success));
            } else {
              context.pop();
              showErrorMessage(
                  context,
                  context.isArabic
                      ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                      : 'An error occurred while uploading images. Please try again.');
            }
          });
      emit(state.copyWith(
          status: RideRegisterStates.success, isUploadCriminalRecord: true));
    }
  }

  onSubmitUploadingDriverLicense(
      BuildContext context, UploadRiderImagesParams params) async {
    DriverInfoEntity? driverInfo = state.driverInfo;
    LoadingInfoEntity? loaderInfo = state.loaderInfo;
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
      if (state.selfieDriverLicensePicture == null &&
          params.isShipping != true) {
        showErrorMessage(
            context, "Please select selfie driver license picture");
        return;
      }
      showLoadingDialog(context, canPop: false);
      params.isShipping == true
          ? await LoadingMethodHelper().uploadDriverLicense(
              onSuccessUploaded: (isSuccess) async {
                if (isSuccess == true) {
                  loaderInfo?.isUploadDriverLicense = true;
                  emit(state.copyWith(
                      loaderInfo: loaderInfo,
                      status: RideRegisterStates.success));
                  if (state.loaderInfo?.isUploadDriverLicense == true &&
                      state.loaderInfo?.isUploadDriverId == true &&
                      state.loaderInfo?.isUploadCarLicense == true &&
                      state.loaderInfo?.isUploadCarImage == true) {
                    await fetchLoaderInfo(context, false);
                    showSuccessMessage(
                        context,
                        context.isArabic
                            ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                            : "Successfully uploaded images, please wait for the approval of all data.");
                  }
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع الصور بنجاح'
                          : "Successfully uploaded images");
                  context.pop();
                  context.pop();
                } else {
                  context.pop();
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                          : 'An error occurred while uploading images. Please try again.');
                }
              },
              drivingImageInFront: state.driverLicensePicture!,
              drivingImageBehind: state.backOfDriverLicensePicture!,
              drivingExpiryDate: rideDriverExpireDateController.text)
          : await RideMethodHelper().uploadDriverLicense(
              drivingImageInFront: state.driverLicensePicture!,
              drivingImageBehind: state.backOfDriverLicensePicture!,
              drivingExpiryDate: rideDriverExpireDateController.text,
              onSuccessUploaded: (bool isSuccess) async {
                if (isSuccess) {
                  driverInfo?.isUploadDriverLicense = true;
                  emit(state.copyWith(
                      driverInfo: driverInfo,
                      status: RideRegisterStates.success));
                  if (state.driverInfo?.isUploadDriverLicense == true &&
                      state.driverInfo?.isUploadDriverId == true &&
                      state.driverInfo?.isUploadCarLicense == true &&
                      state.driverInfo?.isUploadConfirmIdentifier == true &&
                      state.driverInfo?.isUploadDriverImage == true &&
                      state.driverInfo?.isUploadCarImage == true) {
                    await fetchRideDriverInfo(context, false);
                    showSuccessMessage(
                        context,
                        context.isArabic
                            ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                            : "Successfully uploaded images, please wait for the approval of all data.");
                  }
                  emit(state.copyWith(status: RideRegisterStates.success));
                } else {
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                          : 'An error occurred while uploading images. Please try again.');
                }
              });
      emit(state.copyWith(status: RideRegisterStates.success));
      if (params.isShipping != true) {
        await RideMethodHelper().confirmIdentity(
            verifyUserImage: state.selfieDriverLicensePicture!,
            onSuccessUploaded: (bool isSuccess) async {
              if (isSuccess) {
                driverInfo?.isUploadConfirmIdentifier = true;
                emit(state.copyWith(
                    driverInfo: driverInfo,
                    status: RideRegisterStates.success));
                if (state.driverInfo?.isUploadDriverLicense == true &&
                    state.driverInfo?.isUploadDriverId == true &&
                    state.driverInfo?.isUploadCarLicense == true &&
                    state.driverInfo?.isUploadConfirmIdentifier == true &&
                    state.driverInfo?.isUploadDriverImage == true &&
                    state.driverInfo?.isUploadCarImage == true) {
                  await fetchRideDriverInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                        : "Successfully uploaded images, please wait for the approval of all data.");
                context.pop();
                context.pop();
                emit(state.copyWith(status: RideRegisterStates.success));
              } else {
                context.pop();
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            });
      }
      emit(state.copyWith(status: RideRegisterStates.success));
    }
  }

  onSubmitUploadingDrugAnalysis(BuildContext context) async {
    if (drugAnalysisFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
      DriverInfoEntity? driverInfo = state.driverInfo;
      showLoadingDialog(context, canPop: false);
      await RideMethodHelper().uploadDrugAnalysis(
          dragAnalysisDate: rideDragAnalysisExpireDateController.text,
          dragAnalysis: state.personalDrugAnalysisPicture!,
          onSuccessUploaded: (bool isSuccess) async {
            if (isSuccess) {
              driverInfo?.isUploadDrugAnalysis = true;
              emit(state.copyWith(
                  driverInfo: driverInfo, status: RideRegisterStates.success));
              if (state.driverInfo?.isUploadDriverLicense == true &&
                  state.driverInfo?.isUploadDriverId == true &&
                  state.driverInfo?.isUploadCarLicense == true &&
                  state.driverInfo?.isUploadConfirmIdentifier == true &&
                  state.driverInfo?.isUploadDriverImage == true &&
                  state.driverInfo?.isUploadCarImage == true) {
                await fetchRideDriverInfo(context, false);
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                        : "Successfully uploaded images, please wait for the approval of all data.");
              }
              context.pop();
              context.pop();
              emit(state.copyWith(status: RideRegisterStates.success));
            } else {
              context.pop();
              showErrorMessage(
                  context,
                  context.isArabic
                      ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                      : 'An error occurred while uploading images. Please try again.');
            }
          });
      emit(state.copyWith(
          status: RideRegisterStates.success, isUploadDrugAnalysis: true));
    }
  }

  onSubmitUploadingId(
      BuildContext context, UploadRiderImagesParams params) async {
    emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
    DriverInfoEntity? driverInfo = state.driverInfo;
    LoadingInfoEntity? loaderInfo = state.loaderInfo;
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
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
      params.isShipping == true
          ? await LoadingMethodHelper().uploadDriverId(
              idImageInBehind: state.personalBackIdPicture!,
              idImageInFront: state.personalFrontIdPicture!,
              idExpiryDate: ridePersonalDocExpireDateController.text,
              onSuccessUploaded: (bool isSuccess) async {
                if (isSuccess == true) {
                  loaderInfo?.isUploadDriverId = true;
                  emit(state.copyWith(
                      loaderInfo: loaderInfo,
                      status: RideRegisterStates.success));
                  if (state.loaderInfo?.isUploadDriverLicense == true &&
                      state.loaderInfo?.isUploadDriverId == true &&
                      state.loaderInfo?.isUploadCarLicense == true &&
                      state.loaderInfo?.isUploadCarImage == true) {
                    await fetchLoaderInfo(context, false);
                  }
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع الصور بنجاح'
                          : "Successfully uploaded images");
                  context.pop();
                  context.pop();
                } else {
                  context.pop();
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                          : 'An error occurred while uploading images. Please try again.');
                }
              })
          : await RideMethodHelper().uploadDriverId(
              idImageInBehind: state.personalBackIdPicture!,
              idImageInFront: state.personalFrontIdPicture!,
              idExpiryDate: ridePersonalDocExpireDateController.text,
              onSuccessUploaded: (bool isSuccess) async {
                if (isSuccess) {
                  driverInfo?.isUploadDriverId = true;
                  emit(state.copyWith(
                      driverInfo: driverInfo,
                      status: RideRegisterStates.success));
                  if (state.driverInfo?.isUploadDriverLicense == true &&
                      state.driverInfo?.isUploadDriverId == true &&
                      state.driverInfo?.isUploadCarLicense == true &&
                      state.driverInfo?.isUploadConfirmIdentifier == true &&
                      state.driverInfo?.isUploadDriverImage == true &&
                      state.driverInfo?.isUploadCarImage == true) {
                    await fetchRideDriverInfo(context, false);
                    showSuccessMessage(
                        context,
                        context.isArabic
                            ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                            : "Successfully uploaded images, please wait for the approval of all data.");
                  }
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                  context.pop();
                  context.pop();
                  emit(state.copyWith(status: RideRegisterStates.success));
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
      driverInfo?.isUploadDriverId = true;
    }
  }

  onSubmitUploadingPersonalPhoto(
      BuildContext context, UploadRiderImagesParams params) async {
    if (personalPhotoFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
      DriverInfoEntity? driverInfo = state.driverInfo;
      LoadingInfoEntity? loaderInfo = state.loaderInfo;
      showLoadingDialog(context, canPop: false);
      if (params.isShipping != true) {
        await RideMethodHelper().uploadDriverImage(
            driverImage: state.personalPicture!,
            onSuccessUploaded: (bool isSuccess) async {
              if (isSuccess) {
                driverInfo?.isUploadDriverImage = true;
                emit(state.copyWith(
                    driverInfo: driverInfo,
                    status: RideRegisterStates.success));
                if (state.driverInfo?.isUploadDriverLicense == true &&
                    state.driverInfo?.isUploadDriverId == true &&
                    state.driverInfo?.isUploadCarLicense == true &&
                    state.driverInfo?.isUploadConfirmIdentifier == true &&
                    state.driverInfo?.isUploadDriverImage == true &&
                    state.driverInfo?.isUploadCarImage == true) {
                  await fetchRideDriverInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                context.pop();
                context.pop();
                emit(state.copyWith(status: RideRegisterStates.success));
              } else {
                context.pop();
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            });
      } else {
        await LoadingMethodHelper().uploadDriverImage(
            driverImage: state.personalPicture!,
            onSuccessUploaded: (bool isSuccess) async {
              if (isSuccess == true) {
                loaderInfo?.isUploadDriverImage = true;
                emit(state.copyWith(
                    loaderInfo: loaderInfo,
                    status: RideRegisterStates.success));
                if (state.loaderInfo?.isUploadDriverLicense == true &&
                    state.loaderInfo?.isUploadDriverId == true &&
                    state.loaderInfo?.isUploadCarLicense == true &&
                    state.loaderInfo?.isUploadDriverImage == true &&
                    state.loaderInfo?.isUploadCarImage == true) {
                  await fetchLoaderInfo(context, false);
                  showSuccessMessage(
                      context,
                      context.isArabic
                          ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                          : "Successfully uploaded images, please wait for the approval of all data.");
                }
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع الصور بنجاح'
                        : "Successfully uploaded images");
                context.pop();
                context.pop();
                emit(state.copyWith(status: RideRegisterStates.success));
              } else {
                context.pop();
                showErrorMessage(
                    context,
                    context.isArabic
                        ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                        : 'An error occurred while uploading images. Please try again.');
              }
            });
      }
      emit(state.copyWith(
          status: RideRegisterStates.success,
          isUploadTechnicalExamination: true));
    }
  }

  onSubmitUploadingTechnicalExamination(BuildContext context) async {
    if (terminalExaminationFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
      DriverInfoEntity? driverInfo = state.driverInfo;
      showLoadingDialog(context, canPop: false);
      await RideMethodHelper().uploadTechnicalExamination(
          technicalExaminationDate:
              rideTechnicalExaminationExpireDateController.text,
          technicalExaminationImage: state.personalTechnicalExaminationPicture!,
          onSuccessUploaded: (bool isSuccess) async {
            if (isSuccess) {
              driverInfo?.isUploadTechnicalExamination = true;
              emit(state.copyWith(
                  driverInfo: driverInfo, status: RideRegisterStates.success));
              if (state.driverInfo?.isUploadDriverLicense == true &&
                  state.driverInfo?.isUploadDriverId == true &&
                  state.driverInfo?.isUploadCarLicense == true &&
                  state.driverInfo?.isUploadConfirmIdentifier == true &&
                  state.driverInfo?.isUploadDriverImage == true &&
                  state.driverInfo?.isUploadCarImage == true) {
                await fetchRideDriverInfo(context, false);
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                        : "Successfully uploaded images, please wait for the approval of all data.");
              }
              context.pop();
              context.pop();
              emit(state.copyWith(status: RideRegisterStates.success));
            } else {
              context.pop();
              showErrorMessage(
                  context,
                  context.isArabic
                      ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.'
                      : 'An error occurred while uploading images. Please try again.');
            }
          });
      emit(state.copyWith(
          status: RideRegisterStates.success,
          isUploadTechnicalExamination: true));
    }
  }

  onUploadBackOfDriverLicensePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(backOfDriverLicensePicture: file));
        });
  }

  onUploadDriverLicensePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(driverLicensePicture: file));
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

  onUploadPersonalFrontIdPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalFrontIdPicture: file));
        });
  }

  onUploadPersonalPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalPicture: file));
        });
  }

  onUploadPersonalTechnicalExaminationPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(personalTechnicalExaminationPicture: file));
        });
  }

  onUploadSelfieDriverLicensePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(selfieDriverLicensePicture: file));
        });
  }

  onUploadVehicleBackPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(vehicleBackPicture: file));
        });
  }

  onUploadVehicleFrontPicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(vehicleFrontPicture: file));
        });
  }

  onUploadVehiclePicture(BuildContext context) {
    UploadImage().uploadImage(
        context: context,
        onUploaded: (file) {
          emit(state.copyWith(vehiclePicture: file));
        });
  }

  removeNewBrand() {
    newBrandAddedController.clear();
    RideBrandModel newBrand =
        RideBrandModel(id: '', brandNameAr: '', brandNameEn: '', logoUrl: '');
    removeNewModel();
    emit(
        state.copyWith(status: RideRegisterStates.success, newBrand: newBrand));
  }

  removeNewModel() {
    newModelAddedController.clear();
    RideCarModelModel newModel = RideCarModelModel(
      id: '',
      modelAr: '',
      modelEn: '',
    );
    emit(
        state.copyWith(status: RideRegisterStates.success, newModel: newModel));
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

  Future<void> _fetchUserLocation() async {
    emit(state.copyWith(status: RideRegisterStates.loading));

    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      String address = placemarks.isNotEmpty
          ? "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}"
          : "Unknown current Location";

      GetLocationFromAddressEntity currentLocation =
          GetLocationFromAddressEntity(
        lat: position.latitude,
        lng: position.longitude,
        address: address,
      );

      emit(state.copyWith(
          status: RideRegisterStates.success,
          currentLocation: currentLocation));
    } catch (e) {
      emit(state.copyWith(status: RideRegisterStates.error));
    }
  }
}
