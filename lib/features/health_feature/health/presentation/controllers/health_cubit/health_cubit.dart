import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/filter_option_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/cancel_appointment_use_case.dart';
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

import '../../../../create_doctor/domain/entities/governorate_entity.dart';
import '../../../../create_doctor/domain/usecases/get_governorates.dart';
import '../../../domain/entities/appointment_booking_entity.dart';

part 'health_state.dart';

class HealthCubit extends Cubit<HealthState> {
  final HealthSharedData _healthShare;
  final GetUserUpcomingAppointmentsUseCase _getUserUpcomingAppointmentsUseCase;
  final CancelAppointmentUseCase _cancelAppointmentUseCase;
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
      this._deleteFavoriteCategoryUseCase,
      this._cancelAppointmentUseCase)
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
  final userId = UserCubit.to.state.data?.id;
  void loadData() async {
    print("UseeeeeeertId$userId");
    emit(state.copyWith(status: HealthStates.loading));
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
      (data) => emit(state.copyWith(mainCategory: data)),
    );
  }

  Future<void> getMyBookings() async {
    final response =
        await _getUserUpcomingAppointmentsUseCase.call(userId ?? '');
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(
            state.copyWith(status: HealthStates.initState, myBookings: data)));
  }

  Future<bool> cancelAppointment(String id) async {
    bool result = false;
    final response = await _cancelAppointmentUseCase.call(id);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      List<BookedAppointmentEntity>? newBookings = state.myBookings;
      newBookings?.removeWhere((element) => element.id == id);
      result = data;
      emit(state.copyWith(myBookings: newBookings));
    });
    return result;
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
    final response = await _getMedicalServicesUseCase.call(userId ?? '');
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(state.copyWith(
            status: HealthStates.initState, medicalServices: data)));
  }

  Future<void> getSubCategories({bool reload = false}) async {
    // if (_healthShare.subCategories.isEmpty || reload) {
    final response = await _getHealthSubcategoriesUseCase.call(userId ?? '');
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

  // Future<void> toggleFavoriteSubcategory(String subcategoryId) async {
  //   final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
  //   response.fold(
  //       (failure) =>
  //           emit(state.copyWith(failure: failure, status: HealthStates.error)),
  //       (data) {
  //     return getSubCategories(reload: true);
  //   });
  // }
  Future<void> toggleFavoriteSubcategory(String subcategoryId) async {
    final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
    response.fold((failure) => emit(state.copyWith(status: HealthStates.error)),
        (data) {
      List<HealthSubcategoryEntity> newSubCategories =
          state.subCategories ?? [];
      newSubCategories
          .firstWhere((element) => element.id == subcategoryId)
          .isFavorite = !(newSubCategories
              .firstWhere((element) => element.id == subcategoryId)
              .isFavorite ??
          false);
      // getSubCategories(reload: true);
      emit(state.copyWith(subCategories: newSubCategories));
    });
  }

  Future<bool> toggleFavoriteMedicalService(String subcategoryId) async {
    await _ensureTokenInitialized();
    final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      List<HealthSubcategoryEntity> newMedicalServices =
          state.medicalServices ?? [];
      newMedicalServices
          .firstWhere((element) => element.id == subcategoryId)
          .isFavorite = !(newMedicalServices
              .firstWhere((element) => element.id == subcategoryId)
              .isFavorite ??
          false);
      emit(state.copyWith(medicalServices: newMedicalServices));
    });
    return result;
  }

  Future<bool> toggleFavoriteCategory(String subcategoryId) async {
    final response = await _toggleFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      // MainCategoryEntity mainCategoryEntity;
      //   mainCategoryEntity = state.mainCategory!;
      //   mainCategoryEntity.isFavorite = !mainCategoryEntity.isFavorite!;
      // emit(state.copyWith(mainCategory: mainCategoryEntity));
      // result = state.mainCategory!.isFavorite!;
      // print("Salama ${data}");
      MainCategoryEntity newMainCategory = state.mainCategory!;
      newMainCategory.isFavorite = !(state.mainCategory?.isFavorite ?? false);
      emit(state.copyWith(mainCategory: newMainCategory));
      // _getMainCategoryDetails();

      // return getServices();
    });
    return result;
  }

  String? token;

  Future<void> _ensureTokenInitialized() async {
    token ??= await CacheManager.getAccessToken();
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
