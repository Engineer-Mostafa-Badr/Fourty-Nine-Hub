import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/delete_doctor_account_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_profile_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_practicing_cirtification_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_profile_photo_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

part 'edit_doctor_profile_state.dart';

class EditDoctorProfileCubit extends Cubit<EditDoctorProfileState> {
  final UpdateDoctorIDUsecase _updateDoctorIDUsecase;
  final UpdateDoctorPracticingCirtificateUsecase
      _updateDoctorPracticingCirtificateUsecase;
  final UpdateDoctorProfilePhotoUsecase _updateDoctorProfilePhotoUsecase;
  final GetDoctorProfileUseCase _getDoctorProfileUseCase;
  final DeleteDoctorAccountUseCase _deleteDoctorAccountUseCase;
  EditDoctorProfileCubit(
      this._getDoctorProfileUseCase,
      this._updateDoctorIDUsecase,
      this._updateDoctorPracticingCirtificateUsecase,
      this._updateDoctorProfilePhotoUsecase,
      this._deleteDoctorAccountUseCase)
      : super(EditDoctorProfileState());

  Future<void> loadData() async {
    await _getDoctorProfile();
  }

  Future<void> _getDoctorProfile() async {
    emit(state.copyWith(status: EditDoctorProfileStateStatus.startLoading));
    final response = await _getDoctorProfileUseCase(const NoParams());
    emit(state.copyWith(status: EditDoctorProfileStateStatus.endLoading));

    response.fold(
        (failure) => emit(state.copyWith(
            status: EditDoctorProfileStateStatus.error, failure: failure)),
        (data) => emit(state.copyWith(
            status: EditDoctorProfileStateStatus.getDoctor, doctor: data)));
  }

  Future<void> updateProfilePhoto(String imageid) async {
    emit(state.copyWith(status: EditDoctorProfileStateStatus.startLoading));

    final respone = await _updateDoctorProfilePhotoUsecase(imageid);
    emit(state.copyWith(status: EditDoctorProfileStateStatus.endLoading));

    respone.fold(
      (failure) => emit(state.copyWith(
          status: EditDoctorProfileStateStatus.error, failure: failure)),
      (data) =>
          emit(state.copyWith(status: EditDoctorProfileStateStatus.updated)),
    );
  }

  Future<void> updateID(DoctorDocsParams params) async {
    emit(state.copyWith(status: EditDoctorProfileStateStatus.startLoading));

    final respone = await _updateDoctorIDUsecase(params);
    emit(state.copyWith(status: EditDoctorProfileStateStatus.endLoading));

    respone.fold(
        (failure) => emit(state.copyWith(
            status: EditDoctorProfileStateStatus.error, failure: failure)),
        (data) =>
            emit(state.copyWith(status: EditDoctorProfileStateStatus.updated)));
  }

  Future<void> updatePracticingCirtificate(DoctorDocsParams params) async {
    emit(state.copyWith(status: EditDoctorProfileStateStatus.startLoading));

    final respone = await _updateDoctorPracticingCirtificateUsecase(params);
    emit(state.copyWith(status: EditDoctorProfileStateStatus.endLoading));

    respone.fold(
        (failure) => emit(state.copyWith(
            status: EditDoctorProfileStateStatus.error, failure: failure)),
        (data) =>
            emit(state.copyWith(status: EditDoctorProfileStateStatus.updated)));
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: EditDoctorProfileStateStatus.startLoading));
    final respone = await _deleteDoctorAccountUseCase(state.doctor!.id);
    emit(state.copyWith(status: EditDoctorProfileStateStatus.endLoading));

    respone.fold(
        (failure) => emit(state.copyWith(
            status: EditDoctorProfileStateStatus.error, failure: failure)),
        (data) => emit(state.copyWith(
            status: EditDoctorProfileStateStatus.doctorDeleted)));
  }
}
