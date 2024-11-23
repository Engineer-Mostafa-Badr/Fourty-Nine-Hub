import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/add_doctor_rating_use_case.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_Id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_ratings.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_reviews.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/pages/DoctorDetails.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final HealthSharedData _healthSharedData;
  final GetUserDoctorRatessUseCase _getUserDoctorRatessUseCase;
  final GetDoctorDetailsUseCase _getDoctorDetailsUseCase;
  final GetDoctorDetailsIdUseCase _getDoctorDetailsIdUseCase;
  final AddDoctorRatingUseCase _addDoctorRatingUseCase;
  final GetDoctorReviewsUseCase _getDoctorReviewsUseCase;
  DoctorDetailsCubit(
      this._getUserDoctorRatessUseCase,
      this._healthSharedData,
      this._getDoctorDetailsUseCase,
      this._getDoctorDetailsIdUseCase,
      this._addDoctorRatingUseCase,
      this._getDoctorReviewsUseCase)
      : super(DoctorDetailsInitial());

  late AppointmentEntity selectedAppointment;
  late DoctorEntity doctor;

  Future<void> loadData(DoctorDetailsParams params) async {
    params.fromSearch == false
        ? await _getDoctorDetailsId(params.doctorId)
        : await _getDoctorDetails(params.doctorId);
    await _checkCallAndChatButtons(params.doctorId);
    await _getReviews(params.doctorId);
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

  Future<bool> addRating(AddDoctorRatingParams params) async {
    bool result = false;
    final response = await _addDoctorRatingUseCase.call(params);
    response.fold(
        (failure) => emit(DoctorDetailsError(Labels.cantLoadDoctorDetails)),
        (data) {
      result = data;
    });
    return result;
  }

  Future<void> _getDoctorDetailsId(String doctorId) async {
    emit(DoctorDetailsStartLoading());
    final response =
        await _getDoctorDetailsIdUseCase.call(GetDoctorDetailsIdParams(
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

  Future<void> getDoctorReviews() async {
    emit(DoctorDetailsStartLoading());
    final result = await _getDoctorReviewsUseCase.call(const NoParams());
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
