import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/doctor_cancel_appointment_use_case.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_appointments_by_day.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'doctor_today_appointments_state.dart';

class DoctorTodayAppointmentsCubit extends Cubit<DoctorTodayAppointmentsState> {
  final GetDoctorAppointmentsByDayUseCase _getDoctorAppointmentsByDayUseCase;
  final DoctorCancelAppointmentUseCase _doctorCancelAppointmentUseCase;

  DoctorTodayAppointmentsCubit(this._getDoctorAppointmentsByDayUseCase,
      this._doctorCancelAppointmentUseCase)
      : super(const DoctorTodayAppointmentsState());

  List<DoctorAppointmentEntity> appointments = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  Future<void> loadData() async {
    emit(state.copyWith(status: DoctorTodayAppointmentsStates.loading));
    appointments.clear();
    currentPage = 1;
    hasMoreData = true;
    await getAppointmentsByDay();
  }

  Future<void> getAppointmentsByDay() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;
    final response = await _getDoctorAppointmentsByDayUseCase(
        GetDoctorAppointmentsByDayParams(
            day: DateTime.now().weekday.toWeekDay,
            paginationParams:
                PaginationParams(page: currentPage, limit: pageSize)));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: DoctorTodayAppointmentsStates.error));
      },
      (data) {
        appointments.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: DoctorTodayAppointmentsStates.success));
      },
    );
  }

  Future<void> cancelAppointment(
      String appointmentId, BuildContext context) async {
    emit(state.copyWith(
        status: DoctorTodayAppointmentsStates.startCancelLoading));
    final response = await _doctorCancelAppointmentUseCase.call(appointmentId);
    emit(
        state.copyWith(status: DoctorTodayAppointmentsStates.endCancelLoading));
    response.fold(
      (l) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(l, currentContext));
        emit(state.copyWith(status: DoctorTodayAppointmentsStates.error));
      },
      (r) {
        appointments.removeWhere((element) => element.id == appointmentId);
        showSuccessMessage(
            context,
            context.isArabic
                ? 'تم إلغاء الحجز بنجاح'
                : 'Appointment Cancelled Successfully');
        emit(state.copyWith(status: DoctorTodayAppointmentsStates.success));
      },
    );
  }

  // Future<void> getAppointmentsByDay() async {
  //   final response = await _getDoctorAppointmentsByDayUseCase(
  //       GetDoctorAppointmentsByDayParams(
  //           day: DateTime.now().weekday.toWeekDay,
  //           paginationParams: PaginationParams(page: _page)));
  //   response.fold(
  //       (l) => emit(const DoctorTodayAppointmentsError(Labels.errorHappened)),
  //       (r) {
  //     _page++;
  //     _appointments.addAll(r);
  //     emit(DoctorTodayAppointmentsLoaded(_appointments));
  //   });
  // }
  //
  // @override
  // Future<void> close() {
  //   scrollController.dispose();
  //   return super.close();
  // }
}
