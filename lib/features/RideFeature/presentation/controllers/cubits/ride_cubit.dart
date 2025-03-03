import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_image.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_brands_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_car_colors_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_governorates.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_models_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_shipping_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/ride_category_entity.dart';
import '../../../domain/usecases/get_ride_categories_usecase.dart';

class RideCubit extends Cubit<RideState> {
  final GetRideCategoriesUseCase getRideCategories;
  final GetShippingCategoriesUsecase getShippingCategoriesUsecase;
  final GetRideGovernoratesUseCase getRideGovernoratesUseCase;
  final GetRideBrandsUseCase getRideBrandsUseCase;
  final GetRideModelsUseCase getRideModelsUseCase;
  final GetRideCarColorsUseCase getRideCarColorsUseCase;

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
  TextEditingController ridePersonalDocExpireDateController =
      TextEditingController();
  TextEditingController rideVehicleLicenseNumController =
      TextEditingController();
  TextEditingController rideVehicleExpireDateController =
      TextEditingController();
  TextEditingController rideDragAnalysisExpireDateController =
      TextEditingController();
  TextEditingController rideCriminalRecordExpireDateController =
      TextEditingController();
  TextEditingController rideVehicleProductionYearController =
      TextEditingController();
  TextEditingController ridePricingPerKmController = TextEditingController();

  RideCubit(
    this.getRideCategories,
    this.getShippingCategoriesUsecase, this.getRideGovernoratesUseCase, this.getRideBrandsUseCase, this.getRideModelsUseCase, this.getRideCarColorsUseCase,
  ) : super(const RideState());

  Future<void> fetchRideCategories(String userId) async {
    if (isClosed)
      return; // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result =
        await getRideCategories(userId);

    if (isClosed) return; // Double-check before emitting a state
    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (rideCategory) => emit(state.copyWith(
          status: RideStates.success, rideCategory: rideCategory,rideSubCategories: rideCategory.subCategories)),
    );
  }

  Future<void> fetchShippingCategories(String userId) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result =
        await getShippingCategoriesUsecase(userId);

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (rideCategory) => emit(state.copyWith(
          status: RideStates.success, shippingCategory: rideCategory)),
    );
  }

  loadRegisterData(BuildContext context)async{
    emit(state.copyWith(status: RideStates.loading));
    await Future.wait([
      fetchGovs(),
      fetchBrands(),
      fetchColors(context)
    ]);
    emit(state.copyWith(status: RideStates.success));
  }
  Future<void> fetchGovs() async {

    final Either<Failure, List<GovernorateEntity>> result =
        await getRideGovernoratesUseCase(const NoParams());

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (governorates) => emit(state.copyWith(
          status: RideStates.success, govs: governorates)),
    );
  }

  Future<void> fetchBrands() async {

    final Either<Failure, List<String>> result =
        await getRideBrandsUseCase(const NoParams());

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (data) => emit(state.copyWith(
          status: RideStates.success, brands: data)),
    );
  }

  List<String> subscriptionPlans = [
    'Percentage',
    'Subscribe Package',
  ];

  onSelectBrand(String brand){
    if(brand == state.selectedBrand)return;
    emit(state.copyWith(selectedBrand: brand,selectedModel: '',status: RideStates.loadingModels));
    fetchModels(brand);
  }

  onSelectModel(String model){
    emit(state.copyWith(selectedModel: model,status: RideStates.success));
  }
  onSelectColor(String color){
    emit(state.copyWith(selectedColors: color,status: RideStates.success));
  }
  onSelectGov(String color){
    emit(state.copyWith(selectedGov: color,status: RideStates.success));
  }
  onSelectPlan(String color){
    emit(state.copyWith(selectedPlan: color,status: RideStates.success));
  }



  Future<void> fetchModels(String brandId) async {

    final Either<Failure, List<String>> result =
        await getRideModelsUseCase(brandId);

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RideStates.error, failure: failure)),
      (data) => emit(state.copyWith(
          status: RideStates.success, models: data)),
    );
  }

  Future<void> fetchColors(BuildContext context) async {

    final Either<Failure, List<RideColorEntity>> result =
        await getRideCarColorsUseCase(const NoParams());

    result.fold(
      (failure) {
        print("failure${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
      (data) {
        print("data.length${data.length}");
        print("data.length${data[0].nameAr}");
        emit(state.copyWith(
          status: RideStates.success, colors: data));
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

  onSelectSubCategory(String id,BuildContext context){
    bool isMale = UserCubit.to.state.data?.gender == 'male';
    List<SubCategoryEntityUpdated> subCategories = [];
    subCategories.addAll(state.rideSubCategories ?? []);
    SubCategoryEntityUpdated selectedItem = subCategories.firstWhere((element) => element.subCategoryId == id);
    SubCategoryEntityUpdated captainCategory = subCategories.firstWhere((element) => element.subCategoryId == captain);
    SubCategoryEntityUpdated ladyCategory = subCategories.firstWhere((element) => element.subCategoryId == lady);
    SubCategoryEntityUpdated premiumCategory = subCategories.firstWhere((element) => element.subCategoryId == premium);
    SubCategoryEntityUpdated intercityCategory = subCategories.firstWhere((element) => element.subCategoryId == intercity);
    if(id == captain){
      if(!isMale){
        showErrorMessage(context, "You are female, try register as a lady or change your gender from setting.");
        return;
      }
      if(selectedItem.isSelected==true){
        print('captain');
        if(premiumCategory.isSelected==true||intercityCategory.isSelected==true){
          ladyCategory.isEnabled=true;
          captainCategory.isEnabled=true;
          captainCategory.isSelected=false;
        }else{
          captainCategory.isSelected=false;
          subCategories.where((e)=>e.isEnabled=true).toList();
        }
      }else{
        if(premiumCategory.isSelected==true||intercityCategory.isSelected==true){
          ladyCategory.isEnabled=false;
          ladyCategory.isSelected=false;
          captainCategory.isEnabled=true;
          captainCategory.isSelected=true;
        }else{
          subCategories.where((e)=>e.isEnabled=false).toList();
          subCategories.where((e)=>e.isSelected=false).toList();
          captainCategory.isEnabled=true;
          captainCategory.isSelected=true;
          premiumCategory.isEnabled=true;
          intercityCategory.isEnabled=true;
        }
      }
    }else if(id == lady){
      if(isMale){
        showErrorMessage(context, "You are male, try register as a captain or change your gender from setting.");
        return;
      }
      if(selectedItem.isSelected==true){
        if(premiumCategory.isSelected==true||intercityCategory.isSelected==true){
          captainCategory.isEnabled=true;
          ladyCategory.isEnabled=true;
          ladyCategory.isSelected=false;
        }else{
          ladyCategory.isSelected=false;
          subCategories.where((e)=>e.isEnabled=true).toList();
        }
      }else{
        if(premiumCategory.isSelected==true||intercityCategory.isSelected==true){
          captainCategory.isEnabled=false;
          captainCategory.isSelected=false;
          ladyCategory.isEnabled=true;
          ladyCategory.isSelected=true;
        }else{
          subCategories.where((e)=>e.isEnabled=false).toList();
          subCategories.where((e)=>e.isSelected=false).toList();
          ladyCategory.isEnabled=true;
          ladyCategory.isSelected=true;
          premiumCategory.isEnabled=true;
          intercityCategory.isEnabled=true;
        }
      }
    }else if(id == premium){
      if(selectedItem.isSelected==true){
        if(captainCategory.isSelected==true||ladyCategory.isSelected==true||intercityCategory.isSelected==true){
          premiumCategory.isSelected=false;
        }else{
          premiumCategory.isSelected=false;
          subCategories.where((e)=>e.isEnabled=true).toList();
        }
      }else{
        if(captainCategory.isSelected==true||ladyCategory.isSelected==true||intercityCategory.isSelected==true){
          premiumCategory.isSelected=true;
        }else{
          subCategories.where((e)=>e.isEnabled=false).toList();
          premiumCategory.isSelected=true;
          premiumCategory.isEnabled=true;
          intercityCategory.isEnabled=true;
          captainCategory.isEnabled=true;
          ladyCategory.isEnabled=true;
        }
      }
    }else if(id == intercity){
      if(selectedItem.isSelected==true){
        if(captainCategory.isSelected==true||ladyCategory.isSelected==true||premiumCategory.isSelected==true){
          intercityCategory.isSelected=false;
        }else{
          intercityCategory.isSelected=false;
          subCategories.where((e)=>e.isEnabled=true).toList();
        }
      }else{
        if(captainCategory.isSelected==true||ladyCategory.isSelected==true||premiumCategory.isSelected==true){
          intercityCategory.isSelected=true;
        }else{
          subCategories.where((e)=>e.isEnabled=false).toList();
          intercityCategory.isSelected=true;
          intercityCategory.isEnabled=true;
          premiumCategory.isEnabled=true;
          captainCategory.isEnabled=true;
          ladyCategory.isEnabled=true;
        }
      }
    }else{
      if(selectedItem.isSelected==true){
        selectedItem.isSelected=false;
        subCategories.where((e)=>e.isEnabled=true).toList();
      }else{
        subCategories.where((e)=>e.isEnabled=false).toList();
        selectedItem.isSelected=true;
        selectedItem.isEnabled=true;
      }
    }
    emit(state.copyWith(rideSubCategories: subCategories));
  }
}
