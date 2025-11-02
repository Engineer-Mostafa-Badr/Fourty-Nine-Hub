import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctors_by_specialty_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/search_doctors_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/search_doctors_by_booking_type_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/search_doctors_by_specialty_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../doctor_details/domain/entities/doctor_entity.dart';
import '../../../../health/domain/entities/most_booking_entity.dart';
import '../../../domain/usecases/get_doctor_list_use_case.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  final GetDoctorListUseCase _getDoctorListUseCase;
  final GetDoctorsBySpecialtyUseCase _getDoctorsBySpecialtyUseCase;
  final SearchDoctorsUseCase _searchDoctorsUseCase;
  final SearchDoctorsByBookingTypeUseCase _searchDoctorsByBookingTypeUseCase;
  final SearchDoctorsBySpecialtyUseCase _searchDoctorsBySpecialtyUseCase;

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
  String? _activeSpecialtySearchQuery;
  DoctorsListCubit(
    this._getDoctorListUseCase,
    this._getDoctorsBySpecialtyUseCase,
    this._searchDoctorsUseCase,
    this._searchDoctorsByBookingTypeUseCase,
    this._searchDoctorsBySpecialtyUseCase,
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
            status: DoctorsListStates.success, doctorsList: doctorsList));
      },
    );
  }

  getDoctorsFromSearch(String name) async {
    print("Searching for: $name");
    if (!hasMoreData || isLoadingMore) return;

    // Validate search query
    if (name.trim().isEmpty) {
      print("Empty search query provided");
      return;
    }

    isLoadingMore = true;

    final response = await _searchDoctorsUseCase.call(SearchDoctorsParams(
        name: name.trim(), page: currentPage, limit: pageSize));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        isLoadingMore = false;
        emit(state.copyWith(failure: failure, status: DoctorsListStates.error));
      },
      (data) {
        print('Search results received: ${data.length} items');
        if (data.isNotEmpty) {
          print('First item specialty: ${data.first.subCategory?.nameAr}');
          print(
              'First item name: ${data.first.firstName} ${data.first.lastName}');
        }

        // Trust API search results; avoid extra client-side filtering that may drop valid items
        doctorsList.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(
            status: DoctorsListStates.success, doctorsList: doctorsList));
      },
    );
  }

  // Note: client-side filtering removed to avoid dropping valid API results

  getDoctorsBySpecialty(String specialtyId) async {
    print("Getting doctors by specialty: $specialtyId");
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getDoctorsBySpecialtyUseCase.call(
        GetDoctorsBySpecialtyParams(
            specialtyId: specialtyId, page: currentPage, limit: pageSize));

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
            status: DoctorsListStates.success, doctorsList: doctorsList));
      },
    );
  }

  Future<void> getDoctorsBySpecialtyFastBooking(String specialtyId) async {
    print("Getting doctors by specialty (FastBooking filter): $specialtyId");
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getDoctorsBySpecialtyUseCase.call(
        GetDoctorsBySpecialtyParams(
            specialtyId: specialtyId, page: currentPage, limit: pageSize));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: DoctorsListStates.error));
      },
      (data) {
        final shared = serviceLocator<HealthSharedData>();
        final selectedGovId = shared.doctorSearchParams.governorate.id;
        final selectedCityId = shared.doctorSearchParams.city.id;

        final List<MostBookingEntity> filtered = data.where((doctor) {
          final docGovId = doctor.address?.governorate?.id ?? '';
          final docCityId = doctor.address?.city?.id ?? '';
          if (selectedGovId.isNotEmpty && docGovId != selectedGovId) {
            return false;
          }
          if (selectedCityId.isNotEmpty && docCityId != selectedCityId) {
            return false;
          }
          return true;
        }).toList();

        doctorsList.addAll(filtered);

        if (filtered.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(
            status: DoctorsListStates.success, doctorsList: doctorsList));
      },
    );
  }

  void loadInitialData(String subCategory, bool fromSearch) async {
    emit(state.copyWith(status: DoctorsListStates.loading));
    doctorsList.clear();
    currentPage = 1;
    hasMoreData = true;
    if (fromSearch) await getDoctorsFromSearch(subCategory);
    if (!fromSearch) await getDoctorsFromSubCategory(subCategory);
  }

  void loadInitialDataBySpecialty(String specialtyId) async {
    emit(state.copyWith(status: DoctorsListStates.loading));
    doctorsList.clear();
    currentPage = 1;
    hasMoreData = true;
    _activeSpecialtySearchQuery = null;
    await getDoctorsBySpecialty(specialtyId);
  }

  // FastBooking: base list filtered by selected governorate/city
  void loadInitialDataBySpecialtyFastBooking(String specialtyId) async {
    emit(state.copyWith(status: DoctorsListStates.loading));
    doctorsList.clear();
    currentPage = 1;
    hasMoreData = true;
    _activeSpecialtySearchQuery = null;
    await getDoctorsBySpecialtyFastBooking(specialtyId);
  }

  void loadInitialDataByBookingType({
    required BookingTypes bookingType,
    required String specialtyId,
    String? governorateId,
    String? cityId,
  }) async {
    print('🟣 [DEBUG] Loading Initial Data By Booking Type:');
    print('   - Booking Type: ${bookingType.name}');
    print('   - Specialty ID: $specialtyId');
    print('   - Governorate ID: ${governorateId ?? "null"}');
    print('   - City ID: ${cityId ?? "null"}');

    emit(state.copyWith(status: DoctorsListStates.loading));
    doctorsList.clear();
    currentPage = 1;
    hasMoreData = true;
    await getDoctorsByBookingType(
      bookingType: bookingType,
      specialtyId: specialtyId,
      governorateId: governorateId,
      cityId: cityId,
    );
  }

  void loadInitialDataBySpecialtySearch({
    required String specialtyId,
    required String name,
  }) async {
    emit(state.copyWith(status: DoctorsListStates.loading));
    doctorsList.clear();
    currentPage = 1;
    hasMoreData = true;
    _activeSpecialtySearchQuery = name.trim();
    await getDoctorsBySpecialtySearchFastBooking(
      specialtyId: specialtyId,
      name: _activeSpecialtySearchQuery!,
    );
  }

  Future<void> getDoctorsByBookingType({
    required BookingTypes bookingType,
    required String specialtyId,
    String? governorateId,
    String? cityId,
  }) async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    // Debug print for API call
    print('🔴 [DEBUG] Calling API - Search Doctors By Booking Type:');
    print('   - Booking Type: ${bookingType.name}');
    print('   - Specialty ID: $specialtyId');
    print('   - Governorate ID: ${governorateId ?? "null"}');
    print('   - City ID: ${cityId ?? "null"}');
    print('   - Page: $currentPage');
    print('   - Limit: $pageSize');

    final response = await _searchDoctorsByBookingTypeUseCase.call(
      SearchDoctorsByBookingTypeParams(
        bookingType: bookingType,
        specialtyId: specialtyId,
        governorateId: governorateId,
        cityId: cityId,
        page: currentPage,
        limit: pageSize,
      ),
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        print('❌ [DEBUG] API Error: ${failure.toString()}');
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        isLoadingMore = false;
        emit(state.copyWith(failure: failure, status: DoctorsListStates.error));
      },
      (data) {
        print('✅ [DEBUG] API Success - Received ${data.length} doctors');
        doctorsList.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(
            status: DoctorsListStates.success, doctorsList: doctorsList));
      },
    );
  }

  Future<void> getDoctorsBySpecialtySearch({
    required String specialtyId,
    required String name,
  }) async {
    if (!hasMoreData || isLoadingMore) return;

    if (name.trim().isEmpty) {
      return;
    }

    isLoadingMore = true;

    final response = await _searchDoctorsBySpecialtyUseCase.call(
      SearchDoctorsBySpecialtyParams(
        specialtyId: specialtyId,
        query: name.trim(),
        page: currentPage,
        limit: pageSize,
      ),
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        isLoadingMore = false;
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
            status: DoctorsListStates.success, doctorsList: doctorsList));
      },
    );
  }

  Future<void> getDoctorsBySpecialtySearchFastBooking({
    required String specialtyId,
    required String name,
  }) async {
    if (!hasMoreData || isLoadingMore) return;
    if (name.trim().isEmpty) return;

    isLoadingMore = true;

    final response = await _searchDoctorsBySpecialtyUseCase.call(
      SearchDoctorsBySpecialtyParams(
        specialtyId: specialtyId,
        query: name.trim(),
        page: currentPage,
        limit: pageSize,
      ),
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        isLoadingMore = false;
        emit(state.copyWith(failure: failure, status: DoctorsListStates.error));
      },
      (data) {
        final shared = serviceLocator<HealthSharedData>();
        final selectedGovId = shared.doctorSearchParams.governorate.id;
        final selectedCityId = shared.doctorSearchParams.city.id;

        final List<MostBookingEntity> filtered = data.where((doctor) {
          final docGovId = doctor.address?.governorate?.id ?? '';
          final docCityId = doctor.address?.city?.id ?? '';
          if (selectedGovId.isNotEmpty && docGovId != selectedGovId) {
            return false;
          }
          if (selectedCityId.isNotEmpty && docCityId != selectedCityId) {
            return false;
          }
          return true;
        }).toList();

        doctorsList.addAll(filtered);

        if (filtered.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(
            status: DoctorsListStates.success, doctorsList: doctorsList));
      },
    );
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
