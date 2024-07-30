import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/filter_option_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_user_upcoming_appointments.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';

import '../../../domain/entities/appointment_booking_entity.dart';

part 'health_state.dart';

class HealthCubit extends Cubit<HealthState> {
  final HealthSharedData _healthShare;
  final GetUserUpcomingAppointmentsUseCase _getUserUpcomingAppointmentsUseCase;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  HealthCubit(this._getUserUpcomingAppointmentsUseCase,
      this._getSubCategoriesUseCase, this._healthShare)
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
    await getMyBookings();
    await getServices();
    await getSubCategories();
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

  Future<void> getServices() async {
    final response =
        await _getSubCategoriesUseCase.call(MainServicesEnum.health.value());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(state.copyWith(
            status: HealthStates.initState, medicalServices: data)));
  }

  Future<void> getSubCategories() async {
    if (_healthShare.subCategories.isEmpty) {
      final response =
          await _getSubCategoriesUseCase.call('62c8b57c9332225799fe3306');
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
}
