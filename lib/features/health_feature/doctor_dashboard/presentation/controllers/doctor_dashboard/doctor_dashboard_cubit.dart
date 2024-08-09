import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/doctor_accept_appointment_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/doctor_reject_appointment.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_appointments_by_day.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_unhandled_appointments_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_id_remaining_days.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_practicing_remaining_days.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_subscription_remaining_days.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final GetDoctorSubscriptionRemainingDaysUseCase
      _getDoctorSubscriptionRemainingDaysUseCase;
  final GetDoctorPracticingRemainingDaysUseCase
      _getDoctorPracticingRemainingDaysUseCase;
  final GetDoctorIDRemainingDaysUseCase _getDoctorIDRemainingDaysUseCase;
  final GetDoctorAppointmentsByDayUseCase _getDoctorAppointmentsByDayUseCase;
  final GetDoctorUnhandledAppointmentsUseCase
      _getDoctorUnhandledAppointmentsUseCase;
  final DoctorAcceptAppointmentUsecase _doctorAcceptAppointmentUseCase;
  final DoctorRejectAppointmentUsecase _doctorRejectAppointmentUsecase;
  DoctorDashboardCubit(
    this._getDoctorSubscriptionRemainingDaysUseCase,
    this._getDoctorPracticingRemainingDaysUseCase,
    this._getDoctorIDRemainingDaysUseCase,
    this._getDoctorAppointmentsByDayUseCase,
    this._getDoctorUnhandledAppointmentsUseCase,
    this._doctorAcceptAppointmentUseCase,
    this._doctorRejectAppointmentUsecase,
  ) : super(DoctorDashboardInitial());

  Future<void> loadData() async {
    await _getSubscriptionRemainingDays();
    await _getPracticingRemainingDays();
    await _getIDRemainingDays();
    await _getAppointmentsByDay();
    await _getUnhandledAppointments();
  }

  Future<void> _getSubscriptionRemainingDays() async {
    final response =
        await _getDoctorSubscriptionRemainingDaysUseCase.call(const NoParams());
    response.fold((l) {
      if (l is ServerFailure) {
        emit(DoctorDashboardError(l.message));
      } else {
        emit(DoctorDashboardError(Labels.errorHappened));
      }
    }, (r) => emit(DoctorDashboardSupscriptionRemainingDays(r)));
  }

  Future<void> _getPracticingRemainingDays() async {
    final response =
        await _getDoctorPracticingRemainingDaysUseCase.call(const NoParams());
    response.fold((l) => emit(DoctorDashboardError(Labels.errorHappened)),
        (r) => emit(DoctorDashboardPracticingRemainingDays(r)));
  }

  Future<void> _getIDRemainingDays() async {
    final response =
        await _getDoctorIDRemainingDaysUseCase.call(const NoParams());
    response.fold((l) => emit(DoctorDashboardError(Labels.errorHappened)),
        (r) => emit(DoctorDashboardIDRemainingDays(r)));
  }

  Future<void> _getAppointmentsByDay() async {
    final response = await _getDoctorAppointmentsByDayUseCase.call(
        GetDoctorAppointmentsByDayParams(
            day: DateTime.now().weekday.toWeekDay,
            paginationParams: PaginationParams(page: 1, limit: 2)));
    response.fold((l) => emit(DoctorDashboardError(Labels.errorHappened)),
        (r) => emit(DoctorDashboardTodayAppointments(r)));
  }

  Future<void> _getUnhandledAppointments() async {
    final response = await _getDoctorUnhandledAppointmentsUseCase
        .call(PaginationParams(page: 1, limit: 2));
    response.fold((l) => emit(DoctorDashboardError(Labels.errorHappened)),
        (r) => emit(DoctorDashboardUnhandledAppointments(r)));
  }

  Future<void> acceptAppointment(String appointmentId) async {
    emit(DoctorDashboardStartLoading());
    final response = await _doctorAcceptAppointmentUseCase.call(appointmentId);
    emit(DoctorDashboardStopLoading());
    response.fold(
      (l) => emit(DoctorDashboardError(Labels.errorHappened)),
      (r) {
        emit(DoctorDashboardShowSuccessfulMessage(
            Labels.appointmentAcceptedSuccessfully));
        _getUnhandledAppointments();
      },
    );
  }

  Future<void> rejectAppointment(String appointmentId) async {
    emit(DoctorDashboardStartLoading());
    final response = await _doctorRejectAppointmentUsecase.call(appointmentId);
    emit(DoctorDashboardStopLoading());
    response.fold(
      (l) => emit(DoctorDashboardError(Labels.errorHappened)),
      (r) {
        emit(DoctorDashboardShowSuccessfulMessage(
            Labels.appointmentRejectedSuccessfully));
        _getUnhandledAppointments();
      },
    );
  }
}
