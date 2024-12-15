import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/doctor_accept_appointment_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/doctor_reject_appointment.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_appointments_by_day.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_unhandled_appointments_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_id_remaining_days.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_practicing_remaining_days.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_subscription_remaining_days.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_info_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/earned_mony_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/doctor_info_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/doctor_cancel_appointment_use_case.dart';

part 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final GetDoctorSubscriptionRemainingDaysUseCase
      _getDoctorSubscriptionRemainingDaysUseCase;
  final DoctorCancelAppointmentUseCase _doctorCancelAppointmentUseCase;
  final GetDoctorIDRemainingDaysUseCase _getDoctorIDRemainingDaysUseCase;
  final DoctorInfoUseCase _doctorInfoUseCase;
  final GetDoctorAppointmentsByDayUseCase _getDoctorAppointmentsByDayUseCase;
  final GetDoctorUnhandledAppointmentsUseCase
      _getDoctorUnhandledAppointmentsUseCase;
  final DoctorAcceptAppointmentUsecase _doctorAcceptAppointmentUseCase;
  final DoctorRejectAppointmentUsecase _doctorRejectAppointmentUsecase;
  DoctorDashboardCubit(
    this._getDoctorSubscriptionRemainingDaysUseCase,
    this._doctorCancelAppointmentUseCase,
    this._getDoctorIDRemainingDaysUseCase,
    this._getDoctorAppointmentsByDayUseCase,
    this._getDoctorUnhandledAppointmentsUseCase,
    this._doctorAcceptAppointmentUseCase,
    this._doctorRejectAppointmentUsecase, this._doctorInfoUseCase,
  ) : super(DoctorDashboardState());

  Future<void> loadData() async {
    emit(state.copyWith(status: DoctorDashboardStateStatus.startLoading));
    await _getDoctorInfo();
    await _getAppointmentsByDay();
    await _getUnhandledAppointments();
    emit(state.copyWith(status: DoctorDashboardStateStatus.updated));
  }

  List<EarnedMoneyEntity> totalEarnedMoney =[];
  Future<void> _getDoctorInfo() async {
    final response =
        await _doctorInfoUseCase.call(const NoParams());
    response.fold((l) {
      if (l is ServerFailure) {
        emit(state.copyWith(failure: l,status: DoctorDashboardStateStatus.error));
      } else {
        emit(state.copyWith(status: DoctorDashboardStateStatus.error));
      }
    }, (r) {
      totalEarnedMoney.addAll(r.totalEarnedMoney);
      emit(state.copyWith(info: r));
    });
  }


  Future<void> _getAppointmentsByDay() async {
    final response = await _getDoctorAppointmentsByDayUseCase.call(
        GetDoctorAppointmentsByDayParams(
            day: DateTime.now().weekday.toWeekDay,
            paginationParams: PaginationParams(page: 1, limit: 3)));
    response.fold((l) =>emit(state.copyWith(status: DoctorDashboardStateStatus.error)),
        (r) => emit(state.copyWith(todayAppointments: r)));
  }

  Future<void> _getUnhandledAppointments() async {
    final response = await _getDoctorUnhandledAppointmentsUseCase
        .call(PaginationParams(page: 1, limit: 3));
    response.fold((l) => emit(state.copyWith(status: DoctorDashboardStateStatus.error)),
        (r) => emit(state.copyWith(unhandledAppointments: r)));
  }

  Future<void> acceptAppointment(String appointmentId,BuildContext context) async {
    emit(state.copyWith(status: DoctorDashboardStateStatus.startAcceptLoading));
    final response = await _doctorAcceptAppointmentUseCase.call(appointmentId);
    emit(state.copyWith(status: DoctorDashboardStateStatus.endAcceptLoading));
    response.fold(
      (l) => emit(state.copyWith(status: DoctorDashboardStateStatus.error)),
      (r) {
        List<DoctorAppointmentEntity> newUnhandledAppointments=[];
        List<DoctorAppointmentEntity> newTodayAppointments=[];
        newTodayAppointments.addAll(state.todayAppointments??[]);
        newUnhandledAppointments.addAll(state.unhandledAppointments??[]);
        if(newUnhandledAppointments.isNotEmpty){
          DoctorAppointmentEntity appointment = newUnhandledAppointments.firstWhere((element) => element.id==appointmentId);
          newTodayAppointments.add(appointment);
        }
        newUnhandledAppointments.removeWhere((element) => element.id==appointmentId);
        emit(state.copyWith(unhandledAppointments: newUnhandledAppointments,todayAppointments: newTodayAppointments));
        showSuccessMessage(context, context.isArabic?'تم قبول الحجز بنجاح':'Appointment Accepted Successfully');

        // _getUnhandledAppointments();
      },
    );
  }

  Future<void> rejectAppointment(String appointmentId,BuildContext context) async {
    emit(state.copyWith(status: DoctorDashboardStateStatus.startAcceptLoading));
    final response = await _doctorRejectAppointmentUsecase.call(appointmentId);
    emit(state.copyWith(status: DoctorDashboardStateStatus.endAcceptLoading));
    response.fold(
      (l) => emit(state.copyWith(status: DoctorDashboardStateStatus.error)),
      (r) {
        List<DoctorAppointmentEntity> newUnhandledAppointments=[];
        newUnhandledAppointments.addAll(state.unhandledAppointments??[]);
        newUnhandledAppointments.removeWhere((element) => element.id==appointmentId);
        emit(state.copyWith(unhandledAppointments: newUnhandledAppointments,));
        showSuccessMessage(context, context.isArabic?'تم رفض الحجز بنجاح':'Appointment Rejected Successfully');
        // _getUnhandledAppointments();
      },
    );
  }


  Future<void> cancelAppointment(String appointmentId,BuildContext context) async {
    emit(state.copyWith(status: DoctorDashboardStateStatus.startCancelLoading));
    final response = await _doctorCancelAppointmentUseCase.call(appointmentId);
    emit(state.copyWith(status: DoctorDashboardStateStatus.endCancelLoading));
    response.fold(
          (l) => emit(state.copyWith(status: DoctorDashboardStateStatus.error)),
          (r) {
        state.todayAppointments?.removeWhere((element)=>element.id==appointmentId);
        showSuccessMessage(context, context.isArabic?'تم إلغاء الحجز بنجاح':'Appointment Cancelled Successfully');
        emit(state.copyWith(status: DoctorDashboardStateStatus.updated));
      },
    );
  }


}
