import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subscribe/domain/usecases/check_if_user_subscribed_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

import '../../../../doctor_details/domain/entities/doctor_entity.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  final HealthSharedData _healthSharedData;
  final GetDoctorListUseCase _getDoctorListUseCase;
  final CheckIfUserSubscribedUseCase _checkIfUserSubscribedUseCase;

  DoctorsListCubit(
    this._getDoctorListUseCase,
    this._healthSharedData,
    this._checkIfUserSubscribedUseCase,
  ) : super(DoctorsListInitial());

  void loadData() async {
    await _checkForPremium();
    await _getDoctors();
  }

  bool _canBookPremium = false;

  Future<void> _checkForPremium() async {
    final response = await _checkIfUserSubscribedUseCase
        .call(_healthSharedData.doctorSearchParams.subCategory.id);
    response.fold(
        (failure) => _canBookPremium = false, (data) => _canBookPremium = data);
  }

  Future<void> _checkForChat({required String doctorId}) async {
    final rssponse = await ButtonAvailability().isShowButton(
      otherUserId: doctorId,
      subcategoryId: _healthSharedData.doctorSearchParams.subCategory.id,
    );

    // canChat  = response;
  }




  Future<void> _getDoctors() async {
    final response =
        await _getDoctorListUseCase.call(_healthSharedData.doctorSearchParams);
    response.fold((failure) => emit(DoctorsListError(Labels.errorHappened)),
        (data) => emit(DoctorsListLoaded(data)));
  }

  void bookPremium() {
    if (_canBookPremium) {
      emit(DoctorsListBookPremium());
    } else {
      emit(DoctorsListShowSubscriptoinPlans());
    }
  }

  // bool get canChat =>
}
