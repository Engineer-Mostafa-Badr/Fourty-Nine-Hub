import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
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
  ) : super(const DoctorsListState());

  void loadData() async {
    emit(state.copyWith(status: DoctorsListStates.loading));
    doctors.clear();
    currentPage = 1;
    hasMoreData = true;
    await getDoctors();
  }


  // Future<void> getDoctors(bool fromHome) async {
  //   DoctorSearchParams params = DoctorSearchParams();
  //   params.subCategory=_healthSharedData.doctorSearchParams.subCategory;
  //
  //   CliLogger.info('${_healthSharedData.doctorSearchParams.toJson()}');
  //
  //   final response =
  //       await _getDoctorListUseCase.call(fromHome==true?params:_healthSharedData.doctorSearchParams);
  //   response.fold((failure) => emit(state.copyWith(status: DoctorsListStates.error, failure: failure)),
  //       (data) => emit(state.copyWith(status: DoctorsListStates.success, doctors: data)));
  // }
  getDoctors() async {
    print("object");
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;
    _healthSharedData.doctorSearchParams.page=currentPage;
    _healthSharedData.doctorSearchParams.limit=pageSize;
    final response =
    await _getDoctorListUseCase.call(_healthSharedData.doctorSearchParams);


    response.fold(
          (failure) => emit(state.copyWith(failure: failure, status: DoctorsListStates.error)),
          (data) {
        doctors.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: DoctorsListStates.success, doctors: data));
      },
    );
  }


  List<DoctorEntity> doctors = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  void loadInitialData(String subCategory) async {
    emit(state.copyWith(status: DoctorsListStates.loading));
    doctors.clear();
    currentPage = 1;
    hasMoreData = true;
    await getDoctorsFromSubCategory(subCategory);
  }


  getDoctorsFromSubCategory(String subCategory) async {
    print("object");
    CliLogger.info(subCategory);
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response =
    await _getSubCategoryDoctorsListUseCase.call(GetSubCategoryDoctorsParams(subCategoryId: subCategory,page: currentPage,limit: pageSize));


    response.fold(
          (failure) => emit(state.copyWith(failure: failure, status: DoctorsListStates.error)),
          (data) {
        doctors.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: DoctorsListStates.success, doctors: data));
      },
    );
  }
}
