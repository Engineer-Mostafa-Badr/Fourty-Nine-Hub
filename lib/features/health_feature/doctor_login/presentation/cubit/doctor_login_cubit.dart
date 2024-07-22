import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/domain/entities/doctor_time_entity.dart';

part 'doctor_login_state.dart';

class DoctorLoginCubit extends Cubit<DoctorLoginState> {
  DoctorLoginCubit() : super(DoctorLoginState());

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final specialtyFocusNode = FocusNode();
  final callPriceFocusNode = FocusNode();
  final homeVisitPriceFocusNode = FocusNode();
  final clinicPriceFocusNode = FocusNode();
  final locationFocusNode = FocusNode();
  final waitingTimeFocusNode = FocusNode();

  final waitingTimeController = TextEditingController();
  final locationController = TextEditingController();
  final firstNameController = TextEditingController();
  final specialtyController = TextEditingController();
  final lastNameController = TextEditingController();
  final callPriceController = TextEditingController();
  final homeVisitPriceController = TextEditingController();
  final clinicPriceController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  List<DoctorDayAvailabilityEntity> clinicTimes = [
    DoctorDayAvailabilityEntity(day: "Saturday"),
    DoctorDayAvailabilityEntity(day: "Sunday"),
    DoctorDayAvailabilityEntity(day: "Monday"),
    DoctorDayAvailabilityEntity(day: "Tuesday"),
    DoctorDayAvailabilityEntity(day: "Wednesday"),
    DoctorDayAvailabilityEntity(day: "Thursday"),
    DoctorDayAvailabilityEntity(day: "Friday"),
  ];

  List<DoctorDayAvailabilityEntity> callTimes = [
    DoctorDayAvailabilityEntity(day: "Saturday"),
    DoctorDayAvailabilityEntity(day: "Sunday"),
    DoctorDayAvailabilityEntity(day: "Monday"),
    DoctorDayAvailabilityEntity(day: "Tuesday"),
    DoctorDayAvailabilityEntity(day: "Wednesday"),
    DoctorDayAvailabilityEntity(day: "Thursday"),
    DoctorDayAvailabilityEntity(day: "Friday"),
  ];

  List<DoctorDayAvailabilityEntity> homeVisitTimes = [
    DoctorDayAvailabilityEntity(day: "Saturday"),
    DoctorDayAvailabilityEntity(day: "Sunday"),
    DoctorDayAvailabilityEntity(day: "Monday"),
    DoctorDayAvailabilityEntity(day: "Tuesday"),
    DoctorDayAvailabilityEntity(day: "Wednesday"),
    DoctorDayAvailabilityEntity(day: "Thursday"),
    DoctorDayAvailabilityEntity(day: "Friday"),
  ];

  void hasHomeVisitCheck(bool value) {
    emit(state.copyWith(
        status: DoctorLoginStates.initState, hasHomeVisit: value));
  }

  void hasCallCheck(bool value) {
    emit(state.copyWith(status: DoctorLoginStates.initState, hasCall: value));
  }
}
