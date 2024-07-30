import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/check_subcategory_subscription.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

import '../../../../doctor_details/domain/entities/doctor_entity.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  final HealthSharedData _healthSharedData;
  final GetDoctorListUseCase _getDoctorListUseCase;
  final CheckSubCategorySubscriptionUseCase
      _checkSubCategorySubscriptionUseCase;

  DoctorsListCubit(
    this._getDoctorListUseCase,
    this._healthSharedData,
    this._checkSubCategorySubscriptionUseCase,
  ) : super(DoctorsListInitial());

  void loadData() async {
    await _checkForPremium();
    await _getDoctors();
  }

  bool _hasSubscription = false;

  Future<void> _checkForPremium() async {
    final response = await _checkSubCategorySubscriptionUseCase
        .call(_healthSharedData.doctorSearchParams.subCategory.id);
    response.fold((failure) => _hasSubscription = false,
        (data) => _hasSubscription = data);
  }

  Future<void> _getDoctors() async {
    final response =
        await _getDoctorListUseCase.call(_healthSharedData.doctorSearchParams);
    response.fold((failure) => emit(DoctorsListError(Labels.errorHappened)),
        (data) => emit(DoctorsListLoaded(data)));
  }

  bool get hasSubscription => _hasSubscription;
}
