import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/doctor_accept_appointment_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/doctor_reject_appointment.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_unhandled_appointments_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'doctor_unhandled_appotinments_state.dart';

class DoctorUnhandledAppointmentsCubit
    extends Cubit<DoctorUnhandledAppointmentsState> {
  final GetDoctorUnhandledAppointmentsUseCase
      _getDoctorUnhandledAppointmentsUseCase;

  final DoctorAcceptAppointmentUsecase _doctorAcceptAppointmentUsecase;
  final DoctorRejectAppointmentUsecase _doctorRejectAppointmentUsecase;

  DoctorUnhandledAppointmentsCubit(
      this._getDoctorUnhandledAppointmentsUseCase,
      this._doctorAcceptAppointmentUsecase,
      this._doctorRejectAppointmentUsecase)
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
        .call(PaginationParams(page: _page));
    response.fold(
        (l) =>
            emit(const DoctorUnhandledAppointmentsError(Labels.errorHappened)),
        (r) {
      _page++;
      _appointments.addAll(r);
      emit(DoctorUnhandledAppointmentsLoaded(_appointments));
    });
  }

  Future<void> acceptAppointment(String appointmentId) async {
    emit(DoctorUnhandledAppointmentsLoading());
    final response = await _doctorAcceptAppointmentUsecase.call(appointmentId);
    response.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(DoctorUnhandledAppointmentsError(failure.message));
        } else {
          emit(const DoctorUnhandledAppointmentsError(Labels.errorHappened));
        }
      },
      (data) {
        emit(const DoctorUnhandledAppotinmentsShowSuccessfulMessage(
            'appointmentAcceptedSuccessfully'));
        _getAppointments();
      },
    );
  }

  Future<void> rejectAppointment(String appointmentId) async {
    emit(DoctorUnhandledAppointmentsLoading());
    final response = await _doctorRejectAppointmentUsecase.call(appointmentId);
    response.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(DoctorUnhandledAppointmentsError(failure.message));
        } else {
          emit(const DoctorUnhandledAppointmentsError(Labels.errorHappened));
        }
      },
      (data) {
        emit(const DoctorUnhandledAppotinmentsShowSuccessfulMessage(
            'appointmentRejectedSuccessfully'));
        _getAppointments();
      },
    );
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
