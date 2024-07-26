import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_cubit/health_share_cubit_cubit.dart';

part 'doctor_area_filter_state.dart';

class DoctorAreaFilterCubit extends Cubit<DoctorAreaFilterState> {
  DoctorAreaFilterCubit(this._shareCubit) : super(DoctorAreaFilterInitial());
   final HealthShareCubit _shareCubit;

  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  Future<void> load() async {
    _getSubCategories();
  }

  Future<void> _getSubCategories() async {
    emit(DoctorAreaFilterLoaded(areas: _shareCubit.cities));
  }

  void search(String query) {
    if (query.isNotEmpty) {
      emit(DoctorAreaFilterLoaded(
          areas: _shareCubit.areas
              .where((element) =>
                  element.toLowerCase().contains(query.toLowerCase()))
              .toList()));
    } else {
      emit(DoctorAreaFilterLoaded(areas: _shareCubit.areas));
    }
  }
}
