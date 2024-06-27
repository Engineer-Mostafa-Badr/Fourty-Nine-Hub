import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/common/models/public/city_model.dart';
import 'package:fourtyninehub/common/models/public/state_model.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/domain/usecases/get_cities_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/domain/usecases/get_states_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../../doctor_details/domain/entities/doctor_entity.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  final GetCitiesUseCase _getCitiesUseCase;
  final GetStatesUseCase _getStatesUseCase;
  final GetDoctorListUseCase _getDoctorListUseCase;

  DoctorsListCubit(this._getCitiesUseCase, this._getDoctorListUseCase,
      this._getStatesUseCase)
      : super(const DoctorsListState());

  void loadData() async {
    await getDoctors();
    await getStates();
  }

  Future<void> getStates() async {
    final response = await _getStatesUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: DoctorsListStates.error)),
        (data) async {
      emit(state.copyWith(status: DoctorsListStates.initState, states: data));
      await getCities();
    });
  }

  Future<void> getCities() async {
    final response = await _getCitiesUseCase.call(state.selectedState?.id ?? 0);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: DoctorsListStates.error)),
        (data) => emit(
            state.copyWith(status: DoctorsListStates.initState, cities: data)));
  }

  Future<void> getDoctors() async {
    final response = await _getDoctorListUseCase.call(DoctorSearchParams(
        cityId: state.selectedCity?.id, stateId: state.selectedState?.id));
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: DoctorsListStates.error)),
        (data) => emit(state.copyWith(
            status: DoctorsListStates.initState, doctors: data)));
  }

  void selectState({required StateModel v}) async {
    emit(state.copyWith(selectedState: v));
    await getDoctors();

    await getCities();
  }

  void selectCity({required CityModel v}) async {
    emit(state.copyWith(selectedCity: v));
    await getDoctors();
  }
}
