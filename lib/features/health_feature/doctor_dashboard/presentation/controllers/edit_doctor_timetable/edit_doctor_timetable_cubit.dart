import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/models/doctor_work_days_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_work_days_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/work_day_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_work_days_usecase.dart';

part 'edit_doctor_timetable_state.dart';

class EditDoctorTimetableCubit extends Cubit<EditDoctorTimetableState> {
  final GetDoctorWorkDaysUsecase _getDoctorWorkDaysUsecase;
  EditDoctorTimetableCubit(this._getDoctorWorkDaysUsecase) : super(EditDoctorTimetableState());

  init ()async{
    emit(state.copyWith(status: EditDoctorTimetableStateStatus.initial));
    await getDoctorWorkDays();
    await updateTables();
    emit(state.copyWith(status: EditDoctorTimetableStateStatus.updated));
  }

  updateTables(){
    List<DoctorDayEntity> callTimetable = [];
    List<DoctorDayEntity> clinicTimetable = [];
    List<DoctorDayEntity> homeVisitTimetable = [];
    clinicTimetable.addAll(timetable);
    callTimetable.addAll(timetable);
    homeVisitTimetable.addAll(timetable);
    emit(state.copyWith( showCall: state.doctorWorkDays!=null&&state.doctorWorkDays?.calls!=[]?true:false,showClinic: state.doctorWorkDays!=null&&state.doctorWorkDays?.clinic!=[]?true:false,showHomeVisit: state.doctorWorkDays!=null&&state.doctorWorkDays?.visitHome!=[]?true:false));

    print("state.doctorWorkDays?.clinic${state.doctorWorkDays?.clinic.toString()}");
    for (WorkDayEntity clinicDay in state.doctorWorkDays?.clinic ?? []) {
      print("clinicDay.day.toWeekDay${clinicDay.day.toWeekDay}");
      // Parse the workFrom and workTo times
      DateTime parsedTimeFrom = DateFormat.jm().parse(clinicDay.workFrom);
      DateTime parsedTimeTo = DateFormat.jm().parse(clinicDay.workTo);

      // Update the matching elements in clinicTimetable
      for (var item in clinicTimetable) {
        if (item.day == clinicDay.day.toWeekDay) {
          item.day = clinicDay.day.toWeekDay;
          item.from = TimeOfDay.fromDateTime(parsedTimeFrom);
          item.to = TimeOfDay.fromDateTime(parsedTimeTo);
          item.isAvailable = true;
        }
      }
    }
    for (WorkDayEntity clinicDay in state.doctorWorkDays?.visitHome??[]) {
      DateTime parsedTimeFrom = DateFormat.jm().parse(clinicDay.workFrom);
      DateTime parsedTimeTo = DateFormat.jm().parse(clinicDay.workTo);
      homeVisitTimetable.where((element) => element.day==clinicDay.day.toWeekDay).forEach((item) {
        item.day=clinicDay.day.toWeekDay;
        item.from=TimeOfDay.fromDateTime(parsedTimeFrom);
        item.to=TimeOfDay.fromDateTime(parsedTimeTo);
        item.isAvailable=true;
      });
    }
    for (WorkDayEntity clinicDay in state.doctorWorkDays?.calls??[]) {
      DateTime parsedTimeFrom = DateFormat.jm().parse(clinicDay.workFrom);
      DateTime parsedTimeTo = DateFormat.jm().parse(clinicDay.workTo);
      callTimetable.where((element) => element.day==clinicDay.day.toWeekDay).forEach((item) {
        item.day=clinicDay.day.toWeekDay;
        item.from=TimeOfDay.fromDateTime(parsedTimeFrom);
        item.to=TimeOfDay.fromDateTime(parsedTimeTo);
        item.isAvailable=true;
      });
    }
    emit(state.copyWith(callTimetable: callTimetable,clinicTimetable: clinicTimetable,homeVisitTimetable: homeVisitTimetable));
  }
  List<DoctorDayEntity> timetable = [
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
      emit(state.copyWith(failure: l, status: EditDoctorTimetableStateStatus.error));
    }, (data) {
      emit(state.copyWith( doctorWorkDays: data,showCall: data.calls!=[]?true:false,showClinic: data.clinic!=[]?true:false,showHomeVisit: data.visitHome!=[]?true:false));
    });
  }


}
