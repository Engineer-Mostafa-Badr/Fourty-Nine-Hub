import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/filter_option_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/cancel_appointment_use_case.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_medical_services.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_user_upcoming_appointments.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/is_doctor_approval_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/is_doctor_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/delete_favorite_category_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_subcategory.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';

import '../../../../create_doctor/domain/entities/governorate_entity.dart';
import '../../../../create_doctor/domain/usecases/get_governorates.dart';
import '../../../domain/entities/appointment_booking_entity.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../../domain/entities/most_booking_entity.dart';
import '../../../domain/usecases/get_booking_use_case.dart';
import '../../../domain/usecases/get_most_booking_use_case.dart';

part 'health_state.dart';

class HealthCubit extends Cubit<HealthState> {
  final HealthSharedData _healthShare;
  final GetUserUpcomingAppointmentsUseCase _getUserUpcomingAppointmentsUseCase;
  final CancelAppointmentUseCase _cancelAppointmentUseCase;
  final GetHealthSubcategoriesUseCase _getHealthSubcategoriesUseCase;
  final GetMedicalServicesUseCase _getMedicalServicesUseCase;
  final ToggleFavoriteSubcategoryUseCase _toggleFavoriteSubcategoryUseCase;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;
  final DeleteFavoriteCategoryUseCase _deleteFavoriteCategoryUseCase;
  final IsDoctorUsecase _isDoctorUseCase;
  final IsDoctorApprovalUsecase _isDoctorApprovalUsecase;
  final GetMainCategoryDetailsUseCase _getMainCategoryDetailsUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetBookingUseCase _getBookingUseCase;
  final GetMostBookingUseCase _getMostBookingUseCase;

  HealthCubit(
      this._getUserUpcomingAppointmentsUseCase,
      this._healthShare,
      this._getHealthSubcategoriesUseCase,
      this._getMedicalServicesUseCase,
      this._toggleFavoriteSubcategoryUseCase,
      this._isDoctorUseCase,
      this._getMainCategoryDetailsUseCase,
      this._getGovernoratesUseCase,
      this._isDoctorApprovalUsecase,
      this._toggleFavoriteCategoryUseCase,
      this._deleteFavoriteCategoryUseCase,
      this._cancelAppointmentUseCase,
      this._getBookingUseCase,
      this._getMostBookingUseCase)
      : super(const HealthState());

  final List<HealthBookingFilterModel> services = [
    HealthBookingFilterModel(
        route: Routes.FILTERDOCTORSUBCATEGORY,
        bookingType: BookingTypes.clinic,
        image: Assets.doctorClinicVisit),
    HealthBookingFilterModel(
        bookingType: BookingTypes.call,
        image: Assets.doctorCall,
        route: Routes.FILTERDOCTORSUBCATEGORY),
    HealthBookingFilterModel(
        bookingType: BookingTypes.home,
        image: Assets.doctorHomeVisit,
        route: Routes.FILTERDOCTORSUBCATEGORY),
    HealthBookingFilterModel(
        bookingType: BookingTypes.emergency,
        image: Assets.emergency,
        route: Routes.VISITAEMERGENCY),
  ];
  final userId = UserCubit.to.state.data?.id;
  void loadData() async {
    print("UseeeeeeertId$userId");
    emit(state.copyWith(status: HealthStates.loading));
    await _getMainCategoryDetails();
    await _isDoctor();
    await _isDoctorApproval();
    await getSubCategories();
    await getServices();
    await getMyBookings();
    await getGovernorates();
  }

  Future<void> _getMainCategoryDetails() async {
    final response =
        await _getMainCategoryDetailsUseCase(MainServicesEnum.health.id);
    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: HealthStates.error)),
      (data) => emit(state.copyWith(mainCategory: data)),
    );
  }

  Future<void> getMyBookings() async {
    final response =
        await _getUserUpcomingAppointmentsUseCase.call(userId ?? '');
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(
            state.copyWith(status: HealthStates.initState, myBookings: data)));
  }

  Future<bool> cancelAppointment(String id) async {
    bool result = false;
    final response = await _cancelAppointmentUseCase.call(id);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      List<BookedAppointmentEntity>? newBookings = state.myBookings;
      newBookings?.removeWhere((element) => element.id == id);
      result = data;
      emit(state.copyWith(myBookings: newBookings));
    });
    return result;
  }

  Future<void> _isDoctor() async {
    final response = await _isDoctorUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(state.copyWith(isDoctor: data)));
  }

  Future<void> _isDoctorApproval() async {
    final response = await _isDoctorApprovalUsecase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(state.copyWith(isApproved: data)));
  }

  Future<void> getServices() async {
    final response = await _getMedicalServicesUseCase.call(userId ?? '');
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) => emit(state.copyWith(
            status: HealthStates.initState, medicalServices: data)));
  }

  Future<void> getSubCategories({bool reload = false}) async {
    // if (_healthShare.subCategories.isEmpty || reload) {
    final response = await _getHealthSubcategoriesUseCase.call(userId ?? '');
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      _healthShare.subCategories = data;
      emit(state.copyWith(status: HealthStates.initState, subCategories: data));
    });
    // } else {
    //   emit(state.copyWith(subCategories: _healthShare.subCategories));
    // }
  }

  Future<void> getGovernorates() async {
    // if (_healthShare.subCategories.isEmpty || reload) {
    final response = await _getGovernoratesUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      _healthShare.governorates = data;
      emit(state.copyWith(status: HealthStates.initState, governorates: data));
    });
    // } else {
    //   emit(state.copyWith(subCategories: _healthShare.subCategories));
    // }
  }

  // Future<void> toggleFavoriteSubcategory(String subcategoryId) async {
  //   final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
  //   response.fold(
  //       (failure) =>
  //           emit(state.copyWith(failure: failure, status: HealthStates.error)),
  //       (data) {
  //     return getSubCategories(reload: true);
  //   });
  // }
  Future<void> toggleFavoriteSubcategory(String subcategoryId) async {
    final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
    response.fold((failure) => emit(state.copyWith(status: HealthStates.error)),
        (data) {
      List<HealthSubcategoryEntity> newSubCategories =
          state.subCategories ?? [];
      newSubCategories
          .firstWhere((element) => element.id == subcategoryId)
          .isFavorite = !(newSubCategories
              .firstWhere((element) => element.id == subcategoryId)
              .isFavorite ??
          false);
      // getSubCategories(reload: true);
      emit(state.copyWith(subCategories: newSubCategories));
    });
  }

  Future<bool> toggleFavoriteMedicalService(String subcategoryId) async {
    await _ensureTokenInitialized();
    final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      List<HealthSubcategoryEntity> newMedicalServices =
          state.medicalServices ?? [];
      newMedicalServices
          .firstWhere((element) => element.id == subcategoryId)
          .isFavorite = !(newMedicalServices
              .firstWhere((element) => element.id == subcategoryId)
              .isFavorite ??
          false);
      emit(state.copyWith(medicalServices: newMedicalServices));
    });
    return result;
  }

  Future<bool> toggleFavoriteCategory(String subcategoryId) async {
    final response = await _toggleFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      // MainCategoryEntity mainCategoryEntity;
      //   mainCategoryEntity = state.mainCategory!;
      //   mainCategoryEntity.isFavorite = !mainCategoryEntity.isFavorite!;
      // emit(state.copyWith(mainCategory: mainCategoryEntity));
      // result = state.mainCategory!.isFavorite!;
      // print("Salama ${data}");
      MainCategoryEntity newMainCategory = state.mainCategory!;
      newMainCategory.isFavorite = !(state.mainCategory?.isFavorite ?? false);
      emit(state.copyWith(mainCategory: newMainCategory));
      // _getMainCategoryDetails();

      // return getServices();
    });
    return result;
  }

  String? token;

  Future<void> _ensureTokenInitialized() async {
    token ??= await CacheManager.getAccessToken();
  }

  Future<bool> deleteMedicalService(String subcategoryId) async {
    final response = await _deleteFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: HealthStates.error)),
        (data) {
      MainCategoryEntity mainCategoryEntity;
      mainCategoryEntity = state.mainCategory!;
      mainCategoryEntity.isFavorite = !mainCategoryEntity.isFavorite!;
      emit(state.copyWith(mainCategory: mainCategoryEntity));
      result = state.mainCategory!.isFavorite!;
      print("Salama $data");
      return getServices();
    });
    return result;
  }

  int currentPage = 1;
  int historyPage = 1;
  bool hasMoreCurrent = true;
  bool hasMoreHistory = true;

  // Separate lists for different types
  List<BookingEntity> currentBookings = [];
  List<BookingEntity> historyBookings = [];

  bool isLoading = false;
  String currentType = 'current'; // Track current active type

  Future<void> loadInitialBooking(String type) async {
    currentType = type;
    emit(state.copyWith(status: HealthStates.loading));

    // Reset the appropriate list and pagination
    if (type == 'current') {
      currentBookings.clear();
      currentPage = 1;
      hasMoreCurrent = true;
    } else {
      historyBookings.clear();
      historyPage = 1;
      hasMoreHistory = true;
    }

    await getBookings(type);
    emit(state.copyWith(status: HealthStates.success));
  }

  Future<void> getBookings(String type) async {
    final isCurrent = type == 'current';

    // Check if we should load more
    if ((isCurrent && (!hasMoreCurrent || isLoading)) ||
        (!isCurrent && (!hasMoreHistory || isLoading))) {
      return;
    }

    isLoading = true;
    emit(state.copyWith(isLoadingMoreBooking: true));

    final page = isCurrent ? currentPage : historyPage;
    final response = await _getBookingUseCase(
      GetBookingParams(page: page, limit: 5, type: type),
    );

    response.fold(
      (failure) {
        isLoading = false;
        emit(state.copyWith(
          failure: failure,
          isLoadingMoreBooking: false,
          status: HealthStates.error,
        ));
      },
      (data) {
        if (isCurrent) {
          currentBookings.addAll(data);
          currentPage++;
          hasMoreCurrent = data.length >= 5;
        } else {
          historyBookings.addAll(data);
          historyPage++;
          hasMoreHistory = data.length >= 5;
        }

        isLoading = false;
        emit(state.copyWith(
          currentBookings: currentBookings,
          historyBookings: historyBookings,
          isLoadingMoreBooking: false,
          activeBookingType: type,
        ));
      },
    );
  }

  // Call this when user switches between current/history tabs
  void switchBookingType(String type) {
    if (currentType == type) return;
    loadInitialBooking(type);
  }

  List<MostBookingEntity> mostBooking = [];

  int mostBookingPage = 1;
  bool hasMoreMost = true;
  bool isLoadingMoreMost = true;

  void loadInitialMostBooking() async {
    emit(state.copyWith(status: HealthStates.loading));

    currentBookings.clear();
    mostBookingPage = 1;
    hasMoreMost = true;
    await getMostBookings();
    emit(state.copyWith(status: HealthStates.success));
  }

  Future<void> getMostBookings() async {
    if (isLoading) return; // Prevent concurrent requests if needed

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
        emit(
            state.copyWith(mostBooking: data, isLoadingMoreMostBooking: false));
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

  // Future<void> getMostBookings() async {
  //   isLoading = true;
  //   emit(state.copyWith(isLoadingMoreBooking: true));
  //
  //   final response = await _getMostBookingUseCase(
  //     GetMostBookingParams(page: mostBookingPage, limit: 5, ),
  //   );
  //
  //   response.fold(
  //         (failure) {
  //       isLoading = false;
  //       emit(state.copyWith(
  //         failure: failure,
  //         isLoadingMoreBooking: false,
  //         status: HealthStates.error,
  //       ));
  //     },
  //         (data) {
  //         mostBooking.addAll(data);
  //         mostBookingPage++;
  //         hasMoreCurrent = data.length >= 5;
  //       isLoading = false;
  //       emit(state.copyWith(
  //         mostBooking: mostBooking,
  //         isLoadingMoreBooking: false,
  //       ));
  //     },
  //   );
  // }
}
