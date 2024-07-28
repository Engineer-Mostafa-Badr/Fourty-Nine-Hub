import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/enums/gender_type.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_appointment.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'book_doctor_appointment_state.dart';

class BookDoctorAppointmentCubit extends Cubit<BookDoctorAppointmentState> {
  final phoneNumberTextController = TextEditingController();
  final phoneFousNode = FocusNode();
  final ageFocusNode = FocusNode();
  final ageController = TextEditingController();
  final notesFocusNode = FocusNode();
  final notesController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final BookAppointmentUseCase bookAppointmentUseCase;

  final BookAppointmentParams _params = BookAppointmentParams();

  BookDoctorAppointmentCubit(this.bookAppointmentUseCase)
      : super(BookDoctorAppointmentInitialState());

  @override
  Future<void> close() {
    phoneNumberTextController.dispose();
    phoneFousNode.dispose();
    ageFocusNode.dispose();
    ageController.dispose();
    notesFocusNode.dispose();
    notesController.dispose();
    return super.close();
  }

  Future<void> confirmBooking() async {
    if (formKey.currentState!.validate()) {
      _saveText();
      emit(BookDoctorAppointmentLoadingState());
      final response = await bookAppointmentUseCase.call(_params);
      response.fold((failure) => emit(BookDoctorAppointmentErrorState(Labels.errorHappened)),
          (data) => emit(BookDoctorAppointmentSuccessState()));
    }
  }

  void _saveText() {
    _params.notes = notesController.text;
    _params.phone = phoneNumberTextController.text;
    _params.age = ageController.text;
  }

  void selectGender(GenderType gender) {
    _params.gender = gender;
  }
}
