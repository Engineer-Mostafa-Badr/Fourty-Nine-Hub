import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_unhandled_appointments_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'doctor_unhandled_appotinments_state.dart';

class DoctorUnhandledAppointmentsCubit
    extends Cubit<DoctorUnhandledAppointmentsState> {
  final GetDoctorUnhandledAppointmentsUseCase
      _getDoctorUnhandledAppointmentsUseCase;

  DoctorUnhandledAppointmentsCubit(this._getDoctorUnhandledAppointmentsUseCase)
      : super(DoctorUnhandledAppointmentsInitial()) {
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        _getAppointments();
      }
    });
  }

  Future<void> loadData() async {
    await _getAppointments();
  }

  final ScrollController scrollController = ScrollController();

  int _page = 1;

  final List<DoctorAppointmentEntity> _appointments = [];

  Future<void> _getAppointments() async {
    final response = await _getDoctorUnhandledAppointmentsUseCase
        .call(GetDoctorUnhandledAppointmentsParams(page: _page, limit: 20));
    response.fold(
        (l) =>
            emit(const DoctorUnhandledAppointmentsError(Labels.errorHappened)),
        (r) {
      _page++;
      _appointments.addAll(r);
      emit(DoctorUnhandledAppointmentsLoaded(_appointments));
    });
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
