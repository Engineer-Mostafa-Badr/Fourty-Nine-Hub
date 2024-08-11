import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_profile_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'edit_doctor_profile_state.dart';

class EditDoctorProfileCubit extends Cubit<EditDoctorProfileState> {
  final GetDoctorProfileUseCase _getDoctorProfileUseCase;
  EditDoctorProfileCubit(this._getDoctorProfileUseCase)
      : super(EditDoctorProfileInitial());

  Future<void> loadData() async {
    await _getDoctorProfile();
  }

  Future<void> _getDoctorProfile() async {
    final response = await _getDoctorProfileUseCase.call(const NoParams());
    response.fold((failure) {
      String message = Labels.cantLoadData;
      if (failure is ServerFailure) {
        message = failure.message;
      }
      emit(EditDoctorProfileError(message));
    }, (data) => emit(EditDoctorProfileLoaded(data)));
  }
}
