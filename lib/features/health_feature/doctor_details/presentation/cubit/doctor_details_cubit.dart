import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/user_doctor_rate.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/add_doctor_rating_use_case.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_Id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_ratings.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_reviews.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/pages/DoctorDetails.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/data/datasources/doctor_detail_remote_datasource.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final HealthSharedData _healthSharedData;
  final GetUserDoctorRatessUseCase _getUserDoctorRatessUseCase;
  final GetDoctorDetailsUseCase _getDoctorDetailsUseCase;
  final GetDoctorDetailsIdUseCase _getDoctorDetailsIdUseCase;
  final AddDoctorRatingUseCase _addDoctorRatingUseCase;
  final GetDoctorReviewsUseCase _getDoctorReviewsUseCase;
  late AppointmentEntity selectedAppointment;

  // Future<void> _getReviews(String doctorId) async {
  //   final result = await _getUserDoctorRatessUseCase.call(doctorId);
  //   result.fold(
  //         (failure) => emit(state.copyWith(failure: failure, status: DoctorDetailsStates.error)),
  //         (data) => emit(state.copyWith(rates: data)),
  //   );
  // }
  // Future<void> getDoctorReviews() async {
  //   emit(state.copyWith(status: DoctorDetailsStates.loading));
  //   final result = await _getDoctorReviewsUseCase.call(PaginationParams(page: currentPage,limit: pageSize));
  //   result.fold(
  //         (failure) => emit(state.copyWith(failure: failure, status: DoctorDetailsStates.error)),
  //     (data) => emit(state.copyWith(rates: data,status: DoctorDetailsStates.success)),
  //   );
  // }

  List<UserDoctorRateEntity> rates = [];
  bool isLoadingMore = false;

  bool hasMoreData = true;

  int currentPage = 1;

  int pageSize = 10;

  DoctorDetailsCubit(
      this._getUserDoctorRatessUseCase,
      this._healthSharedData,
      this._getDoctorDetailsUseCase,
      this._getDoctorDetailsIdUseCase,
      this._addDoctorRatingUseCase,
      this._getDoctorReviewsUseCase)
      : super(const DoctorDetailsState());
  Future<bool> addRating(AddDoctorRatingParams params) async {
    bool result = false;
    final response = await _addDoctorRatingUseCase.call(params);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: DoctorDetailsStates.error));
    }, (data) {
      result = data;
    });
    return result;
  }

  Future<void> fetchDoctorReviews() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getDoctorReviewsUseCase
        .call(PaginationParams(page: currentPage, limit: pageSize));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: DoctorDetailsStates.error));
      },
      (data) {
        rates.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: DoctorDetailsStates.success));
      },
    );
  }

  Future<void> fetchDoctorSubReviews({required String doctorId}) async {
    print("objectHelloooooo$doctorId");
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getUserDoctorRatessUseCase.call(
        GetUserDoctorRatesParams(
            doctorId: doctorId, page: currentPage, limit: pageSize));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: DoctorDetailsStates.error));
      },
      (data) {
        rates.addAll(data);

        if (data.length < (pageSize)) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: DoctorDetailsStates.success));
      },
    );
  }

  Future<void> fetchReviews(
      {required String doctorId, int? page, int? limit}) async {
    print("objectHelloooooo$doctorId");
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getUserDoctorRatessUseCase.call(
        GetUserDoctorRatesParams(
            doctorId: doctorId,
            page: page ?? currentPage,
            limit: limit ?? pageSize));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: DoctorDetailsStates.error));
      },
      (data) {
        rates.addAll(data);

        if (data.length < (limit ?? pageSize)) {
          hasMoreData = false;
        } else {
          page != null ? page = (page ?? 0) + 1 : currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: DoctorDetailsStates.success));
      },
    );
  }

  // late DoctorEntity doctor;

  Future<void> loadData(DoctorDetailsParams params) async {
    emit(state.copyWith(status: DoctorDetailsStates.loading));
    // Prefer new booking doctor details endpoint
    try {
      final remote = serviceLocator<DoctorDetailsRemoteDataSource>();
      final bookingDetails =
          await remote.getBookingDoctorById(doctorId: params.doctorId);
      await bookingDetails.fold((failure) async {
        // Fallback to legacy endpoints if booking API fails
        if (params.fromSearch == false) {
          await _getDoctorDetailsId(params);
        } else {
          await _getDoctorDetails(params);
        }
      }, (doctor) async {
        emit(state.copyWith(doctor: doctor));
      });
    } catch (_) {
      // Final fallback
      if (params.fromSearch == false) {
        await _getDoctorDetailsId(params);
      } else {
        await _getDoctorDetails(params);
      }
    }
    // After fetching doctor, also fetch availabilities from booking API and inject as appointments
    try {
      final currentDoctor = state.doctor;
      if (currentDoctor != null) {
        // Use dedicated remote from service locator
        final remote = serviceLocator<DoctorDetailsRemoteDataSource>();
        final avails = await remote.getDoctorAvailabilities(
          doctorId: params.doctorId,
          page: 1,
          limit: 100,
        );
        avails.fold(
          (failure) {
            // ignore silently for now; keep existing appointments if any
          },
          (appointments) {
            final updated = DoctorEntity(
              id: currentDoctor.id,
              lastName: currentDoctor.lastName,
              firstName: currentDoctor.firstName,
              subCategory: currentDoctor.subCategory,
              image: currentDoctor.image,
              phone: currentDoctor.phone,
              email: currentDoctor.email,
              address: currentDoctor.address,
              clinic: currentDoctor.clinic,
              calls: currentDoctor.calls,
              visitHome: currentDoctor.visitHome,
              clinicPrice: currentDoctor.clinicPrice,
              detectionPeriodClinic: currentDoctor.detectionPeriodClinic,
              detectionPeriodCalls: currentDoctor.detectionPeriodCalls,
              detectionPeriodvisitHome: currentDoctor.detectionPeriodvisitHome,
              callsPrice: currentDoctor.callsPrice,
              visitHomePrice: currentDoctor.visitHomePrice,
              meetingData: currentDoctor.meetingData,
              waitingTime: currentDoctor.waitingTime,
              timeToStart: currentDoctor.timeToStart,
              isActive: currentDoctor.isActive,
              isPremium: currentDoctor.isPremium,
              description: currentDoctor.description,
              classification: currentDoctor.classification,
              rating: currentDoctor.rating,
              createdAt: currentDoctor.createdAt,
              updatedAt: currentDoctor.updatedAt,
              isAfterEnd: currentDoctor.isAfterEnd,
              isBetweenStartAndEnd: currentDoctor.isBetweenStartAndEnd,
              appointments: appointments,
              clinicDays: currentDoctor.clinicDays,
              callDays: currentDoctor.callDays,
              currencyEn: currentDoctor.currencyEn,
              currencyAr: currentDoctor.currencyAr,
              homeVisitDays: currentDoctor.homeVisitDays,
            );
            emit(state.copyWith(doctor: updated));
          },
        );
      }
    } catch (e) {}
    await _checkCallAndChatButtons(params.doctorId);
    // Temporarily skip fetching reviews to avoid 404 for booking-only doctors
    emit(state.copyWith(status: DoctorDetailsStates.success));
  }

  void loadInitialData() async {
    emit(state.copyWith(status: DoctorDetailsStates.loading));
    rates.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchDoctorReviews();
  }

  void loadReviewsData(String doctorId) async {
    emit(state.copyWith(status: DoctorDetailsStates.loading));
    rates.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchDoctorSubReviews(doctorId: doctorId);
  }

  Future<void> _checkCallAndChatButtons(String doctorId) async {
    final response = await ButtonAvailability().isShowButton(
      otherUserId: doctorId,
      subcategoryId: _healthSharedData.doctorSearchParams.subCategory.id,
    );
    emit(state.copyWith(enabled: response));
  }

  Future<void> _getDoctorDetails(DoctorDetailsParams params) async {
    print("objectparams.type${params.type}");
    final response = await _getDoctorDetailsUseCase.call(GetDoctorDetailsParams(
      bookingType: params.type,
      doctorId: params.doctorId,
      subCategoryId:
          (params.subCategoryId != null && params.subCategoryId!.isNotEmpty)
              ? (params.subCategoryId ?? '')
              : _healthSharedData.doctorSearchParams.subCategory.id,
    ));
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: DoctorDetailsStates.error));
    }, (data) {
      // doctor = data;
      emit(state.copyWith(doctor: data));
    });
  }

  Future<void> _getDoctorDetailsId(DoctorDetailsParams params) async {
    print("objectparams.type${params.type}");

    final response =
        await _getDoctorDetailsIdUseCase.call(GetDoctorDetailsIdParams(
      doctorId: params.doctorId,
      bookingType: params.type,
      subCategoryId:
          (params.subCategoryId != null && params.subCategoryId!.isNotEmpty)
              ? (params.subCategoryId ?? '')
              : _healthSharedData.doctorSearchParams.subCategory.id,
    ));
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: DoctorDetailsStates.error));
    }, (data) {
      // doctor = data;
      emit(state.copyWith(doctor: data));
    });
  }
}
