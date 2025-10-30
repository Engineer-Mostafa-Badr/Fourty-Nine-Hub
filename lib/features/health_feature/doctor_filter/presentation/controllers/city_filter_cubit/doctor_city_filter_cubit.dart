import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/usecases/get_cities.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'doctor_city_filter_state.dart';

class DoctorCityFilterCubit extends Cubit<DoctorCityFilterState> {
  final GetCitiesUseCase _getCitiesUseCase;

  DoctorCityFilterCubit(this._getCitiesUseCase)
      : super(DoctorCityFilterInitial());

  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  List<CityEntity> _cities = [];

  Future<void> loadData({required String governorateId}) async {
    _getCities(governorateId);
  }

  Future<void> _getCities(String governorateId) async {
    emit(DoctorCityFilterLoading());
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(DoctorCityFilterError(Labels.errorHappened));
      },
      (data) {
        _cities = data;
        emit(DoctorCityFilterLoaded(data));
      },
    );
  }

  void search(String query) {
    if (query.isNotEmpty) {
      emit(DoctorCityFilterLoaded(_cities
          .where((element) =>
              element.nameEn.toLowerCase().contains(query.toLowerCase()))
          .toList()));
    } else {
      emit(DoctorCityFilterLoaded(_cities));
    }
  }
}
