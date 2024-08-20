import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/create_restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/get_meal_categories_with_count_restaurants_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/restaurant_shared_data.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_cities.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_governorates.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:image_picker/image_picker.dart';

part 'create_resturant_state.dart';

class CreateRestaurantCubit extends Cubit<CreateRestaurantState> {
  final RestaurantSharedData _shareCubit;
  final GetMealCategoriesWithCountRestaurantsUseCase
      _getSubSubcategoriesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final CreateRestaurantUseCase _createDoctorUseCase;
  CreateRestaurantCubit(
      this._shareCubit,
      this._getSubSubcategoriesUseCase,
      this._getGovernoratesUseCase,
      this._getCitiesUseCase,
      this._createDoctorUseCase)
      : super(CreateRestaurantInitial());

  Future<void> loadData() async {
    await _getSubCategories();
    await _getGovernorates();
  }

  Future<void> submit() async {
    /*  if (formKey.currentState!.validate()) {
      _saveTextEditingControllers();
      _saveWorkDays();
      String? checkFilledMessage = _createDoctorParams.isFilled();
      if (checkFilledMessage == null) {
        emit(CreateResturantLoading("Creating Account..."));
        final response = await _createDoctorUseCase.call(_createDoctorParams);
        emit(CreateResturantCloseLoading());
        response.fold(
            (failure) => emit(CreateResturantError("Can't Create Doctor")),
            (data) => emit(CreateResturantSuccess(
                "You are submit sccessfuly. Please wait admin approve and abroval.")));
      } else {
        emit(CreateResturantError(checkFilledMessage));
      }
    } */
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

  final CreateRestaurantParams _createRestaurantParams =
      CreateRestaurantParams();

  // =============================== Timetables ===============================
  List<DoctorDayEntity> clinicTimetable = [
    DoctorDayEntity(day: WeekDays.saturday),
    DoctorDayEntity(day: WeekDays.sunday),
    DoctorDayEntity(day: WeekDays.monday),
    DoctorDayEntity(day: WeekDays.tuesday),
    DoctorDayEntity(day: WeekDays.wednesday),
    DoctorDayEntity(day: WeekDays.thursday),
    DoctorDayEntity(day: WeekDays.friday),
  ];

  List<DoctorDayEntity> callTimetable = [
    DoctorDayEntity(day: WeekDays.saturday),
    DoctorDayEntity(day: WeekDays.sunday),
    DoctorDayEntity(day: WeekDays.monday),
    DoctorDayEntity(day: WeekDays.tuesday),
    DoctorDayEntity(day: WeekDays.wednesday),
    DoctorDayEntity(day: WeekDays.thursday),
    DoctorDayEntity(day: WeekDays.friday),
  ];

  List<DoctorDayEntity> homeVisitTimetable = [
    DoctorDayEntity(day: WeekDays.saturday),
    DoctorDayEntity(day: WeekDays.sunday),
    DoctorDayEntity(day: WeekDays.monday),
    DoctorDayEntity(day: WeekDays.tuesday),
    DoctorDayEntity(day: WeekDays.wednesday),
    DoctorDayEntity(day: WeekDays.thursday),
    DoctorDayEntity(day: WeekDays.friday),
  ];

  // ================================ dropdowns ===============================
  Future<void> selectGovernorate(GovernorateEntity value) async {
    _createRestaurantParams.government = value.id;
    await _getCities(value.id);
  }

  void selectCity(CityEntity value) {
    _createRestaurantParams.city = value.id;
  }

  void selectSubcategory(FoodCategoryEntity subCategoryModel) {
    _createRestaurantParams.subcategoryId = subCategoryModel.id ?? "";
  }

  // ================================= upload images =================================
  Future<void> _uploadImage(
      {required dynamic Function(UploadFileEntity) onUploaded}) async {
    if (_createRestaurantParams.subcategoryId != null ||
        _createRestaurantParams.subcategoryId != "") {
      emit(CreateResturantLoading("Uploading Image..."));
      await UploadFile().uploadImage(
        subCategoryId: _createRestaurantParams.subcategoryId ?? "",
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

  Future<void> uploadProfileImage() async {
    await _uploadImage(onUploaded: (media) {
      _createRestaurantParams.restaurantMedia?.add(media.mediaId);
      restaurantImages.add(media.file);
      emit(CreateRestaurantUploadProfileImage(restaurantImages));
    });
  }

  Future<void> uploadIdFrontImage() async {
    await _uploadImage(onUploaded: (media) {
      _createRestaurantParams.ownerIdFrontMedia = media.mediaId;
      emit(CreateRestaurantUploadIdFrontImage(media.file));
    });
  }

  Future<void> uploadIdBehindImage() async {
    await _uploadImage(onUploaded: (media) {
      _createRestaurantParams.ownerIdBackMedia = media.mediaId;
      emit(CreateResturantUploadIdBehindImage(media.file));
    });
  }

  Future<void> uploadLicenseFirstPageImage() async {
    await _uploadImage(onUploaded: (media) {
      _createRestaurantParams.licenseMedia?.add(media.mediaId);
      emit(CreateRestaurantUploadLicenseFirstPageImage(media.file));
    });
  }

  Future<void> uploadLicenseSecondPageImage() async {
    await _uploadImage(onUploaded: (media) {
      restaurantImages.add(media.file);
      _createRestaurantParams.licenseMedia?.add(media.mediaId);
      emit(CreateRestaurantUploadLicenseSecondPageImage(media.file));
    });
  }

  Future<void> uploadLicenseThiredPageImage() async {
    await _uploadImage(onUploaded: (media) {
      restaurantImages.add(media.file);
      _createRestaurantParams.licenseMedia?.add(media.mediaId);
      emit(CreateRestaurantUploadLicenseThiredPageImage(media.file));
    });
  }

  void _saveTextEditingControllers() {
    _createRestaurantParams.name = name.text;
  }

  final name = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Future<void> close() {
    name.dispose();
    phoneController.dispose();
    return super.close();
  }
}
