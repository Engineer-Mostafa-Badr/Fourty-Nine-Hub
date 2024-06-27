import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../routes/routes.dart';
import '../../../doctor_details/domain/entities/appointment_entity.dart';
import '../../../doctor_details/domain/entities/doctor_entity.dart';
import '../../../doctor_details/domain/usecases/get_doctor_details_usecase.dart';
import '../../../health/domain/entities/appointment_booking_entity.dart';
import '../../domain/usecases/get_doctor_appointment_usecase.dart';

part 'book_doctor_appointment_state.dart';

class BookDoctorAppointmentCubit extends Cubit<BookDoctorAppointmentState> {
  final fullNameTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();

  final GetDoctorDetailsUseCase _getDoctorDetailsUseCase;
  final GetDoctorAppointmentsUseCase _getDoctorAppointmentsUseCase;

  BookDoctorAppointmentCubit(
      this._getDoctorDetailsUseCase, this._getDoctorAppointmentsUseCase)
      : super(const BookDoctorAppointmentState());
  void loadData() async {
    await getDoctorDetails(id: 0);
    await getDoctorAppointments();
  }

  Future<void> getDoctorDetails({
    required int id,
  }) async {
    final response = await _getDoctorDetailsUseCase.call(id);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: BookDoctorAppointmentStates.error)),
        (data) => emit(state.copyWith(
            status: BookDoctorAppointmentStates.initState, doctor: data)));
  }

  Future<void> getDoctorAppointments() async {
    final response =
        await _getDoctorAppointmentsUseCase.call(state.date ?? DateTime.now());
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: BookDoctorAppointmentStates.error)),
        (data) => emit(state.copyWith(
            status: BookDoctorAppointmentStates.initState,
            appointments: data)));
  }

  void changeDate({required DateTime v}) async {
    emit(state.copyWith(date: v));
    await getDoctorAppointments();
  }

  void changeAppointment({required AppointmentEntity v}) =>
      emit(state.copyWith(selectedAppointment: v));

  void confirmBooking({required BuildContext context}) =>
      context.push(Routes.REQUESTSHISTORY);
      void changeBookingType({
        required BookingTypes v
      })=> emit(state.copyWith(bookingType: v));
}
