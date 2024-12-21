import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'create_trip_rider_state.dart';

class CreateTripRiderCubit extends Cubit<CreateTripRiderState> {
  CreateTripRiderCubit() : super(CreateTripRiderInitial());

  var formKey = GlobalKey<FormState>();

  void validateAndSubmitForm() {
    if (formKey.currentState?.validate() ?? false) {
      emit(CreateTripRiderSuccess());
    } else {
      emit(CreateTripRiderError(message: "Please fill all fields correctly"));
    }
  }

  String? validateForm({required String message, required bool condition}) {
    if (condition) {
      return message;
    }
    return null;
  }
}
