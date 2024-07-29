import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_reviews.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final GetUserDoctorRatessUseCase _getDoctorDetailsUseCase;
  DoctorDetailsCubit(this._getDoctorDetailsUseCase)
      : super(DoctorDetailsInitial());

  late DoctorEntity doctor;

  late AppointmentEntity selectedAppointment;

  Future<void> loadData() async {
    await _getReviews();
  }

  Future<void> _getReviews() async {
    emit(DoctorDetailsLoading());
    final result = await _getDoctorDetailsUseCase.call(doctor.id);
    result.fold(
      (failure) => emit(DoctorDetailsError(Labels.cantLoadReviews)),
      (data) => emit(DoctorDetailsLoaded(data)),
    );
  }
}
