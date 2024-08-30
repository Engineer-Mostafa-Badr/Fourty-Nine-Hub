import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_governorates.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'doctor_governorate_filter_state.dart';

class DoctorGovernorateFilterCubit extends Cubit<DoctorGovernorateFilterState> {
  DoctorGovernorateFilterCubit(this._shareCubit, this._getGovernoratesUseCase)
      : super(DoctorGovernorateFilterInitial());
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final HealthSharedData _shareCubit;

  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  Future<void> loadData() async {
    await _getGovernorates();
  }

  Future<void> _getGovernorates() async {
    // if (_shareCubit.governorates.isEmpty) {
    final response = await _getGovernoratesUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(DoctorGovernorateFilterError(Labels.errorHappened)),
        (data) {
      _shareCubit.governorates = data;
      emit(DoctorGovernorateFilterLoaded(data));
    });
    // } else {
    //   emit(DoctorGovernorateFilterLoaded(_shareCubit.governorates));
    // }
  }

  void search(String query) {
    if (query.isNotEmpty) {
      emit(DoctorGovernorateFilterLoaded(_shareCubit.governorates
          .where((element) =>
              element.nameEn.toLowerCase().contains(query.toLowerCase()))
          .toList()));
    } else {
      emit(DoctorGovernorateFilterLoaded(_shareCubit.governorates));
    }
  }
}
