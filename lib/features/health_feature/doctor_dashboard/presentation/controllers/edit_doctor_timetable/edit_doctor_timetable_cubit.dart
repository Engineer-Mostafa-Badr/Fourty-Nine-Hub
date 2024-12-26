import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/models/doctor_day_model.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_work_days_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_work_days_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_timetable_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/time_table_options_checkbox.dart';
import 'package:go_router/go_router.dart';

part 'edit_doctor_timetable_state.dart';

class EditDoctorTimetableCubit extends Cubit<EditDoctorTimetableState> {
  final GetDoctorWorkDaysUsecase _getDoctorWorkDaysUsecase;
  final UpdateDoctorTimetableUsecase _updateDoctorTimetableUsecase;
  EditDoctorTimetableCubit(
      this._getDoctorWorkDaysUsecase, this._updateDoctorTimetableUsecase)
      : super(EditDoctorTimetableState());

  final TextEditingController clinicPriceController = TextEditingController();
  final TextEditingController callPriceController = TextEditingController();
  final TextEditingController homeVisitPriceController =
      TextEditingController();

  final TextEditingController clinicDurationController =
      TextEditingController();
  final TextEditingController callDurationController = TextEditingController();
  final TextEditingController homeVisitDurationController =
      TextEditingController();

  final TextEditingController waitingTimeController = TextEditingController();

  init(CheckBoxParams params) async {
    emit(state.copyWith(status: EditDoctorTimetableStateStatus.initial));
    await getDoctorWorkDays();
    await updateTables(params);
    emit(state.copyWith(status: EditDoctorTimetableStateStatus.updated));
  }

  updateTables(CheckBoxParams params) {
    emit(state.copyWith(
        showCall: params.showCall,
        showClinic: params.showClinic,
        showHomeVisit: params.showHomeVisit));
    print(
        "state.doctorWorkDays?.clinic${state.doctorWorkDays?.clinic.toString()}");
    clinicPriceController.text =
        state.doctorWorkDays?.clinicPrice.split(' ')[0] ?? '';
    callPriceController.text =
        state.doctorWorkDays?.callsPrice.split(' ')[0] ?? '';
    homeVisitPriceController.text =
        state.doctorWorkDays?.visitHomePrice.split(' ')[0] ?? '';
    clinicDurationController.text =
        state.doctorWorkDays?.detectionPeriodClinic.split(' ')[0] ?? '';
    callDurationController.text =
        state.doctorWorkDays?.detectionPeriodCalls.split(' ')[0] ?? '';
    homeVisitDurationController.text =
        state.doctorWorkDays?.detectionPeriodVisitHome.split(' ')[0] ?? '';
    waitingTimeController.text =
        state.doctorWorkDays?.waitingTime.split(' ')[0] ?? '';

    state.doctorWorkDays?.clinic.forEach((clinicDay) {
      print("clinicDay.day.toWeekDay${clinicDay.day.toWeekDay}");

      DateTime parsedTimeFrom = DateFormat.jm().parse(clinicDay.workFrom);
      DateTime parsedTimeTo = DateFormat.jm().parse(clinicDay.workTo);

      defaultClinicTimetable
          .where((item) => item.day == clinicDay.day.toWeekDay)
          .forEach((item) {
        item
          ..day = clinicDay.day.toWeekDay
          ..from = TimeOfDay.fromDateTime(parsedTimeFrom)
          ..to = TimeOfDay.fromDateTime(parsedTimeTo)
          ..isAvailable = true;
      });
    });
    state.doctorWorkDays?.visitHome.forEach((homeDay) {
      DateTime parsedTimeFrom = DateFormat.jm().parse(homeDay.workFrom);
      DateTime parsedTimeTo = DateFormat.jm().parse(homeDay.workTo);

      defaultHomeVisitTimetable
          .where((item) => item.day == homeDay.day.toWeekDay)
          .forEach((item) {
        item
          ..day = homeDay.day.toWeekDay
          ..from = TimeOfDay.fromDateTime(parsedTimeFrom)
          ..to = TimeOfDay.fromDateTime(parsedTimeTo)
          ..isAvailable = true;
      });
    });
    state.doctorWorkDays?.calls.forEach((callDay) {
      DateTime parsedTimeFrom = DateFormat.jm().parse(callDay.workFrom);
      DateTime parsedTimeTo = DateFormat.jm().parse(callDay.workTo);

      defaultCallTimetable
          .where((item) => item.day == callDay.day.toWeekDay)
          .toList()
          .forEach((item) {
        item
          ..day = callDay.day.toWeekDay
          ..from = TimeOfDay.fromDateTime(parsedTimeFrom)
          ..to = TimeOfDay.fromDateTime(parsedTimeTo)
          ..isAvailable = true;
      });
    });

    emit(state.copyWith(
        callTimetable: defaultCallTimetable,
        clinicTimetable: defaultClinicTimetable,
        homeVisitTimetable: defaultHomeVisitTimetable));
  }

  List<DoctorDayEntity> defaultCallTimetable = [
    DoctorDayEntity(day: WeekDays.saturday),
    DoctorDayEntity(day: WeekDays.sunday),
    DoctorDayEntity(day: WeekDays.monday),
    DoctorDayEntity(day: WeekDays.tuesday),
    DoctorDayEntity(day: WeekDays.wednesday),
    DoctorDayEntity(day: WeekDays.thursday),
    DoctorDayEntity(day: WeekDays.friday),
  ];
  List<DoctorDayEntity> defaultClinicTimetable = [
    DoctorDayEntity(day: WeekDays.saturday),
    DoctorDayEntity(day: WeekDays.sunday),
    DoctorDayEntity(day: WeekDays.monday),
    DoctorDayEntity(day: WeekDays.tuesday),
    DoctorDayEntity(day: WeekDays.wednesday),
    DoctorDayEntity(day: WeekDays.thursday),
    DoctorDayEntity(day: WeekDays.friday),
  ];
  List<DoctorDayEntity> defaultHomeVisitTimetable = [
    DoctorDayEntity(day: WeekDays.saturday),
    DoctorDayEntity(day: WeekDays.sunday),
    DoctorDayEntity(day: WeekDays.monday),
    DoctorDayEntity(day: WeekDays.tuesday),
    DoctorDayEntity(day: WeekDays.wednesday),
    DoctorDayEntity(day: WeekDays.thursday),
    DoctorDayEntity(day: WeekDays.friday),
  ];
  toggleClinic(bool value) {
    emit(state.copyWith(showClinic: value));
  }

  toggleCall(bool value) {
    emit(state.copyWith(showCall: value));
  }

  toggleHomeVisit(bool value) {
    emit(state.copyWith(showHomeVisit: value));
  }

  getDoctorWorkDays() async {
    final response = await _getDoctorWorkDaysUsecase(const NoParams());
    response.fold((l) {
      emit(state.copyWith(
          failure: l, status: EditDoctorTimetableStateStatus.error));
    }, (data) {
      emit(state.copyWith(
          doctorWorkDays: data,
          showCall: data.calls != [] ? true : false,
          showClinic: data.clinic != [] ? true : false,
          showHomeVisit: data.visitHome != [] ? true : false));
    });
  }

  updateTimeTable(BuildContext context) async {
    emit(state.copyWith(status: EditDoctorTimetableStateStatus.editLoading));
    List<DoctorDayModel> callsDays = [];
    List<DoctorDayModel> clinicDays = [];
    List<DoctorDayModel> homeVisitDays = [];
    callsDays.addAll(state.callTimetable
            ?.where((element) => element.isAvailable == true)
            .map((e) => DoctorDayModel.fromEntity(e))
            .toList() ??
        []);
    clinicDays.addAll(state.clinicTimetable
            ?.where((element) => element.isAvailable == true)
            .map((e) => DoctorDayModel.fromEntity(e))
            .toList() ??
        []);
    homeVisitDays.addAll(state.homeVisitTimetable
            ?.where((element) => element.isAvailable == true)
            .map((e) => DoctorDayModel.fromEntity(e))
            .toList() ??
        []);
    final response = await _updateDoctorTimetableUsecase(DoctorTimetableParams(
        hasClinic: state.showClinic ?? false,
        hasCalls: state.showCall ?? false,
        hasHomeVisit: state.showHomeVisit ?? false,
        clinic: WorkDaysParams(clinicDays),
        calls: WorkDaysParams(callsDays),
        visitHome: WorkDaysParams(homeVisitDays),
        detectionPeriodCalls: callDurationController.text,
        detectionPeriodClinic: clinicDurationController.text,
        detectionPeriodvisitHome: homeVisitDurationController.text,
        callsPrice: callPriceController.text,
        clinicPrice: clinicPriceController.text,
        visitHomePrice: homeVisitPriceController.text,
        waitingTime: waitingTimeController.text));
    response.fold((l) {
      emit(state.copyWith(
          failure: l, status: EditDoctorTimetableStateStatus.error));
    }, (data) {
      emit(state.copyWith(status: EditDoctorTimetableStateStatus.editSuccess));
      context.pop(true);
    });
  }
}
