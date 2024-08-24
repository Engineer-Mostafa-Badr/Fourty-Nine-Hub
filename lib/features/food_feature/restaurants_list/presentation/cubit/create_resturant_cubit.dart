import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/create_restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_meal_categories_with_count_restaurants_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/restaurant_shared_data.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_cities.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_governorates.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:image_picker/image_picker.dart';

part 'create_resturant_state.dart';

class CreateRestaurantCubit extends Cubit<CreateRestaurantState> {
  final RestaurantSharedData _shareCubit;
  final GetMealCategoriesWithCountRestaurantsUseCase
      _getSubSubcategoriesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final CreateRestaurantUseCase _createREstaurant;
  CreateRestaurantCubit(
      this._shareCubit,
      this._getSubSubcategoriesUseCase,
      this._getGovernoratesUseCase,
      this._getCitiesUseCase,
      this._createREstaurant)
      : super(CreateRestaurantInitial());

  Future<void> loadData() async {
    await _getSubCategories();
    await _getGovernorates();
  }

  Future<void> submit() async {
    _validationState();
    print(createRestaurantParams.toJson());
    if ((createRestaurantParams.name?.isNotEmpty ?? false) &&
        (createRestaurantParams.government?.isNotEmpty ?? false) &&
        (createRestaurantParams.city?.isNotEmpty ?? false) &&
        (createRestaurantParams.licenseMedia?.isNotEmpty ?? false) &&
        (createRestaurantParams.restaurantMedia?.isNotEmpty ?? false) &&
        (createRestaurantParams.mneu?.isNotEmpty ?? false)) {
      saveTextEditingController();
      emit(CreateResturantLoading("Creating Restaurant..."));
      final response = await _createREstaurant.call(createRestaurantParams);
      response.fold((failure) => emit(CreateResturantError(failure.toString())),
          (data) {
        emit(CreateRestaurantSuccess(
            "You have submitted your registration successfully, waiting for administration approval"));
      });
    } else {
      ScaffoldMessenger.of(
              AppPages.router.routerDelegate.navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(
        content: Text("Complete All Fields"),
        backgroundColor: Colors.red,
      ));
      return;
    }
  }

  bool isSubCategory = false;

  _validationState() {
    isSubCategory = (createRestaurantParams.subcategoryId?.isEmpty ?? true);

    emit(ValidationState(
      isCity: createRestaurantParams.city?.isEmpty ?? true,
      isGovernorate: createRestaurantParams.government?.isEmpty ?? true,
      isName: createRestaurantParams.name?.isEmpty ?? true,
      isRestaurantPhoto:
          createRestaurantParams.restaurantMedia?.isEmpty ?? true,
      isSubCategory: createRestaurantParams.subcategoryId?.isEmpty ?? true,
      isCommercialPhoto: (createRestaurantParams.licenseMedia?.length ?? 0) < 3,
      isCommercialFirstPage:
          (createRestaurantParams.licenseMedia?.length ?? 0) < 1,
      isCommercialSecondPage:
          (createRestaurantParams.licenseMedia?.length ?? 1) < 2,
      isCommercialThirdPage:
          (createRestaurantParams.licenseMedia?.length ?? 2) < 3,
      isMneu: createRestaurantParams.mneu?.isEmpty ?? true,
    ));
  }

  Future<void> _getSubCategories() async {
    if (_shareCubit.subCategories.isEmpty) {
      final response =
          await _getSubSubcategoriesUseCase(params: const PostCommentsParams());
      response.fold(
          (failure) => emit(CreateResturantError("Can't Load Specialities")),
          (data) {
        _shareCubit.subCategories = data;
        emit(CreateResturantSubCategoriesLoaded(data));
      });
    } else {
      emit(CreateResturantSubCategoriesLoaded(_shareCubit.subCategories));
    }
  }

  Future<void> _getGovernorates() async {
    if (_shareCubit.governorates.isEmpty) {
      final response = await _getGovernoratesUseCase.call(const NoParams());
      response.fold(
          (failure) => emit(CreateResturantError("Can't Load Governorates")),
          (data) {
        _shareCubit.governorates = data;
        emit(CreateRestaurantGovernoratesLoaded(data));
      });
    } else {
      emit(CreateRestaurantGovernoratesLoaded(_shareCubit.governorates));
    }
  }

  Future<void> _getCities(String governorateId) async {
    emit(CreateRestaurantCitiesLoading());
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) => emit(CreateResturantError("Can't Load Cities")),
      (data) => emit(CreateRestaurantCitiesLoaded(data)),
    );
  }

  final CreateRestaurantParams createRestaurantParams =
      CreateRestaurantParams();

  // ================================ dropdowns ===============================
  Future<void> selectGovernorate(GovernorateEntity value) async {
    createRestaurantParams.government = value.id;
    log("restaurantMediaParms: ${createRestaurantParams.toJson()}");
    await _getCities(value.id);
  }

  void selectCity(CityEntity value) {
    createRestaurantParams.city = value.id;
    log("restaurantMediaParms: ${createRestaurantParams.toJson()}");
  }

  void selectSubcategory(FoodCategoryEntity subCategoryModel) {
    createRestaurantParams.subcategoryId = subCategoryModel.id ?? "";
    log("restaurantMediaParms: ${createRestaurantParams.toJson()}");
  }

  // ================================= upload images =================================
  Future<void> _uploadImage(
      {required dynamic Function(UploadFileEntity) onUploaded}) async {
    if (createRestaurantParams.subcategoryId != null ||
        createRestaurantParams.subcategoryId != "") {
      emit(CreateResturantLoading("Uploading Image..."));
      await UploadFile().uploadImage(
        subCategoryId: createRestaurantParams.subcategoryId ?? "",
        onUploaded: (value) {
          onUploaded(value);
        },
      );
      emit(CreateResturantCloseLoading());
    } else {
      emit(CreateResturantError("Select Subcategory First"));
    }
  }

  List<XFile> restaurantImages = [];
  List<String> restaurantImagesIds = [];
  List<String> licensRestaurantImagesIds = [];

  Future<void> uploadProfileImage() async {
    await _uploadImage(onUploaded: (media) {
      restaurantImages.add(media.file);
      restaurantImagesIds.add(media.mediaId);
      createRestaurantParams.restaurantMedia = restaurantImagesIds;
      log("restaurantImagesIds: ${restaurantImagesIds.length}");
      log("restaurantMediaParms: ${createRestaurantParams.restaurantMedia?.length}");
      emit(CreateRestaurantUploadProfileImage(restaurantImages));
    });
  }

  Future<void> uploadLicenseFirstPageImage() async {
    await _uploadImage(onUploaded: (media) {
      licensRestaurantImagesIds.add(media.mediaId);
      createRestaurantParams.licenseMedia = licensRestaurantImagesIds;
      log("licensRestaurantImagesIds: ${licensRestaurantImagesIds.length}");
      log("licensRestaurantImagesIdsParms: ${createRestaurantParams.licenseMedia?.length}");
      emit(CreateRestaurantUploadLicenseFirstPageImage(media.file));
    });
  }

  Future<void> uploadLicenseSecondPageImage() async {
    await _uploadImage(onUploaded: (media) {
      licensRestaurantImagesIds.add(media.mediaId);
      createRestaurantParams.licenseMedia = licensRestaurantImagesIds;
      log("licensRestaurantImagesIds: ${licensRestaurantImagesIds.length}");
      log("licensRestaurantImagesIdsParms: ${createRestaurantParams.licenseMedia?.length}");
      emit(CreateRestaurantUploadLicenseSecondPageImage(media.file));
    });
  }

  Future<void> uploadLicenseThiredPageImage() async {
    await _uploadImage(onUploaded: (media) {
      licensRestaurantImagesIds.add(media.mediaId);
      createRestaurantParams.licenseMedia = licensRestaurantImagesIds;
      log("licensRestaurantImagesIds: ${licensRestaurantImagesIds.length}");
      log("licensRestaurantImagesIdsParms: ${createRestaurantParams.licenseMedia?.length}");
      emit(CreateRestaurantUploadLicenseThiredPageImage(media.file));
    });
  }

  final name = TextEditingController();
  final phoneController = TextEditingController();
  saveTextEditingController() {
    createRestaurantParams.name = name.text;
    log("restaurantMediaParms: ${createRestaurantParams.toJson()}");
  }

  @override
  Future<void> close() {
    name.dispose();
    phoneController.dispose();
    return super.close();
  }
}
