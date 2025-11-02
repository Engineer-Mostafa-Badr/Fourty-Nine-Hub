import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/data/models/filter_option_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/cancel_appointment_use_case.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_history_booking_use_case.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_medical_services.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_user_booking_use_case.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_user_upcoming_appointments.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/is_doctor_approval_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/is_doctor_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/search_doctors_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/delete_favorite_category_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_subcategory.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/routes/routes.dart';

import '../../../../shared/domain/usecases/get_governorates.dart';
import '../../../../shared/domain/entities/governorate_entity.dart';
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
  final GetHistoryBookingUseCase _getHistoryBookingUseCase;
  final GetMostBookingUseCase _getMostBookingUseCase;
  final GetUserBookingUseCase _getUserBookingUseCase;
  final SearchDoctorsUseCase _searchDoctorsUseCase;

  final List<HealthBookingFilterModel> services = [
    HealthBookingFilterModel(
        route: Routes.FILTERDOCTORSUBCATEGORY,
        bookingType: BookingTypes.clinic,
        image: Assets.doctorClinicVisit),
    HealthBookingFilterModel(
        bookingType: BookingTypes.videoCall,
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
  String? token;
  int currentPage = 1;

  int historyPage = 1;

  bool hasMoreCurrent = true;

  bool hasMoreHistory = true;

  // Separate lists for different types
  List<BookingEntity> currentBookings = [];

  List<BookingEntity> historyBookings = [];

  bool isLoading = false;

  String currentType = 'current'; // Track current active type

  List<MostBookingEntity> mostBooking = [];
  List<BookedAppointmentEntity> myBooking = [];

  int mostBookingPage = 1;
  int myBookingPage = 1;

  bool hasMoreMost = true;
  bool hasMoreMyBooking = true;

  bool isLoadingMoreMost = true;
  bool isLoadingMyBooking = true;

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
      this._getHistoryBookingUseCase,
      this._getUserBookingUseCase,
      this._searchDoctorsUseCase,
      this._getMostBookingUseCase)
      : super(const HealthState());

  Future<bool> cancelAppointment(String id) async {
    bool result = false;
    final response = await _cancelAppointmentUseCase.call(id);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: HealthStates.error));
    }, (data) {
      List<BookedAppointmentEntity>? newBookings = state.myBookings;
      newBookings?.removeWhere((element) => element.id == id);
      result = data;
      emit(state.copyWith(myBookings: newBookings));
    });
    return result;
  }

  Future<bool> deleteMedicalService(String subcategoryId) async {
    final response = await _deleteFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: HealthStates.error));
    }, (data) {
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

  Future<void> getHistoryBookings(String type) async {
    final isCurrent = type == 'current';

    // Check if we should load more
    if ((isCurrent && (!hasMoreCurrent || isLoading)) ||
        (!isCurrent && (!hasMoreHistory || isLoading))) {
      return;
    }

    isLoading = true;
    emit(state.copyWith(isLoadingMoreBooking: true));

    final page = isCurrent ? currentPage : historyPage;
    final response = await _getHistoryBookingUseCase(
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

  Future<void> getGovernorates() async {
    // if (_healthShare.subCategories.isEmpty || reload) {
    final response = await _getGovernoratesUseCase.call(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: HealthStates.error));
    }, (data) {
      // Convert from create_doctor GovernorateEntity to shared GovernorateEntity
      final sharedGovernorates = data
          .map((e) => GovernorateEntity(
                id: e.id,
                nameAr: e.nameAr,
                nameEn: e.nameEn,
              ))
          .toList();
      _healthShare.governorates = sharedGovernorates;
      emit(state.copyWith(
          status: HealthStates.initState, governorates: sharedGovernorates));
    });
    // } else {
    //   emit(state.copyWith(subCategories: _healthShare.subCategories));
    // }
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
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
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

  Future<void> getUserBookings(String type) async {
    final isCurrent = type == 'myBookings';
    print("objectIsCurrent $isCurrent");
    if (isLoading) return; // Prevent concurrent requests if needed

    isLoading = true;
    emit(state.copyWith(isLoadingMoreMostBooking: true));

    final response = await _getUserBookingUseCase(
      GetMostBookingParams(page: myBookingPage, limit: 5),
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        isLoading = false;
        emit(state.copyWith(
          failure: failure,
          isLoadingMoreMostBooking: false,
          status: HealthStates.error,
        ));
      },
      (data) {
        myBooking.addAll(data);

        if ((data.length ?? 0) < 5) {
          hasMoreMyBooking = false;
          emit(state.copyWith(isLoadingMoreMostBooking: false));
        } else {
          myBookingPage++;
        }

        isLoadingMyBooking = false;
        emit(state.copyWith(myBookings: data, isLoadingMoreMostBooking: false));
      },
    );
  }

  Future<void> searchBookings(String name) async {
    final response = await _searchDoctorsUseCase(
      SearchDoctorsParams(page: myBookingPage, limit: 10, name: name),
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          failure: failure,
          status: HealthStates.error,
        ));
      },
      (data) {
        emit(state.copyWith(status: HealthStates.success));
      },
    );
  }

  Future<void> getMyBookings() async {
    // final response =
    //     await _getUserUpcomingAppointmentsUseCase.call(userId ?? '');
    // response.fold((failure) {
    //   var currentContext =
    //       AppPages.router.configuration.navigatorKey.currentContext!;
    //   showErrorMessage(
    //       currentContext, getFailureMessage(failure, currentContext));
    //   emit(state.copyWith(failure: failure, status: HealthStates.error));
    // },
    //     (data) => emit(
    //         state.copyWith(status: HealthStates.initState, myBookings: data)));
  }

  Future<void> getServices() async {
    final response = await _getMedicalServicesUseCase.call(userId ?? '');
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: HealthStates.error));
    },
        (data) => emit(state.copyWith(
            status: HealthStates.initState, medicalServices: data)));
  }

  Future<void> getSubCategories({bool reload = false}) async {
    // if (_healthShare.subCategories.isEmpty || reload) {
    final response = await _getHealthSubcategoriesUseCase.call(userId ?? '');
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: HealthStates.error));
    }, (data) {
      _healthShare.subCategories = data;
      emit(state.copyWith(status: HealthStates.initState, subCategories: data));
    });
    // } else {
    //   emit(state.copyWith(subCategories: _healthShare.subCategories));
    // }
  }

  void loadData() async {
    print("UseeeeeeertId$userId");
    emit(state.copyWith(status: HealthStates.loading));
    await _getMainCategoryDetails();
    await _isDoctor();
    // await _isDoctorApproval();
    await getSubCategories();
    await getServices();
    await getMyBookings();
    await getGovernorates();
  }

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

    if (type == 'history') await getHistoryBookings(type);
    if (type == 'current') await getBookings(type);
    if (type == 'myBookings') await getUserBookings(type);
    emit(state.copyWith(status: HealthStates.success));
  }

  void loadInitialMostBooking() async {
    emit(state.copyWith(status: HealthStates.loading));

    currentBookings.clear();
    mostBookingPage = 1;
    hasMoreMost = true;
    await getMostBookings();
    emit(state.copyWith(status: HealthStates.success));
  }

  void loadInitialMyBookings() async {
    emit(state.copyWith(status: HealthStates.loading));

    myBooking.clear();
    myBookingPage = 1;
    hasMoreMyBooking = true;
    await getUserBookings('myBookings');
    emit(state.copyWith(status: HealthStates.success));
  }

  // Call this when user switches between current/history tabs
  void switchBookingType(String type) {
    if (currentType == type) return;
    loadInitialBooking(type);
  }

  Future<bool> toggleFavoriteCategory(String categoryId) async {
    final response = await _toggleFavoriteCategoryUseCase(categoryId);
    bool result = false;
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: HealthStates.error));
    }, (data) {
      // Update main category favorite status if it exists
      if (state.mainCategory != null) {
        MainCategoryEntity newMainCategory = state.mainCategory!;
        newMainCategory.isFavorite = !(state.mainCategory?.isFavorite ?? false);

        // Also update all medical services favorite status to match main category
        List<HealthSubcategoryEntity> newMedicalServices =
            state.medicalServices ?? [];
        for (int i = 0; i < newMedicalServices.length; i++) {
          newMedicalServices[i].isFavorite = newMainCategory.isFavorite;
        }

        // Also update all subcategories favorite status to match main category
        List<HealthSubcategoryEntity> newSubCategories =
            state.subCategories ?? [];
        for (int i = 0; i < newSubCategories.length; i++) {
          newSubCategories[i].isFavorite = newMainCategory.isFavorite;
        }

        emit(state.copyWith(
          mainCategory: newMainCategory,
          medicalServices: newMedicalServices,
          subCategories: newSubCategories,
        ));
        result = newMainCategory.isFavorite ?? false;
      } else {
        // If mainCategory is null, just update the result
        result = true; // Assume success since API returned success
      }
    });
    return result;
  }

  Future<bool> toggleFavoriteMedicalService(String subcategoryId) async {
    await _ensureTokenInitialized();
    final response = await _toggleFavoriteSubcategoryUseCase(subcategoryId);
    bool result = false;
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: HealthStates.error));
    }, (data) {
      // Create new lists to trigger BlocBuilder update
      List<HealthSubcategoryEntity> newMedicalServices =
          List<HealthSubcategoryEntity>.from(state.medicalServices ?? []);
      try {
        final serviceIndex = newMedicalServices
            .indexWhere((element) => element.id == subcategoryId);
        if (serviceIndex != -1) {
          // Toggle the favorite status
          newMedicalServices[serviceIndex].isFavorite =
              !(newMedicalServices[serviceIndex].isFavorite ?? false);
          result = newMedicalServices[serviceIndex].isFavorite ?? false;

          // Also update subcategories if they exist
          List<HealthSubcategoryEntity> newSubCategories =
              List<HealthSubcategoryEntity>.from(state.subCategories ?? []);
          final subCategoryIndex = newSubCategories
              .indexWhere((element) => element.id == subcategoryId);
          if (subCategoryIndex != -1) {
            newSubCategories[subCategoryIndex].isFavorite =
                newMedicalServices[serviceIndex].isFavorite;
          }

          // Update main category favorite status based on subcategory status
          if (state.mainCategory != null) {
            MainCategoryEntity newMainCategory = state.mainCategory!;
            newMainCategory.isFavorite =
                newMedicalServices[serviceIndex].isFavorite;

            emit(state.copyWith(
              mainCategory: newMainCategory,
              medicalServices: newMedicalServices,
              subCategories: newSubCategories,
            ));
          } else {
            emit(state.copyWith(
              medicalServices: newMedicalServices,
              subCategories: newSubCategories,
            ));
          }
        }
      } catch (e) {
        print('Error toggling favorite for service $subcategoryId: $e');
      }
    });
    return result;
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
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: HealthStates.error));
    }, (data) {
      // Create new lists to trigger BlocBuilder update
      List<HealthSubcategoryEntity> newSubCategories =
          List<HealthSubcategoryEntity>.from(state.subCategories ?? []);
      try {
        final subCategoryIndex = newSubCategories
            .indexWhere((element) => element.id == subcategoryId);
        if (subCategoryIndex != -1) {
          // Toggle the favorite status
          newSubCategories[subCategoryIndex].isFavorite =
              !(newSubCategories[subCategoryIndex].isFavorite ?? false);

          // Also update medical services if they exist
          List<HealthSubcategoryEntity> newMedicalServices =
              List<HealthSubcategoryEntity>.from(state.medicalServices ?? []);
          final serviceIndex = newMedicalServices
              .indexWhere((element) => element.id == subcategoryId);
          if (serviceIndex != -1) {
            newMedicalServices[serviceIndex].isFavorite =
                newSubCategories[subCategoryIndex].isFavorite;
          }

          // Update main category favorite status based on subcategory status
          if (state.mainCategory != null) {
            MainCategoryEntity newMainCategory = state.mainCategory!;
            newMainCategory.isFavorite =
                newSubCategories[subCategoryIndex].isFavorite;

            emit(state.copyWith(
              mainCategory: newMainCategory,
              subCategories: newSubCategories,
              medicalServices: newMedicalServices,
            ));
          } else {
            emit(state.copyWith(
              subCategories: newSubCategories,
              medicalServices: newMedicalServices,
            ));
          }
        }
      } catch (e) {
        print('Error toggling favorite for subcategory $subcategoryId: $e');
      }
    });
  }

  Future<void> _ensureTokenInitialized() async {
    token ??= await CacheManager.getAccessToken();
  }

  Future<void> _getMainCategoryDetails() async {
    final response =
        await _getMainCategoryDetailsUseCase(MainServicesEnum.health.id);
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: HealthStates.error));
      },
      (data) => emit(state.copyWith(mainCategory: data)),
    );
  }

  Future<void> _isDoctor() async {
    final response = await _isDoctorUseCase.call(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: HealthStates.error));
    },
        (data) => emit(state.copyWith(
            isDoctor: data.isDoctor, isApproved: data.isApproved)));
  }

  Future<void> _isDoctorApproval() async {
    final response = await _isDoctorApprovalUsecase.call(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: HealthStates.error));
    }, (data) => emit(state.copyWith(isApproved: data)));
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
