import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_cubit/health_share_cubit_cubit.dart';

part 'doctor_city_filter_state.dart';

class DoctorCityFilterCubit extends Cubit<DoctorCityFilterState> {
  DoctorCityFilterCubit(this._shareCubit) : super(DoctorCityFilterInitial());
  final HealthShareCubit _shareCubit;

  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  Future<void> load() async {
    _getSubCategories();
  }

  Future<void> _getSubCategories() async {
    emit(DoctorCityFilterLoaded(cities: _shareCubit.cities));
  }

  void search(String query) {
    if (query.isNotEmpty) {
      emit(DoctorCityFilterLoaded(
          cities: _shareCubit.cities
              .where((element) =>
                  element.toLowerCase().contains(query.toLowerCase()))
              .toList()));
    } else {
      emit(DoctorCityFilterLoaded(cities: _shareCubit.cities));
    }
  }
}
