import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_doctor_timetable_state.dart';

class EditDoctorTimetableCubit extends Cubit<EditDoctorTimetableState> {
  EditDoctorTimetableCubit() : super(EditDoctorTimetableInitial());
}
