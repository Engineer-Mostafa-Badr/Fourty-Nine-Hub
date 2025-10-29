import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/fast_booking/domain/usecases/get_doctors_by_specialty_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/search_doctors_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/search_doctors_by_booking_type_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../doctor_details/domain/entities/doctor_entity.dart';
import '../../../../health/domain/entities/most_booking_entity.dart';
import '../../../domain/usecases/get_doctor_list_use_case.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  final GetDoctorListUseCase _getDoctorListUseCase;
  final GetDoctorsBySpecialtyUseCase _getDoctorsBySpecialtyUseCase;
  final SearchDoctorsUseCase _searchDoctorsUseCase;
  final SearchDoctorsByBookingTypeUseCase _searchDoctorsByBookingTypeUseCase;

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
    this._getDoctorsBySpecialtyUseCase,
    this._searchDoctorsUseCase,
    this._searchDoctorsByBookingTypeUseCase,
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

        // Filter results based on search query for better relevance
        List<MostBookingEntity> filteredData = _filterSearchResults(data, name);
        print('Filtered results: ${filteredData.length} items');
        print('Search query: "$name"');

        doctorsList.addAll(filteredData);

        if (filteredData.length < pageSize) {
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

  List<MostBookingEntity> _filterSearchResults(
      List<MostBookingEntity> data, String searchQuery) {
    if (searchQuery.trim().isEmpty) return data;

    String query = searchQuery.toLowerCase().trim();
    print('Filtering ${data.length} items with query: "$query"');

    // If the API returned results, trust them more and apply minimal filtering
    // The API should handle the main search logic
    return data.where((doctor) {
      // Check doctor name
      String doctorName =
          '${doctor.firstName ?? ''} ${doctor.lastName ?? ''}'.toLowerCase();
      if (doctorName.contains(query)) return true;

      // Check subcategory name in Arabic
      if (doctor.subCategory?.nameAr != null) {
        String subCategoryAr = doctor.subCategory!.nameAr!.toLowerCase();
        if (subCategoryAr.contains(query)) return true;
      }

      // Check subcategory name in English
      if (doctor.subCategory?.nameEn != null) {
        String subCategoryEn = doctor.subCategory!.nameEn!.toLowerCase();
        if (subCategoryEn.contains(query)) return true;
      }

      // Precise medical terms mapping for accurate search results
      Map<String, List<String>> medicalTerms = {
        'عيون': ['عيون', 'عين', 'eyes', 'ophthalmology', 'ophthalmologist'],
        'قلب': ['قلب', 'cardiology', 'cardiologist', 'heart'],
        'عظام': ['عظام', 'orthopedics', 'orthopedic', 'bones'],
        'أطفال': ['أطفال', 'pediatrics', 'pediatric', 'children'],
        'نساء': ['نساء', 'gynecology', 'gynecologist', 'women'],
        'جلدية': ['جلدية', 'dermatology', 'dermatologist', 'skin'],
        'أذن': ['أذن', 'اذن', 'ear', 'ent'],
        'مخ': ['مخ', 'اعصاب', 'neurology', 'neurologist', 'brain'],
        'انف': ['انف', 'nose', 'ent'],
        'اذن': ['اذن', 'ear', 'ent'],
        'اعصاب': ['اعصاب', 'neurology', 'neurologist'],
      };

      // Check if the search query matches any medical terms exactly
      if (medicalTerms.containsKey(query)) {
        List<String> terms = medicalTerms[query]!;
        for (String term in terms) {
          if (doctorName.contains(term) ||
              (doctor.subCategory?.nameAr?.toLowerCase().contains(term) ??
                  false) ||
              (doctor.subCategory?.nameEn?.toLowerCase().contains(term) ??
                  false)) {
            return true;
          }
        }
      }

      // If no specific match found, don't include the result
      // This ensures only relevant results are shown
      return false;
    }).toList();
  }

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
    await getDoctorsBySpecialty(specialtyId);
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
}
/*
import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/fast_booking/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/fast_booking/domain/usecases/get_subcategory_doctors_list_usecase.dart';
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
