import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart'
    as create_doctor;
import 'package:fourtyninehub/features/health_feature/shared/domain/usecases/get_governorates.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'doctor_governorate_filter_state.dart';

class DoctorGovernorateFilterCubit extends Cubit<DoctorGovernorateFilterState> {
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final HealthSharedData _shareCubit;
  final FocusNode searchFocusNode = FocusNode();

  final TextEditingController searchController = TextEditingController();
  DoctorGovernorateFilterCubit(this._shareCubit, this._getGovernoratesUseCase)
      : super(DoctorGovernorateFilterInitial());

  Future<void> loadData() async {
    await _getGovernorates();
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

  Future<void> _getGovernorates() async {
    // if (_shareCubit.governorates.isEmpty) {
    final response = await _getGovernoratesUseCase.call(const NoParams());
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(DoctorGovernorateFilterError(Labels.errorHappened));
      },
      (data) {
        // Convert from create_doctor GovernorateEntity to shared GovernorateEntity
        final sharedGovernorates = data
            .map((e) => GovernorateEntity(
                  id: e.id,
                  nameAr: e.nameAr,
                  nameEn: e.nameEn,
                ))
            .toList();
        _shareCubit.governorates = sharedGovernorates;
        emit(DoctorGovernorateFilterLoaded(sharedGovernorates));
      },
    );
    // } else {
    //   emit(DoctorGovernorateFilterLoaded(_shareCubit.governorates));
    // }
  }
}
