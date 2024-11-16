import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_subcategory_doctors_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../doctor_details/domain/entities/doctor_entity.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  final HealthSharedData _healthSharedData;
  final GetDoctorListUseCase _getDoctorListUseCase;
  final GetSubCategoryDoctorsListUseCase _getSubCategoryDoctorsListUseCase;

  DoctorsListCubit(
    this._getDoctorListUseCase,
    this._healthSharedData, this._getSubCategoryDoctorsListUseCase,
  ) : super(DoctorsListInitial());

  void loadData(bool fromHome) async {
    await _getDoctors(fromHome);
  }

  void loadDataFromSubCategory(String subCategory) async {
    await _getDoctorsFromSubCategory(subCategory);
  }

  Future<void> _getDoctors(bool fromHome) async {
    CliLogger.info('${_healthSharedData.doctorSearchParams.toJson()}');
    DoctorSearchParams params = DoctorSearchParams();
    params.subCategory=_healthSharedData.doctorSearchParams.subCategory;
    final response =
        await _getDoctorListUseCase.call(fromHome==true?params:_healthSharedData.doctorSearchParams);
    response.fold((failure) => emit(DoctorsListError(Labels.errorHappened)),
        (data) => emit(DoctorsListLoaded(data)));
  }

  Future<void> _getDoctorsFromSubCategory(String subCategory) async {
    CliLogger.info(subCategory);
    final response =
    await _getSubCategoryDoctorsListUseCase.call(subCategory);
    response.fold((failure) => emit(DoctorsListError(Labels.errorHappened)),
            (data) => emit(DoctorsListLoaded(data)));
  }
}
