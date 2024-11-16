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
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_info_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/earned_mony_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/doctor_info_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final GetDoctorSubscriptionRemainingDaysUseCase
      _getDoctorSubscriptionRemainingDaysUseCase;
  final GetDoctorPracticingRemainingDaysUseCase
      _getDoctorPracticingRemainingDaysUseCase;
  final GetDoctorIDRemainingDaysUseCase _getDoctorIDRemainingDaysUseCase;
  final DoctorInfoUseCase _doctorInfoUseCase;
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
    this._doctorRejectAppointmentUsecase, this._doctorInfoUseCase,
  ) : super(DoctorDashboardInitial());

  Future<void> loadData() async {
    // await _getSubscriptionRemainingDays();
    // await _getPracticingRemainingDays();
    // await _getIDRemainingDays();
    await _getDoctorInfo();
    await _getAppointmentsByDay();
    await _getUnhandledAppointments();
  }

  List<EarnedMoneyEntity> totalEarnedMoney =[];
  Future<void> _getDoctorInfo() async {
    final response =
        await _doctorInfoUseCase.call(const NoParams());
    response.fold((l) {
      if (l is ServerFailure) {
        emit(DoctorDashboardError(l.message));
      } else {
        emit(DoctorDashboardError(Labels.errorHappened));
      }
    }, (r) {
      print("A7oooo ${r.totalEarnedMoney.toString()}");
      print("A7oooo ${r.remainingDaysToEndSubscription}");
      totalEarnedMoney.addAll(r.totalEarnedMoney);
      print("A7a Gemmy ${totalEarnedMoney.toString()}");
      emit(DoctorInfoSuccessState(r));
      print("A7eeee Gemmy ${totalEarnedMoney.toString()}");
    });
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
            'appointmentAcceptedSuccessfully'));
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
            'appointmentRejectedSuccessfully'));
        _getUnhandledAppointments();
      },
    );
  }
}
