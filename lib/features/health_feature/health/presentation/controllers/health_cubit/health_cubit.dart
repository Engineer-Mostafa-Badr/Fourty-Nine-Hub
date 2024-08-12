import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/filter_option_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_medical_services.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_user_upcoming_appointments.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/toggle_favorite_subcategory.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/is_doctor_usecase.dart';
import '../../../domain/entities/appointment_booking_entity.dart';

part 'health_state.dart';

class HealthCubit extends Cubit<HealthState> {
  final HealthSharedData _healthShare;
  final GetUserUpcomingAppointmentsUseCase _getUserUpcomingAppointmentsUseCase;
  final GetHealthSubcategoriesUseCase _getHealthSubcategoriesUseCase;
  final GetMedicalServicesUseCase _getMedicalServicesUseCase;
  final ToggleFavoriteSubcategoryUseCase _toggleFavoriteSubcategoryUseCase;
  final IsDoctorUsecase _isDoctorUseCase;
  final GetMainCategoryDetailsUseCase _getMainCategoryDetailsUseCase;
  HealthCubit(
      this._getUserUpcomingAppointmentsUseCase,
      this._healthShare,
      this._getHealthSubcategoriesUseCase,
      this._getMedicalServicesUseCase,
      this._toggleFavoriteSubcategoryUseCase,
      this._isDoctorUseCase,
      this._getMainCategoryDetailsUseCase)
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
    await getSubCategories();
    await getServices();
    await getMyBookings();
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

  Future<void> getServices() async {
    final response = await _getMedicalServicesUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(state.copyWith(
            status: HealthStates.initState, medicalServices: data)));
  }

  Future<void> getSubCategories({bool reload = false}) async {
    if (_healthShare.subCategories.isEmpty || reload) {
      final response =
          await _getHealthSubcategoriesUseCase.call(const NoParams());
      response.fold(
          (failure) => emit(
              state.copyWith(failure: failure, status: HealthStates.error)),
          (data) {
        _healthShare.subCategories = data;
        emit(state.copyWith(
            status: HealthStates.initState, subCategories: data));
      });
    } else {
      emit(state.copyWith(subCategories: _healthShare.subCategories));
    }
  }

  Future<void> toggleFavoriteSubcategory(String subcategoryId) async {
    final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => getSubCategories(reload: true));
  }

  Future<void> toggleFavoriteMedicalService(String subcategoryId) async {
    final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => getServices());
  }
}
