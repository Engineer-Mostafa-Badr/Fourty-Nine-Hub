import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/entities/all_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/all_appointment_use_case.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/doctor_cancel_appointment_use_case.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/doctor_accept_appointment_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/doctor_reject_appointment.dart';
part 'all_appointments_state.dart';

class AllAppointmentsCubit extends Cubit<AllAppointmentsState> {
  final AllAppointmentUseCase _getAdRequestsUseCase;
  final DoctorAcceptAppointmentUsecase _doctorAcceptAppointmentUseCase;
  final DoctorCancelAppointmentUseCase _doctorCancelAppointmentUseCase;
  final DoctorRejectAppointmentUsecase _doctorRejectAppointmentUsecase;
  AllAppointmentsCubit(this._getAdRequestsUseCase, this._doctorAcceptAppointmentUseCase, this._doctorRejectAppointmentUsecase, this._doctorCancelAppointmentUseCase) : super(const AllAppointmentsState());


  TextEditingController searchController = TextEditingController();
  List<AllAppointmentEntity> appointments = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;


  void loadInitialData() async {
    emit(state.copyWith(status: AllAppointmentsStates.loading));
    appointments.clear();
    currentPage = 1;
    hasMoreData = true;
    await getAllAppointments();
  }

  Future<void> getAllAppointments() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getAdRequestsUseCase(
      PaginationParams(page: currentPage, limit: pageSize),
    );

    response.fold(
          (failure) => emit(state.copyWith(failure: failure, status: AllAppointmentsStates.error)),
          (data) {
        appointments.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: AllAppointmentsStates.success));
      },
    );
  }


  Future<void> acceptAppointment(String appointmentId,BuildContext context) async {
    emit(state.copyWith(status: AllAppointmentsStates.startLoading));
    final response = await _doctorAcceptAppointmentUseCase.call(appointmentId);
    emit(state.copyWith(status: AllAppointmentsStates.endLoading));
    response.fold(
          (l) => emit(state.copyWith(status: AllAppointmentsStates.error)),
          (r) {
            appointments.firstWhereOrNull((element)=>element.id==appointmentId)?.status='accepted';
        showSuccessMessage(context, context.isArabic?'تم قبول الحجز بنجاح':'Appointment Accepted Successfully');
        emit(state.copyWith(status: AllAppointmentsStates.success));
      },
    );
  }

  Future<void> cancelAppointment(String appointmentId,BuildContext context) async {
    emit(state.copyWith(status: AllAppointmentsStates.startLoading));
    final response = await _doctorCancelAppointmentUseCase.call(appointmentId);
    emit(state.copyWith(status: AllAppointmentsStates.endLoading));
    response.fold(
          (l) => emit(state.copyWith(status: AllAppointmentsStates.error)),
          (r) {
            appointments.removeWhere((element)=>element.bookingId==appointmentId);
        showSuccessMessage(context, context.isArabic?'تم إلغاء الحجز بنجاح':'Appointment Cancelled Successfully');
        emit(state.copyWith(status: AllAppointmentsStates.success));
      },
    );
  }

  Future<void> rejectAppointment(String appointmentId,BuildContext context) async {
    emit(state.copyWith(status: AllAppointmentsStates.startLoading));
    final response = await _doctorRejectAppointmentUsecase.call(appointmentId);
    emit(state.copyWith(status: AllAppointmentsStates.endLoading));
    response.fold(
          (l) => emit(state.copyWith(status: AllAppointmentsStates.error)),
          (r) {
            appointments.firstWhereOrNull((element)=>element.id==appointmentId)?.status='rejected';
        showSuccessMessage(context, context.isArabic?'تم رفض الحجز بنجاح':'Appointment Rejected Successfully');
            emit(state.copyWith(status: AllAppointmentsStates.success));
      },
    );
  }


}
