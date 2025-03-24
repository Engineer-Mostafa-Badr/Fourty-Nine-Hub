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
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/loading_register_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/register_ride_not_special_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/register_ride_special_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/ride_register/ride_register_state.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/personal_information_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/upload_rider_images.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../core/error/failure.dart';

class RideRegisterCubit extends Cubit<RideRegisterState> {
  final GetRideGovernoratesUseCase getRideGovernoratesUseCase;
  final GetRideBrandsUseCase getRideBrandsUseCase;
  final GetRideModelsUseCase getRideModelsUseCase;
  final GetRideCarColorsUseCase getRideCarColorsUseCase;
  final RegisterRideSpecialUseCase registerRideSpecialUseCase;
  final RegisterRideNotSpecialUseCase registerRideNotSpecialUseCase;
  final GetRideDriverInfoUseCase getRideDriverInfoUseCase;
  final GetDriverPictureOptionalUseCase getDriverPictureOptionalUseCase;
  final GetCostPerKmUseCase getCostPerKmUseCase;
  final LoadingRegisterUseCase loadingRegisterUseCase;
  final GetLoadingInfoUseCase getLoadingInfoUseCase;

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
      ) : super( RideRegisterState());

  bool loadingHomeData = false;
  Future<void> initHome(BuildContext context) async {
    loadingHomeData = true;
    emit(state.copyWith(status: RideRegisterStates.loading));
    await Future.wait([
      _fetchUserLocation(),
      _fetchUserLocation(),
      fetchRideDriverInfo(context),
      getCostPerKm(),
      fetchLoaderInfo(context),
      fetchRideDriverPictureOptional(context),
      fetchRideGovernorates(),
    ]);
    loadingHomeData = false;
    emit(state.copyWith(status: RideRegisterStates.success));
  }

  Future<void> _fetchUserLocation() async {
    emit(state.copyWith(status: RideRegisterStates.loading));

    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      String address = placemarks.isNotEmpty ? "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}" : "Unknown current Location";

      GetLocationFromAddressEntity currentLocation = GetLocationFromAddressEntity(
        lat: position.latitude,
        lng: position.longitude,
        address: address,
      );

      emit(state.copyWith(status: RideRegisterStates.success, currentLocation: currentLocation));
    } catch (e) {
      emit(state.copyWith(status: RideRegisterStates.error));
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

  Future<void> getCostPerKm() async {
    if (isClosed) return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, CostPerKmEntity> result = await getCostPerKmUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
          (failure) => emit(state.copyWith(status: RideRegisterStates.error, failure: failure)),
          (data) {
        emit(state.copyWith(status: RideRegisterStates.success, costPerKm: data));
      },
    );
  }

  Future<void> fetchRideDriverInfo(BuildContext context) async {
    if (isClosed) return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, DriverInfoEntity> result = await getRideDriverInfoUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
          (failure) {
        emit(state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
          (info) {
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

  Future<void> fetchLoaderInfo(BuildContext context) async {
    if (isClosed) return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, LoadingInfoEntity> result = await getLoadingInfoUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
          (failure) {
        emit(state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
          (info) {
        emit(state.copyWith(status: RideRegisterStates.success, loaderInfo: info, registerType: 'noSocket', isShipping: true));
      },
    );
  }

  fetchRideUploadedImagesData(BuildContext context, UploadRiderImagesParams? params) async {
    if (params != null) emit(state.copyWith(isShipping: params.isShipping, registerType: params.isSocket == true ? 'socket' : 'noSocket'));
    emit(state.copyWith(status: RideRegisterStates.loading));
    await Future.wait(
        [fetchRideDriverPictureOptional(context), (state.isShipping == true || params?.isShipping == true) ? fetchLoaderInfo(context) : fetchRideDriverInfo(context)]);
    emit(state.copyWith(status: RideRegisterStates.success));
  }

  Future<void> fetchRideDriverPictureOptional(BuildContext context) async {
    if (isClosed) return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, DriverPictureOptionalEntity> result = await getDriverPictureOptionalUseCase(const NoParams());

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
          (failure) {
        emit(state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
          (data) {
        emit(state.copyWith(status: RideRegisterStates.success, pictureOptional: data));
      },
    );
  }


  Future<void> fetchRideGovernorates() async {
    emit(state.copyWith(status: RideRegisterStates.loading));

    final Either<Failure, List<GovernorateEntity>> result = await getRideGovernoratesUseCase(const NoParams());

    result.fold(
          (failure) => emit(state.copyWith(status: RideRegisterStates.error, failure: failure)),
          (governorates) async {
        RegisterRideSpecialEntity? data = await Storage().getDriverEntity();
        GovernorateEntity? selectedCity;
        if(data?.city!=null&&(data?.city.isNotEmpty??false)){
          selectedCity = governorates.firstWhereOrNull((element) => element.id == data?.city);
        }
        emit(state.copyWith(status: RideRegisterStates.success, governorates: governorates,city: selectedCity));
      },
    );
  }



  void emitRefreshState() {
    emit(state.copyWith(status: RideRegisterStates.success));
  }

  loadRegisterData(BuildContext context) async {
    emit(state.copyWith(status: RideRegisterStates.loading));
    await Future.wait([fetchGovs(), fetchBrands(context), fetchColors(context)]);
    emit(state.copyWith(status: RideRegisterStates.success));
  }

  Future<void> fetchGovs() async {
    final Either<Failure, List<GovernorateEntity>> result = await getRideGovernoratesUseCase(const NoParams());

    result.fold(
          (failure) => emit(state.copyWith(status: RideRegisterStates.error, failure: failure)),
          (governorates) async {
        RegisterRideSpecialEntity? cachedData = await Storage().getDriverEntity();
        String? cityId = cachedData?.city;
        GovernorateEntity? selectedCity;
        if (cityId != null && (cityId.isNotEmpty)) {
          selectedCity=governorates.firstWhere((element) => element.id == cityId);
          onSelectGov(cityId);
        }
        emit(state.copyWith(status: RideRegisterStates.success, govs: governorates,city: selectedCity));
      },
    );
  }

  Future<void> fetchBrands(BuildContext context) async {
    final Either<Failure, List<String>> result = await getRideBrandsUseCase(const NoParams());

    result.fold(
          (failure) => emit(state.copyWith(status: RideRegisterStates.error, failure: failure)),
          (data) async {
        RegisterRideSpecialEntity? cachedData = await Storage().getDriverEntity();
        String? brand = cachedData?.vehicleBrand;
        if(brand!=null&&(brand.isNotEmpty))await onSelectBrand(brand, context);
        emit(state.copyWith(status: RideRegisterStates.success, brands: data,selectedBrand: brand));
      },
    );
  }

  List<String> subscriptionPlans = [
    'Percentage',
    'Subscribe Package',
  ];

  List<String> models = [];
  onSelectBrand(String brand, BuildContext context) async {
    if (brand == state.selectedBrand) return;
    emit(state.copyWith(selectedBrand: brand, selectedModel: '', status: RideRegisterStates.loadingModels));
    await fetchModels(brand, context);
    emit(state.copyWith(status: RideRegisterStates.success));
  }

  onSelectModel(String model) {
    emit(state.copyWith(selectedModel: model, status: RideRegisterStates.success));
  }

  onSelectColor(RideColorEntity color) {
    emit(state.copyWith(selectedColors: color, status: RideRegisterStates.success));
  }

  onSelectGov(String gov) {
    emit(state.copyWith(selectedGov: gov, status: RideRegisterStates.success));
  }

  onSelectPlan(String plan) {
    String selectedPlan = plan == 'Percentage' ? 'percentage' : 'subscribePackage';
    emit(state.copyWith(selectedPlan: selectedPlan, status: RideRegisterStates.success));
  }

  Future<void> fetchModels(String brandId, BuildContext context) async {
    models.clear();
    emit(state.copyWith(colors: [], status: RideRegisterStates.loadingModels));
    final Either<Failure, List<String>> result = await getRideModelsUseCase(brandId);

    result.fold(
          (failure) {
        emit(state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
          (data) async {
        models.addAll(data);
        // RegisterRideSpecialEntity? cachedData = await Storage().getDriverEntity();
        // String? model = cachedData?.vehicleModel;
        // if (model != null && (model.isNotEmpty)) {
        //   onSelectModel(model);
        // }
        emit(state.copyWith(status: RideRegisterStates.success, models: data));
      },
    );
  }

  Future<void> fetchColors(BuildContext context) async {
    final Either<Failure, List<RideColorEntity>> result = await getRideCarColorsUseCase(const NoParams());

    result.fold(
          (failure) {
        emit(state.copyWith(status: RideRegisterStates.error, failure: failure));
      },
          (data) async {
        RegisterRideSpecialEntity? cachedData = await Storage().getDriverEntity();
        String? color = cachedData?.vehicleColor;
        RideColorEntity? selectedColor;
        if (color != null && (color.isNotEmpty)) {
          selectedColor=data.firstWhere((element) => element.id == color);
          onSelectColor(selectedColor);
        }
        emit(state.copyWith(status: RideRegisterStates.success, colors: data,color: selectedColor));
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

  onSubmitSelectShippingSubCategories(BuildContext context) async {
    emit(state.copyWith(registerType: 'noSocket', isShipping: true));
    context.push(Routes.personalInformationScreen);
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

  onChangeSmokingValue() {
    emit(state.copyWith(isSmoking: !(state.isSmoking ?? false), status: RideRegisterStates.success));
  }

  onChangeAirCondition() {
    emit(state.copyWith(hasAirCondition: !(state.hasAirCondition ?? false), status: RideRegisterStates.success));
  }

  onSubmitUploadingId(BuildContext context) async {
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
      state.isShipping == true
          ? await LoadingMethodHelper().uploadDriverId(
          idImageInBehind: state.personalBackIdPicture!,
          idImageInFront: state.personalFrontIdPicture!,
          idExpiryDate: ridePersonalDocExpireDateController.text,
          onSuccessUploaded: (bool isSuccess) async {
            if (isSuccess == true) {
              loaderInfo?.isUploadDriverId = true;
              emit(state.copyWith(loaderInfo: loaderInfo, status: RideRegisterStates.success));
              if (state.loaderInfo?.isUploadDriverLicense == true &&
                  state.loaderInfo?.isUploadDriverId == true &&
                  state.loaderInfo?.isUploadCarLicense == true &&
                  state.loaderInfo?.isUploadCarImage == true) {
                await fetchLoaderInfo(context);
              }
              showSuccessMessage(context, context.isArabic ? 'تم رفع الصور بنجاح' : "Successfully uploaded images");
              context.pop();
              context.pop();
            } else {
              context.pop();
              showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
            }
          })
          : await RideMethodHelper()
          .uploadDriverId(idImageInBehind: state.personalBackIdPicture!, idImageInFront: state.personalFrontIdPicture!, idExpiryDate: ridePersonalDocExpireDateController.text, onSuccessUploaded: (bool isSuccess) async{
        if (isSuccess) {
          driverInfo?.isUploadDriverId = true;
          emit(state.copyWith(driverInfo: driverInfo, status: RideRegisterStates.success));
          if (state.driverInfo?.isUploadDriverLicense == true &&
              state.driverInfo?.isUploadDriverId == true &&
              state.driverInfo?.isUploadCarLicense == true &&
              state.driverInfo?.isUploadConfirmIdentifier == true &&
              state.driverInfo?.isUploadDriverImage == true &&
              state.driverInfo?.isUploadCarImage == true) {
            await fetchRideDriverInfo(context);
            showSuccessMessage(context,
                context.isArabic ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.' : "Successfully uploaded images, please wait for the approval of all data.");
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
          showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
        }
      });
      Future.delayed(const Duration(seconds: 3));
      driverInfo?.isUploadDriverId = true;
    }
  }

  onSubmitUploadingDriverLicense(BuildContext context) async {
    DriverInfoEntity? driverInfo = state.driverInfo;
    LoadingInfoEntity? loaderInfo = state.loaderInfo;
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
          onSuccessUploaded: (isSuccess) async {
            if (isSuccess == true) {
              loaderInfo?.isUploadDriverLicense = true;
              emit(state.copyWith(loaderInfo: loaderInfo, status: RideRegisterStates.success));
              if (state.loaderInfo?.isUploadDriverLicense == true &&
                  state.loaderInfo?.isUploadDriverId == true &&
                  state.loaderInfo?.isUploadCarLicense == true &&
                  state.loaderInfo?.isUploadCarImage == true) {
                await fetchLoaderInfo(context);
                showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.'
                        : "Successfully uploaded images, please wait for the approval of all data.");
              }
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
          drivingImageInFront: state.driverLicensePicture!, drivingImageBehind: state.backOfDriverLicensePicture!, drivingExpiryDate: rideDriverExpireDateController.text, onSuccessUploaded: (bool isSuccess) async{
        if (isSuccess) {
          driverInfo?.isUploadDriverLicense = true;
          emit(state.copyWith(driverInfo: driverInfo, status: RideRegisterStates.success));
          if (state.driverInfo?.isUploadDriverLicense == true &&
              state.driverInfo?.isUploadDriverId == true &&
              state.driverInfo?.isUploadCarLicense == true &&
              state.driverInfo?.isUploadConfirmIdentifier == true &&
              state.driverInfo?.isUploadDriverImage == true &&
              state.driverInfo?.isUploadCarImage == true) {
            await fetchRideDriverInfo(context);
            showSuccessMessage(context,
                context.isArabic ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.' : "Successfully uploaded images, please wait for the approval of all data.");
          }
          emit(state.copyWith(status: RideRegisterStates.success));
        } else {
          showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
        }
      });
      emit(state.copyWith(status: RideRegisterStates.success));
      if (state.isShipping != true) {
        await RideMethodHelper().confirmIdentity(verifyUserImage: state.selfieDriverLicensePicture!, onSuccessUploaded: (bool isSuccess) async{
          if (isSuccess) {
            driverInfo?.isUploadConfirmIdentifier = true;
            emit(state.copyWith(driverInfo: driverInfo, status: RideRegisterStates.success));
            if (state.driverInfo?.isUploadDriverLicense == true &&
                state.driverInfo?.isUploadDriverId == true &&
                state.driverInfo?.isUploadCarLicense == true &&
                state.driverInfo?.isUploadConfirmIdentifier == true &&
                state.driverInfo?.isUploadDriverImage == true &&
                state.driverInfo?.isUploadCarImage == true) {
              await fetchRideDriverInfo(context);
              showSuccessMessage(context,
                  context.isArabic ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.' : "Successfully uploaded images, please wait for the approval of all data.");
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
            showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
          }
        });
      }
      emit(state.copyWith(status: RideRegisterStates.success));
    }
  }

  onSubmitUploadingCarLicense(BuildContext context) async {
    emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
    DriverInfoEntity? driverInfo = state.driverInfo;
    LoadingInfoEntity? loaderInfo = state.loaderInfo;

    showLoadingDialog(context, canPop: false);
    state.isShipping == true
        ? await LoadingMethodHelper().uploadCarLicense(
        licenseExpiryDate: rideVehicleExpireDateController.text,
        carLicenseBehindImage: state.vehicleBackPicture!,
        carLicenseFrontImage: state.vehicleFrontPicture!,
        onSuccessUploaded: (bool isSuccess) async {
          if (isSuccess == true) {
            loaderInfo?.isUploadCarLicense = true;
            emit(state.copyWith(loaderInfo: loaderInfo, status: RideRegisterStates.success));
            if (state.loaderInfo?.isUploadDriverLicense == true &&
                state.loaderInfo?.isUploadDriverId == true &&
                state.loaderInfo?.isUploadCarLicense == true &&
                state.loaderInfo?.isUploadCarImage == true) {
              await fetchLoaderInfo(context);
              showSuccessMessage(context,
                  context.isArabic ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.' : "Successfully uploaded images, please wait for the approval of all data.");
            }
            showSuccessMessage(context, context.isArabic ? 'تم رفع الصور بنجاح' : "Successfully uploaded images");
          } else {
            context.pop();
            showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
          }
        })
        : await RideMethodHelper().uploadCarLicense(
        licenseExpiryDate: rideVehicleExpireDateController.text, carLicenseBehindImage: state.vehicleBackPicture!, carLicenseFrontImage: state.vehicleFrontPicture!, onSuccessUploaded: (bool isSuccess) async{
      if (isSuccess) {
        driverInfo?.isUploadCarLicense = true;
        emit(state.copyWith(driverInfo: driverInfo, status: RideRegisterStates.success));
        if (state.driverInfo?.isUploadDriverLicense == true &&
            state.driverInfo?.isUploadDriverId == true &&
            state.driverInfo?.isUploadCarLicense == true &&
            state.driverInfo?.isUploadConfirmIdentifier == true &&
            state.driverInfo?.isUploadDriverImage == true &&
            state.driverInfo?.isUploadCarImage == true) {
          await fetchRideDriverInfo(context);
          showSuccessMessage(context,
              context.isArabic ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.' : "Successfully uploaded images, please wait for the approval of all data.");
        }
        emit(state.copyWith(status: RideRegisterStates.success));
      } else {
        showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
      }
    });
    state.isShipping == true
        ? await LoadingMethodHelper().uploadCarImage(
        carImage: state.vehiclePicture!,
        onSuccessUploaded: (bool isSuccess) async {
          if (isSuccess) {
            loaderInfo?.isUploadCarImage = true;
            emit(state.copyWith(loaderInfo: loaderInfo, status: RideRegisterStates.success));
            if (state.loaderInfo?.isUploadDriverLicense == true &&
                state.loaderInfo?.isUploadDriverId == true &&
                state.loaderInfo?.isUploadCarLicense == true &&
                state.loaderInfo?.isUploadCarImage == true) {
              await fetchLoaderInfo(context);
              showSuccessMessage(context,
                  context.isArabic ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.' : "Successfully uploaded images, please wait for the approval of all data.");
            }
            context.pop();
            context.pop();
            emit(state.copyWith(status: RideRegisterStates.success, isUploadCarImage: isSuccess));
          } else {
            context.pop();
            showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
          }
        })
        : await RideMethodHelper().uploadCarImage(carImage: state.vehiclePicture!,onSuccessUploaded: (bool isSuccess) async {
      log('uploadCarImageSuccessCubit $isSuccess');

      if (isSuccess) {
        driverInfo?.isUploadCarImage = true;
        emit(state.copyWith(driverInfo: driverInfo, status: RideRegisterStates.success));
        if (state.driverInfo?.isUploadDriverLicense == true &&
            state.driverInfo?.isUploadDriverId == true &&
            state.driverInfo?.isUploadCarLicense == true &&
            state.driverInfo?.isUploadConfirmIdentifier == true &&
            state.driverInfo?.isUploadDriverImage == true &&
            state.driverInfo?.isUploadCarImage == true) {
          await fetchRideDriverInfo(context);
          showSuccessMessage(context,
              context.isArabic ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.' : "Successfully uploaded images, please wait for the approval of all data.");
        }
        context.pop();
        context.pop();
        emit(state.copyWith(status: RideRegisterStates.success));
      } else {
        context.pop();
        showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
      }
    });
    emit(state.copyWith(status: RideRegisterStates.success));
  }

  onSubmitUploadingDrugAnalysis(BuildContext context) async {
    if (drugAnalysisFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
      DriverInfoEntity? driverInfo = state.driverInfo;
      showLoadingDialog(context, canPop: false);
      await RideMethodHelper().uploadDrugAnalysis(dragAnalysisDate: rideDragAnalysisExpireDateController.text, dragAnalysis: state.personalDrugAnalysisPicture!, onSuccessUploaded: (bool isSuccess) async{
        if (isSuccess) {
          driverInfo?.isUploadDrugAnalysis = true;
          emit(state.copyWith(driverInfo: driverInfo, status: RideRegisterStates.success));
          if (state.driverInfo?.isUploadDriverLicense == true &&
              state.driverInfo?.isUploadDriverId == true &&
              state.driverInfo?.isUploadCarLicense == true &&
              state.driverInfo?.isUploadConfirmIdentifier == true &&
              state.driverInfo?.isUploadDriverImage == true &&
              state.driverInfo?.isUploadCarImage == true) {
            await fetchRideDriverInfo(context);
            showSuccessMessage(context,
                context.isArabic ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.' : "Successfully uploaded images, please wait for the approval of all data.");
          }
          context.pop();
          context.pop();
          emit(state.copyWith(status: RideRegisterStates.success));
        } else {
          context.pop();
          showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
        }
      });
      emit(state.copyWith(status: RideRegisterStates.success, isUploadDrugAnalysis: true));
    }
  }

  onSubmitUploadingCriminalRecord(BuildContext context) async {
    if (criminalRecordFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
      DriverInfoEntity? driverInfo = state.driverInfo;
      showLoadingDialog(context, canPop: false);
      await RideMethodHelper().uploadCriminalRecord(criminalRecordDate: rideCriminalRecordExpireDateController.text, criminalRecordImage: state.personalCriminalRecordPicture!, onSuccessUploaded: (bool isSuccess) async{
        if (isSuccess) {
          driverInfo?.isUploadCriminalRecord = true;
          emit(state.copyWith(driverInfo: driverInfo, status: RideRegisterStates.success));
          if (state.driverInfo?.isUploadDriverLicense == true &&
              state.driverInfo?.isUploadDriverId == true &&
              state.driverInfo?.isUploadCarLicense == true &&
              state.driverInfo?.isUploadConfirmIdentifier == true &&
              state.driverInfo?.isUploadDriverImage == true &&
              state.driverInfo?.isUploadCarImage == true) {
            await fetchRideDriverInfo(context);
            showSuccessMessage(context,
                context.isArabic ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.' : "Successfully uploaded images, please wait for the approval of all data.");
          }
          context.pop();
          context.pop();
          emit(state.copyWith(status: RideRegisterStates.success));
        } else {
          context.pop();
          showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
        }
      });
      emit(state.copyWith(status: RideRegisterStates.success, isUploadCriminalRecord: true));
    }
  }

  onSubmitUploadingTechnicalExamination(BuildContext context) async {
    if (terminalExaminationFormKey.currentState!.validate()) {
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));
      DriverInfoEntity? driverInfo = state.driverInfo;
      showLoadingDialog(context, canPop: false);
      await RideMethodHelper().uploadTechnicalExamination(
          technicalExaminationDate: rideTechnicalExaminationExpireDateController.text, technicalExaminationImage: state.personalTechnicalExaminationPicture!, onSuccessUploaded: (bool isSuccess) async{
        if (isSuccess) {
          driverInfo?.isUploadTechnicalExamination = true;
          emit(state.copyWith(driverInfo: driverInfo, status: RideRegisterStates.success));
          if (state.driverInfo?.isUploadDriverLicense == true &&
              state.driverInfo?.isUploadDriverId == true &&
              state.driverInfo?.isUploadCarLicense == true &&
              state.driverInfo?.isUploadConfirmIdentifier == true &&
              state.driverInfo?.isUploadDriverImage == true &&
              state.driverInfo?.isUploadCarImage == true) {
            await fetchRideDriverInfo(context);
            showSuccessMessage(context,
                context.isArabic ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.' : "Successfully uploaded images, please wait for the approval of all data.");
          }
          context.pop();
          context.pop();
          emit(state.copyWith(status: RideRegisterStates.success));
        } else {
          context.pop();
          showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
        }
      });
      emit(state.copyWith(status: RideRegisterStates.success, isUploadTechnicalExamination: true));
    }
  }

  onSaveRegisterData(BuildContext context) async {
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
        personalPicture: state.personalPicture?.path,
        isShipping: state.isShipping,
        subcategoryIds: (state.rideSubCategories ?? []).where((e) => e.isEnabled == true).toList().map((e) => e.subCategoryId).toList());
    await Storage().saveDriverEntity(params);
    context.go(Routes.RIDE_HOME);
  }
  onSaveRegisterNoSocketData(BuildContext context) async {
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
    await Storage().saveDriverNoSocketEntity(params);
    context.go(Routes.RIDE_HOME);
  }

  onSetSavedData(RideFeatureRegisterParams params) async {
    RegisterRideSpecialEntity? data = await Storage().getDriverEntity();
    print("data?.personalPicture${data?.personalPicture}");
    rideNameController.text = data?.driverFirstName??'';
    rideSurNameController.text = data?.driverLastName??'';
    rideDateOfBirthController.text = data?.birthday??'';
    ridePersonalDocLicenseNumController.text = data?.driverLicenseNumber??'';
    ridePersonalDocIdNumController.text = data?.idNumber??'';
    rideVehiclePlateNumberController.text = data?.plateInfo??'';
    ridePhoneNumberController.text = data?.phone??'';
    ridePricingPerKmController.text = data?.pricingPerKm??'';
    rideVehicleProductionYearController.text = data?.vehicleYear??'';
    emit(state.copyWith(
      hasAirCondition:data?.airConditioner,
      selectedGov:data?.city,
      isSmoking:data?.smoker,
      selectedBrand:data?.vehicleBrand,
      selectedColors:(state.colors!=null||(state.colors?.isNotEmpty??false))?state.colors?.firstWhere((e) => e.id == data?.vehicleColor):null,
      selectedModel:data?.vehicleModel,
      selectedPlan:data?.workingType,
      personalPicture:XFile(data?.personalPicture??''),
      savedRideSubCategories:data?.subcategoryIds??[],
      registerType: params.isSocket==true?'socket':'noSocket',
        isShipping:params.isShipping
    ));
  }
  onSetSavedNoSocketData(RideFeatureRegisterParams params) async {
    RegisterRideSpecialEntity? data = await Storage().getDriverEntity();
    print("data?.personalPicture${data?.personalPicture}");
    rideNameController.text = data?.driverFirstName??'';
    rideSurNameController.text = data?.driverLastName??'';
    rideDateOfBirthController.text = data?.birthday??'';
    ridePersonalDocLicenseNumController.text = data?.driverLicenseNumber??'';
    ridePersonalDocIdNumController.text = data?.idNumber??'';
    rideVehiclePlateNumberController.text = data?.plateInfo??'';
    ridePhoneNumberController.text = data?.phone??'';
    emit(state.copyWith(
      hasAirCondition:data?.airConditioner,
      selectedGov:data?.city,
      isSmoking:data?.smoker,
      selectedBrand:data?.vehicleBrand,
      selectedModel:data?.vehicleModel,
      selectedPlan:data?.workingType,
      personalPicture:XFile(data?.personalPicture??''),
      savedRideSubCategories:data?.subcategoryIds??[],
      registerType: params.isSocket==true?'socket':'noSocket',
        isShipping:params.isShipping
    ));
  }

  //model brand color city plan


  bool isLoadingSubmitRegister = false;

  onRegister(BuildContext context) async {
    DriverInfoEntity? driverInfo = state.driverInfo;
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
          emit(state.copyWith(status: RideRegisterStates.error, failure: failure));
        },
            (data) async {
          await RideMethodHelper().uploadDriverImage(driverImage: state.personalPicture!, onSuccessUploaded: (bool isSuccess) async{
            if (isSuccess) {
              driverInfo?.isUploadDriverImage = true;
              emit(state.copyWith(driverInfo: driverInfo, status: RideRegisterStates.success));
              if (state.driverInfo?.isUploadDriverLicense == true &&
                  state.driverInfo?.isUploadDriverId == true &&
                  state.driverInfo?.isUploadCarLicense == true &&
                  state.driverInfo?.isUploadConfirmIdentifier == true &&
                  state.driverInfo?.isUploadDriverImage == true &&
                  state.driverInfo?.isUploadCarImage == true) {
                await fetchRideDriverInfo(context);
                showSuccessMessage(context,
                    context.isArabic ? 'تم رفع جميع الصور برجاء انتظار الموافقة علي جميع البيانات.' : "Successfully uploaded images, please wait for the approval of all data.");
              }
              context.pop();
              context.pop();
              emit(state.copyWith(status: RideRegisterStates.success));
            } else {
              context.pop();
              showErrorMessage(context, context.isArabic ? 'حدث مشكلة في رفع الصور. برجاء المحاولة مره اخري.' : 'An error occurred while uploading images. Please try again.');
            }
          });
          await fetchRideDriverInfo(context);
          await fetchRideDriverPictureOptional(context);
          showSuccessMessage(context, context.isArabic ? "تم التسجيل بنجاح" : "Registered successfully");
          context.pushReplacement(Routes.UploadRiderImages);
          isLoadingSubmitRegister = false;
          emit(state.copyWith(status: RideRegisterStates.success));
        },
      );
    }
  }

  onNoSocketRegister(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoadingSubmitRegister = true;
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));

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
          emit(state.copyWith(status: RideRegisterStates.error, failure: failure));
        },
            (data) async {
          isLoadingSubmitRegister = false;
          await fetchRideDriverInfo(context);
          emit(state.copyWith(status: RideRegisterStates.success));
          showSuccessMessage(context, context.isArabic ? "تم التسجيل بنجاح" : "Registered successfully");
          context.pushReplacement(Routes.completeRegisterScreen);
          // context.pushReplacement(Routes.UploadRiderImages);
        },
      );
    }
  }

  onLoadingRegister(BuildContext context) async {
    context.pushReplacement(Routes.completeRegisterScreen);

    if (formKey.currentState!.validate()) {
      isLoadingSubmitRegister = true;
      emit(state.copyWith(status: RideRegisterStates.loadingSubmit));

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
          emit(state.copyWith(status: RideRegisterStates.error, failure: failure));
        },
            (data) async {
          isLoadingSubmitRegister = false;
          await fetchLoaderInfo(context);
          emit(state.copyWith(status: RideRegisterStates.success));
          showSuccessMessage(context, context.isArabic ? "تم التسجيل بنجاح" : "Registered successfully");
          context.pushReplacement(Routes.completeRegisterScreen);
        },
      );
    }
  }

}
