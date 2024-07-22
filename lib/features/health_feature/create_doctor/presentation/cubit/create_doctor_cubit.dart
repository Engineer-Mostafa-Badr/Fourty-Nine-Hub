import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_location.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_locatoin.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/work_day_entity.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';

part 'create_doctor_state.dart';

class CreateDoctorCubit extends Cubit<CreateDoctorState> {
  CreateDoctorCubit() : super(CreateDoctorState());

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final specialtyFocusNode = FocusNode();
  final callPriceFocusNode = FocusNode();
  final homeVisitPriceFocusNode = FocusNode();
  final clinicPriceFocusNode = FocusNode();
  final locationFocusNode = FocusNode();
  final waitingTimeFocusNode = FocusNode();
  final clinicExamineDurationFocusNode = FocusNode();
  final callExamineDurationFocusNode = FocusNode();
  final homeVisitExamineDurationFocusNode = FocusNode();
  final homeVisitDurationFocusNode = FocusNode();
  final addressFocusNode = FocusNode();

  final homeVisitExamineDurationController = TextEditingController();
  final addressController = TextEditingController();
  final callExamineDurationController = TextEditingController();
  final waitingTimeController = TextEditingController();
  final clinicExamineDurationController = TextEditingController();
  final locationController = TextEditingController();
  final firstNameController = TextEditingController();
  final specialtyController = TextEditingController();
  final lastNameController = TextEditingController();
  final callPriceController = TextEditingController();
  final homeVisitPriceController = TextEditingController();
  final clinicPriceController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  SubCategoryModel _subCategoryModel =
      SubCategoryModel(id: '', name: '', image: '', isFavourite: false);

  List<DoctorWorkDayEntity> clinicWorkDays = [];
  List<DoctorWorkDayEntity> callWorkDays = [];
  List<DoctorWorkDayEntity> homeVisitWorkDays = [];

  DoctorLocationModel _location =
      DoctorLocationModel(governorate: '', city: '', address: '');

  void toggleHomeVisit(bool value) {
    emit(state.copyWith(
        status: CreateDoctorStates.initState, hasHomeVisit: value));
  }

  void selectGovernorate(String value) {
    _location.governorate = value;
  }

  void selectSubGategory(String value) {
    // _subCategoryModel = value;
  }

  void selectCity(String value) {
    _location.city = value;
  }

  void toggleClinic(bool value) {
    emit(
        state.copyWith(status: CreateDoctorStates.initState, hasClinic: value));
  }

  void toggleCallCheck(bool value) {
    emit(state.copyWith(status: CreateDoctorStates.initState, hasCall: value));
  }
}
