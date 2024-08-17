import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_doctor_personal_info_state.dart';

class EditDoctorPersonalInfoCubit extends Cubit<EditDoctorPersonalInfoState> {
  EditDoctorPersonalInfoCubit() : super(EditDoctorPersonalInfoInitial());
}
