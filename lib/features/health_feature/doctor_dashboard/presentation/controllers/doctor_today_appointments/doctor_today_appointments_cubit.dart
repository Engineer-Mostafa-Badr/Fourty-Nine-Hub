import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_appointments_by_day.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'doctor_today_appointments_state.dart';

class DoctorTodayAppointmentsCubit extends Cubit<DoctorTodayAppointmentsState> {
  final GetDoctorAppointmentsByDayUseCase _getDoctorAppointmentsByDayUseCase;

  DoctorTodayAppointmentsCubit(this._getDoctorAppointmentsByDayUseCase)
      : super(DoctorTodayAppointmentsInitial()) {
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        _getAppointmentsByDay();
      }
    });
  }

  Future<void> loadData() async {
    await _getAppointmentsByDay();
  }

  final ScrollController scrollController = ScrollController();

  int _page = 1;

  final List<DoctorAppointmentEntity> _appointments = [];

  Future<void> _getAppointmentsByDay() async {
    final response = await _getDoctorAppointmentsByDayUseCase.call(
        GetDoctorAppointmentsByDayParams(
            day: DateTime.now().weekday.toWeekDay, page: _page, limit: 20));
    response.fold(
        (l) => emit(const DoctorTodayAppointmentsError(Labels.errorHappened)),
        (r) {
      _page++;
      _appointments.addAll(r);
      emit(DoctorTodayAppointmentsLoaded(_appointments));
    });
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
