import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';

import '../../domain/entities/appointment_booking_entity.dart';
import '../../domain/usecases/get_my_appointment_bookings_usecase.dart';

part 'health_state.dart';

class HealthCubit extends Cubit<HealthState> {
  final GetMyAppointmentBookingsUseCase _getMyAppointmentBookingsUseCase;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  HealthCubit(
      this._getMyAppointmentBookingsUseCase, this._getSubCategoriesUseCase)
      : super(const HealthState());

  void loadData() async {
    await getMyBookings();
    await getSubCategories();
  }

  Future<void> getMyBookings() async {
    final response =
        await _getMyAppointmentBookingsUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(
            state.copyWith(status: HealthStates.initState, myBookings: data)));
  }

  Future<void> getSubCategories() async {
    final response = await _getSubCategoriesUseCase.call('');
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(state.copyWith(
            status: HealthStates.initState, subCategories: data)));
  }
}
