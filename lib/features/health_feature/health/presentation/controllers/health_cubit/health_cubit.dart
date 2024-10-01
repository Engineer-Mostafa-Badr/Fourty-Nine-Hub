import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/filter_option_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_medical_services.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_user_upcoming_appointments.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/is_doctor_approval_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/is_doctor_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/delete_favorite_category_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_subcategory.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:http/http.dart' as http;

import '../../../../create_doctor/domain/entities/governorate_entity.dart';
import '../../../../create_doctor/domain/usecases/get_governorates.dart';
import '../../../domain/entities/appointment_booking_entity.dart';

part 'health_state.dart';

class HealthCubit extends Cubit<HealthState> {
  final HealthSharedData _healthShare;
  final GetUserUpcomingAppointmentsUseCase _getUserUpcomingAppointmentsUseCase;
  final GetHealthSubcategoriesUseCase _getHealthSubcategoriesUseCase;
  final GetMedicalServicesUseCase _getMedicalServicesUseCase;
  final ToggleFavoriteSubcategoryUseCase _toggleFavoriteSubcategoryUseCase;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;
  final DeleteFavoriteCategoryUseCase _deleteFavoriteCategoryUseCase;
  final IsDoctorUsecase _isDoctorUseCase;
  final IsDoctorApprovalUsecase _isDoctorApprovalUsecase;
  final GetMainCategoryDetailsUseCase _getMainCategoryDetailsUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;

  HealthCubit(
      this._getUserUpcomingAppointmentsUseCase,
      this._healthShare,
      this._getHealthSubcategoriesUseCase,
      this._getMedicalServicesUseCase,
      this._toggleFavoriteSubcategoryUseCase,
      this._isDoctorUseCase,
      this._getMainCategoryDetailsUseCase,
      this._getGovernoratesUseCase,
      this._isDoctorApprovalUsecase,
      this._toggleFavoriteCategoryUseCase,
      this._deleteFavoriteCategoryUseCase)
      : super(const HealthState());

  final List<HealthBookingFilterModel> services = [
    HealthBookingFilterModel(
        route: Routes.FILTERDOCTORSUBCATEGORY,
        bookingType: BookingTypes.clinic,
        image: Assets.doctorClinicVisit),
    HealthBookingFilterModel(
        bookingType: BookingTypes.call,
        image: Assets.doctorCall,
        route: Routes.FILTERDOCTORSUBCATEGORY),
    HealthBookingFilterModel(
        bookingType: BookingTypes.home,
        image: Assets.doctorHomeVisit,
        route: Routes.FILTERDOCTORSUBCATEGORY),
    HealthBookingFilterModel(
        bookingType: BookingTypes.emergency,
        image: Assets.emergency,
        route: Routes.VISITAEMERGENCY),
  ];

  void loadData() async {
    await _getMainCategoryDetails();
    await _isDoctor();
    await _isDoctorApproval();
    await getSubCategories();
    await getServices();
    await getMyBookings();
    await getGovernorates();
  }

  Future<void> _getMainCategoryDetails() async {
    final response =
        await _getMainCategoryDetailsUseCase(MainServicesEnum.health.id);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(state.copyWith(mainCategory: data)));
  }

  Future<void> getMyBookings() async {
    final response =
        await _getUserUpcomingAppointmentsUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(
            state.copyWith(status: HealthStates.initState, myBookings: data)));
  }

  Future<void> _isDoctor() async {
    final response = await _isDoctorUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(state.copyWith(isDoctor: data)));
  }

  Future<void> _isDoctorApproval() async {
    final response = await _isDoctorApprovalUsecase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(state.copyWith(isApproved: data)));
  }

  Future<void> getServices() async {
    final response = await _getMedicalServicesUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(state.copyWith(
            status: HealthStates.initState, medicalServices: data)));
  }

  Future<void> getSubCategories({bool reload = false}) async {
    // if (_healthShare.subCategories.isEmpty || reload) {
    final response =
        await _getHealthSubcategoriesUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      _healthShare.subCategories = data;
      emit(state.copyWith(status: HealthStates.initState, subCategories: data));
    });
    // } else {
    //   emit(state.copyWith(subCategories: _healthShare.subCategories));
    // }
  }

  Future<void> getGovernorates() async {
    // if (_healthShare.subCategories.isEmpty || reload) {
    final response = await _getGovernoratesUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      _healthShare.governorates = data;
      emit(state.copyWith(status: HealthStates.initState, governorates: data));
    });
    // } else {
    //   emit(state.copyWith(subCategories: _healthShare.subCategories));
    // }
  }

  Future<void> toggleFavoriteSubcategory(String subcategoryId) async {
    final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      return getSubCategories(reload: true);
    });
  }

  // Future<bool> toggleFavoriteMedicalService(String subcategoryId) async {
  //   final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
  //   bool result = false;
  //   response.fold(
  //       (failure) =>
  //           emit(state.copyWith(failure: failure, status: HealthStates.error)),
  //       (data) {
  //         MainCategoryEntity mainCategoryEntity;
  //           mainCategoryEntity = state.mainCategory!;
  //           mainCategoryEntity.isFavorite = !mainCategoryEntity.isFavorite!;
  //         emit(state.copyWith(mainCategory: mainCategoryEntity));
  //         result = state.mainCategory!.isFavorite!;
  //         print("Salama ${data}");
  //         return getServices();
  //       });
  //   return result;
  // }
  // Future<bool> toggleFavoriteMedicalService(String subcategoryId) async {
  //   final response = await _toggleFavoriteCategoryUseCase(subcategoryId);
  //   bool result = false;
  //   response.fold(
  //       (failure) =>
  //           emit(state.copyWith(failure: failure, status: HealthStates.error)),
  //       (data) {
  //         MainCategoryEntity mainCategoryEntity;
  //           mainCategoryEntity = state.mainCategory!;
  //           mainCategoryEntity.isFavorite = !mainCategoryEntity.isFavorite!;
  //         emit(state.copyWith(mainCategory: mainCategoryEntity));
  //         result = state.mainCategory!.isFavorite!;
  //         print("Salama ${data}");
  //         return getServices();
  //       });
  //   return result;
  // }

  String? token;


  Future<void> _ensureTokenInitialized() async {
    token ??= await TokenManager.getAccessToken();
  }

  Future<void> toggleFavoriteMedicalService(String subcategoryId) async {
    await _ensureTokenInitialized();

    final String url =
        'https://49dev.com/api/v1/favorite-sub-category/$subcategoryId'; // API endpoint

    // API request headers
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Execute the HTTP POST request to toggle the favorite status
    try {
      final response = await http.post(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        // Parse response if needed
        final data = json.decode(response.body);

        // Emit the updated state with the new mainCategory
        emit(state.copyWith(mainCategory: state.mainCategory));

        print("API Response Success: $data");

        // Optionally fetch services again
        getServices();
      } else {
        print("Failed to toggle favorite: ${response.statusCode}");
        emit(state.copyWith(status: HealthStates.error)); // Emit error state
      }
    } catch (e) {
      print("Error during API request: $e");
      emit(state.copyWith(status: HealthStates.error)); // Emit error state
    }
  }

  Future<void> toggleFavoriteCategory(String categoryId) async {
    await _ensureTokenInitialized();

    final String url =
        'https://49dev.com/api/v1/favorite-category/$categoryId'; // API endpoint for the category

    // API request headers
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Execute the HTTP POST request to toggle the favorite category status
    try {
      final response = await http.post(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        // Parse response if needed
        final data = json.decode(response.body);

        // Update the result based on the new isFavorite value

        // Emit the updated state with the new mainCategory

        print("Category API Response Success: $data");

        // Optionally fetch services again
        await _getMainCategoryDetails();
        emit(state.copyWith(mainCategory: state.mainCategory));
      } else {
        print("Failed to toggle category favorite: ${response.statusCode}");
        emit(state.copyWith(status: HealthStates.error)); // Emit error state
      }
    } catch (e) {
      print("Error during category API request: $e");
      emit(state.copyWith(status: HealthStates.error)); // Emit error state
    }
  }

  Future<bool> deleteMedicalService(String subcategoryId) async {
    final response = await _deleteFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      MainCategoryEntity mainCategoryEntity;
      mainCategoryEntity = state.mainCategory!;
      mainCategoryEntity.isFavorite = !mainCategoryEntity.isFavorite!;
      emit(state.copyWith(mainCategory: mainCategoryEntity));
      result = state.mainCategory!.isFavorite!;
      print("Salama $data");
      return getServices();
    });
    return result;
  }
}
