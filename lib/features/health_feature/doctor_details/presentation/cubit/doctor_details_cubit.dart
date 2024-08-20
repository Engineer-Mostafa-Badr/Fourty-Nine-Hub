import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_reviews.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final HealthSharedData _healthSharedData;
  final GetUserDoctorRatessUseCase _getUserDoctorRatessUseCase;
  final GetDoctorDetailsUseCase _getDoctorDetailsUseCase;
  DoctorDetailsCubit(this._getUserDoctorRatessUseCase, this._healthSharedData,
      this._getDoctorDetailsUseCase)
      : super(DoctorDetailsInitial());

  late AppointmentEntity selectedAppointment;
  late DoctorEntity doctor;

  Future<void> loadData(String doctorId) async {
    await _getDoctorDetails(doctorId);
    await _checkCallAndChatButtons(doctorId);
    await _getReviews(doctorId);
  }

  Future<void> _getDoctorDetails(String doctorId) async {
    emit(DoctorDetailsStartLoading());
    final response = await _getDoctorDetailsUseCase.call(GetDoctorDetailsParams(
      bookingType: _healthSharedData.doctorSearchParams.bookingType,
      doctorId: doctorId,
      subCategoryId: _healthSharedData.doctorSearchParams.subCategory.id,
    ));
    response.fold(
        (failure) => emit(DoctorDetailsError(Labels.cantLoadDoctorDetails)),
        (data) {
      doctor = data;
      emit(DoctorDetailsLoaded());
    });
  }

  Future<void> _getReviews(String doctorId) async {
    emit(DoctorDetailsStartLoading());
    final result = await _getUserDoctorRatessUseCase.call(doctorId);
    result.fold(
      (failure) => emit(DoctorDetailsError(Labels.cantLoadReviews)),
      (data) => emit(DoctorDetailsReviewsLoaded(data)),
    );
  }

  Future<void> _checkCallAndChatButtons(String doctorId) async {
    final response = await ButtonAvailability().isShowButton(
      otherUserId: doctorId,
      subcategoryId: _healthSharedData.doctorSearchParams.subCategory.id,
    );
    emit(DoctorDetailsCheckCallAndMessage(response));
  }
}
