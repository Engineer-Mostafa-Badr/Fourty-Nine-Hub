import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_subcategory_doctors_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/search_doctors_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../doctor_details/domain/entities/doctor_entity.dart';
import '../../../../health/domain/entities/most_booking_entity.dart';
import '../../../domain/usecases/get_doctor_list_use_case.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  final HealthSharedData _healthSharedData;
  final GetDoctorListUseCase _getDoctorListUseCase;
  final GetSubCategoryDoctorsListUseCase _getSubCategoryDoctorsListUseCase;
  final SearchDoctorsUseCase _searchDoctorsUseCase;

  // void loadData() async {
  //   emit(state.copyWith(status: DoctorsListStates.loading));
  //   doctors.clear();
  //   currentPage = 1;
  //   hasMoreData = true;
  //   await getDoctors();
  // }

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
  // getDoctors() async {
  //   print("object");
  //   if (!hasMoreData || isLoadingMore) return;
  //
  //   isLoadingMore = true;
  //   _healthSharedData.doctorSearchParams.page = currentPage;
  //   _healthSharedData.doctorSearchParams.limit = pageSize;
  //   final response =
  //       await _getDoctorListUseCase.call(_healthSharedData.doctorSearchParams);
  //
  //   response.fold(
  //     (failure) => emit(
  //         state.copyWith(failure: failure, status: DoctorsListStates.error)),
  //     (data) {
  //       doctors.addAll(data);
  //
  //       if (data.length < pageSize) {
  //         hasMoreData = false;
  //       } else {
  //         currentPage++;
  //       }
  //
  //       isLoadingMore = false;
  //       emit(state.copyWith(status: DoctorsListStates.success, doctors: data));
  //     },
  //   );
  // }

  List<DoctorEntity> doctors = [];

  List<MostBookingEntity> doctorsList = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;
  DoctorsListCubit(
    this._getDoctorListUseCase,
    this._healthSharedData,
    this._getSubCategoryDoctorsListUseCase,
    this._searchDoctorsUseCase,
  ) : super(const DoctorsListState());

  getDoctorsFromSubCategory(String subCategory) async {
    print("object");
    CliLogger.info(subCategory);
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getDoctorListUseCase.call(GetDoctorListParams(
        subCategoryId: subCategory, page: currentPage, limit: pageSize));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: DoctorsListStates.error));
      },
      (data) {
        doctorsList.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(
            status: DoctorsListStates.success, doctorsList: data));
      },
    );
  }
  getDoctorsFromSearch(String name) async {
    print("object");
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _searchDoctorsUseCase.call(SearchDoctorsParams(
        name: name.trim(), page: currentPage, limit: pageSize));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: DoctorsListStates.error));
      },
      (data) {
        doctorsList.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(
            status: DoctorsListStates.success, doctorsList: data));
      },
    );
  }

  void loadInitialData(String subCategory,bool fromSearch) async {
    emit(state.copyWith(status: DoctorsListStates.loading));
    doctorsList.clear();
    currentPage = 1;
    hasMoreData = true;
    if(fromSearch) await getDoctorsFromSearch(subCategory);
    if(!fromSearch)await getDoctorsFromSubCategory(subCategory);
  }
}
/*
import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_subcategory_doctors_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../doctor_details/domain/entities/doctor_entity.dart';
import '../../../../health/domain/entities/most_booking_entity.dart';
import '../../../domain/usecases/get_doctor_list_use_case.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  final HealthSharedData _healthSharedData;
  final GetDoctorListUseCase _getDoctorListUseCase;
  final GetSubCategoryDoctorsListUseCase _getSubCategoryDoctorsListUseCase;

  DoctorsListCubit(
    this._getDoctorListUseCase,
    this._healthSharedData,
    this._getSubCategoryDoctorsListUseCase,
  ) : super(const DoctorsListState());

  void loadData() async {
    emit(state.copyWith(status: DoctorsListStates.loading));
    doctors.clear();
    currentPage = 1;
    hasMoreData = true;
    await getDoctors();
  }




  Future<void> getDoctors() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    try {
      // Update pagination params
      _healthSharedData.doctorSearchParams = GetDoctorListParams(
        page: currentPage,
        limit: pageSize,
        subCategoryId: _healthSharedData.doctorSearchParams.subCategoryId,
      );

      final response = await _getDoctorListUseCase.call(
        _healthSharedData.doctorSearchParams,
      );

      response.fold(
            (failure) {
          emit(state.copyWith(
            failure: failure,
            status: DoctorsListStates.error,
          ));
        },
            (data) {
          doctors.addAll(data);

          if (data.length < pageSize) {
            hasMoreData = false;
          } else {
            currentPage++;
          }

          emit(state.copyWith(
            status: DoctorsListStates.success,
            doctors: List.from(doctors), // updated total list
          ));
        },
      );
    } finally {
      isLoadingMore = false;
    }
  }


  Future<void> getMostBookings() async {
    if (isLoading) return;  // Prevent concurrent requests if needed

    isLoading = true;
    emit(state.copyWith(isLoadingMoreMostBooking: true));

    final response = await _getMostBookingUseCase(
      GetMostBookingParams(page: mostBookingPage, limit: 5),
    );

    response.fold(
          (failure) {
        isLoading = false;
        emit(state.copyWith(
          failure: failure,
          isLoadingMoreMostBooking: false,
          status: HealthStates.error,
        ));
      },
          (data) {
        mostBooking.addAll(data);

        if ((data.length ?? 0) < 5) {
          hasMoreMost = false;
          emit(state.copyWith(isLoadingMoreMostBooking: false));
        } else {
          mostBookingPage++;
        }

        isLoadingMoreMost = false;
        emit(state.copyWith(
            mostBooking: data, isLoadingMoreMostBooking: false));
      },
      //     (data) {
      //   mostBooking.addAll(data);  // Add new data to the list
      //   mostBookingPage++;
      //   hasMoreMost = data.length >= 5;  // Assuming the API sends 5 items per page or more
      //
      //   isLoading = false;
      //   emit(state.copyWith(
      //     mostBooking: mostBooking,
      //     isLoadingMoreMostBooking: false,
      //     status: HealthStates.success, // Add the success status
      //   ));
      // },
    );
  }


  List<DoctorEntity> doctors = [];

  List<MostBookingEntity> doctorsList = [];
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

    final response = await _getSubCategoryDoctorsListUseCase.call(
        GetSubCategoryDoctorsParams(
            subCategoryId: subCategory, page: currentPage, limit: pageSize));

    response.fold(
      (failure) => emit(
          state.copyWith(failure: failure, status: DoctorsListStates.error)),
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

 */
