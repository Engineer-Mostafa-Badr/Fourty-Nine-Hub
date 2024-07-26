import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/common/models/public/city_model.dart';
import 'package:fourtyninehub/common/models/public/state_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';

import '../../../../../../core/error/failure.dart';
import '../../../../doctor_details/domain/entities/doctor_entity.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  final HealthSharedData _healthSharedData;
  final GetDoctorListUseCase _getDoctorListUseCase;

  DoctorsListCubit(
    this._getDoctorListUseCase,
    this._healthSharedData,
  ) : super(const DoctorsListState());

  void loadData() async {
    await _getDoctors();
  }

  Future<void> _getDoctors() async {
    final response =
        await _getDoctorListUseCase.call(_healthSharedData.doctorSearchParams);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: DoctorsListStates.error)),
        (data) => emit(state.copyWith(
            status: DoctorsListStates.initState, doctors: data)));
    _healthSharedData.doctorSearchParams.reset();
  }
}
