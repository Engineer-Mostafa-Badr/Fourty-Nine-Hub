import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/delete_doctor_account_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_profile_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_practicing_cirtification_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_profile_photo_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/routes/pages.dart';

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

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: EditDoctorProfileStateStatus.startLoading));
    final respone = await _deleteDoctorAccountUseCase(state.doctor!.id);
    emit(state.copyWith(status: EditDoctorProfileStateStatus.endLoading));

    respone.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(
          status: EditDoctorProfileStateStatus.error, failure: failure));
    }, (data) {
      emit(state.copyWith(status: EditDoctorProfileStateStatus.doctorDeleted));
    });
  }

  Future<void> loadData() async {
    await _getDoctorProfile();
  }

  Future<bool> updateID(DoctorDocsParams params) async {
    bool result = false;
    emit(state.copyWith(status: EditDoctorProfileStateStatus.startLoading));
    print("Doctor params.toJson()${params.toJson()}");
    final respone = await _updateDoctorIDUsecase(params);
    emit(state.copyWith(status: EditDoctorProfileStateStatus.endLoading));

    respone.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(
          status: EditDoctorProfileStateStatus.error, failure: failure));
    }, (data) {
      result = true;
      emit(state.copyWith(
          status: EditDoctorProfileStateStatus.updated, update: true));
    });
    return result;
  }

  Future<bool> updatePracticingCirtificate(DoctorDocsParams params) async {
    bool result = false;
    emit(state.copyWith(status: EditDoctorProfileStateStatus.startLoading));

    final respone = await _updateDoctorPracticingCirtificateUsecase(params);
    emit(state.copyWith(status: EditDoctorProfileStateStatus.endLoading));

    respone.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(
          status: EditDoctorProfileStateStatus.error, failure: failure));
    }, (data) {
      result = true;
      emit(state.copyWith(
          status: EditDoctorProfileStateStatus.updated, update: true));
    });

    return result;
  }

  Future<void> updateProfilePhoto(String imageid) async {
    emit(state.copyWith(status: EditDoctorProfileStateStatus.startLoading));

    final respone = await _updateDoctorProfilePhotoUsecase(imageid);
    emit(state.copyWith(status: EditDoctorProfileStateStatus.endLoading));

    respone.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            status: EditDoctorProfileStateStatus.error, failure: failure));
      },
      (data) => emit(state.copyWith(
          status: EditDoctorProfileStateStatus.updated, update: true)),
    );
  }

  Future<void> _getDoctorProfile() async {
    emit(state.copyWith(status: EditDoctorProfileStateStatus.initial));
    final response = await _getDoctorProfileUseCase(const NoParams());

    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(
          status: EditDoctorProfileStateStatus.error, failure: failure));
    },
        (data) => emit(state.copyWith(
            status: EditDoctorProfileStateStatus.getDoctor, doctor: data)));
  }
}
