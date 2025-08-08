import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/doctor_accept_appointment_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/doctor_reject_appointment.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_unhandled_appointments_usecase.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
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
      : super(const DoctorUnhandledAppointmentsState());

  List<DoctorAppointmentEntity> appointments = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  Future<void> loadData() async {
    emit(state.copyWith(status: DoctorUnhandledAppointmentsStates.loading));
    appointments.clear();
    currentPage = 1;
    hasMoreData = true;
    await getAppointments();
  }

  Future<void> getAppointments() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;
    final response = await _getDoctorUnhandledAppointmentsUseCase
        .call(PaginationParams(page: currentPage, limit: pageSize));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: DoctorUnhandledAppointmentsStates.error));
      },
      (data) {
        appointments.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: DoctorUnhandledAppointmentsStates.success));
      },
    );
  }

  // Future<void> loadData() async {
  //   await _getAppointments();
  // }
  //
  // final ScrollController scrollController = ScrollController();
  //
  // int _page = 1;
  //
  // final List<DoctorAppointmentEntity> _appointments = [];
  //
  // Future<void> _getAppointments() async {
  //   final response = await _getDoctorUnhandledAppointmentsUseCase
  //       .call(PaginationParams(page: _page));
  //   response.fold(
  //       (l) =>
  //           emit(const DoctorUnhandledAppointmentsError(Labels.errorHappened)),
  //       (r) {
  //     _page++;
  //     _appointments.addAll(r);
  //     emit(DoctorUnhandledAppointmentsLoaded(_appointments));
  //   });
  // }

  Future<void> acceptAppointment(String appointmentId) async {
    final response = await _doctorAcceptAppointmentUsecase.call(appointmentId);
    response.fold(
      (failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: DoctorUnhandledAppointmentsStates.error));
      },
      (data) {
        appointments.removeWhere((element) => element.id == appointmentId);
        emit(state.copyWith(status: DoctorUnhandledAppointmentsStates.success));
      },
    );
  }

  Future<void> rejectAppointment(String appointmentId) async {
    final response = await _doctorRejectAppointmentUsecase.call(appointmentId);
    response.fold(
      (failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: DoctorUnhandledAppointmentsStates.error));
      },
      (data) {
        appointments.removeWhere((element) => element.id == appointmentId);
        emit(state.copyWith(status: DoctorUnhandledAppointmentsStates.success));
      },
    );
  }

  // @override
  // Future<void> close() {
  //   scrollController.dispose();
  //   return super.close();
  // }
}
