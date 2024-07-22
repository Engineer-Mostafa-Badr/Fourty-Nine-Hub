import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';

import '../../domain/usecases/get_doctor_details_usecase.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final GetDoctorDetailsUseCase _getDoctorDetailsUseCase;
  DoctorDetailsCubit(this._getDoctorDetailsUseCase)
      : super(const DoctorDetailsState());

  void loadData() async {
    await getDoctorDetails(id: 0);
  }

  Future<void> getDoctorDetails({
    required int id,
  }) async {
    final response = await _getDoctorDetailsUseCase.call(id);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: DoctorDetailsStates.error)),
        (data) => emit(state.copyWith(
            status: DoctorDetailsStates.initState, doctor: data)));
  }
}
