import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_profile_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_practicing_cirtification_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_profile_photo_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'edit_doctor_profile_state.dart';

class EditDoctorProfileCubit extends Cubit<EditDoctorProfileState> {
  final UpdateDoctorIDUsecase _updateDoctorIDUsecase;
  final UpdateDoctorPracticingCirtificateUsecase
      _updateDoctorPracticingCirtificateUsecase;
  final UpdateDoctorProfilePhotoUsecase _updateDoctorProfilePhotoUsecase;
  final GetDoctorProfileUseCase _getDoctorProfileUseCase;
  EditDoctorProfileCubit(
      this._getDoctorProfileUseCase,
      this._updateDoctorIDUsecase,
      this._updateDoctorPracticingCirtificateUsecase,
      this._updateDoctorProfilePhotoUsecase)
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

  Future<void> updateProfilePhoto(String imageid) async {
    final respone = await _updateDoctorProfilePhotoUsecase(imageid);

    respone.fold((failure) {}, (data) {});
  }

  Future<void> updateID(DoctorDocsParams params) async {
    final respone = await _updateDoctorIDUsecase(params);
    respone.fold((failure) {}, (data) {});
  }

  Future<void> updatePracticingCirtificate(DoctorDocsParams params) async {
    final respone = await _updateDoctorPracticingCirtificateUsecase(params);
    respone.fold((failure) {}, (data) {});
  }
}
