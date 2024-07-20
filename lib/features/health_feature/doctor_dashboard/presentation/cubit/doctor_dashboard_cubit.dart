import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../../res/strings/labels.dart';
import '../../../health/domain/entities/appointment_booking_entity.dart';
import '../../domain/usecases/get_doctor_bookings_usecase.dart';

part 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final GetDoctorBookingsUseCase _getDoctorBookingsUseCase;
  DoctorDashboardCubit(this._getDoctorBookingsUseCase)
      : super(const DoctorDashboardState());

  void loadData() async {
    await getDoctorBookings();
  }

  Future<void> getDoctorBookings() async {
    final response = await _getDoctorBookingsUseCase.call(const NoParams());
    response.fold(
        (l) => emit(
            state.copyWith(failure: l, status: DoctorDashboardStates.error)),
        (data) => emit(state.copyWith(
            bookings: data, status: DoctorDashboardStates.initState)));
  }

  Future<void> approveRequest({
    required int id
  }) async {
    emit(state.copyWith(
        status: DoctorDashboardStates.success,
        successMessage: Labels.bookingApproved));
    getDoctorBookings();
  }
   Future<void> cancelBooking({
        required int id

   }) async {
    emit(state.copyWith(
        status: DoctorDashboardStates.success,
        successMessage: Labels.bookingRejected));
    getDoctorBookings();
  }
  
  void changeDate({required DateTime v}) async {
    emit(state.copyWith(date: v));
    await getDoctorBookings();
  }
}
