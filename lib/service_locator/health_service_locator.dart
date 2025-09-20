import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_history_booking_use_case.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_user_booking_use_case.dart';

import '../features/health_feature/booking/data/datasources/book_doctor_appointment_remote_datasource.dart';
import '../features/health_feature/booking/domain/usecases/all_appointment_use_case.dart';
import '../features/health_feature/booking/domain/usecases/book_premium_appointment.dart';
import '../features/health_feature/booking/domain/usecases/book_regular_appointment.dart';
import '../features/health_feature/booking/domain/usecases/doctor_cancel_appointment_use_case.dart';
import '../features/health_feature/booking/presentation/cubit/all_appointments_cubit/all_appointments_cubit.dart';
import '../features/health_feature/create_doctor/data/datasources/create_doctor_remote_datasource.dart';
import '../features/health_feature/create_doctor/data/repositories/create_repo_doctor_imp.dart';
import '../features/health_feature/create_doctor/domain/repositories/create_doctor_repo.dart';
import '../features/health_feature/create_doctor/domain/usecases/create_doctor.dart';
import '../features/health_feature/create_doctor/domain/usecases/get_cities.dart';
import '../features/health_feature/create_doctor/domain/usecases/get_governorates.dart';
import '../features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import '../features/health_feature/doctor_dashboard/data/datasources/remote_datasource.dart';
import '../features/health_feature/doctor_dashboard/data/repositories/doctor_dashboard_repo_impl.dart';
import '../features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/delete_doctor_account_usecase.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/doctor_accept_appointment_usecase.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/doctor_reject_appointment.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/get_all_doctor_reservations_usecase.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/get_doctor_appointments_by_day.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/get_doctor_profile_usecase.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/get_doctor_statistics_usecase.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/get_doctor_unhandled_appointments_usecase.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/get_doctor_work_days_usecase.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/get_id_remaining_days.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/get_practicing_remaining_days.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/get_subscription_remaining_days.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/update_doctor_personal_info_usecase.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/update_doctor_practicing_cirtification_usecase.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/update_doctor_profile_photo_usecase.dart';
import '../features/health_feature/doctor_dashboard/domain/usecases/update_doctor_timetable_usecase.dart';
import '../features/health_feature/doctor_dashboard/presentation/controllers/all_doctor_reservations/all_doctor_reservations_cubit.dart';
import '../features/health_feature/doctor_dashboard/presentation/controllers/doctor_dashboard/doctor_dashboard_cubit.dart';
import '../features/health_feature/doctor_dashboard/presentation/controllers/doctor_statistics/doctor_statistics_cubit.dart';
import '../features/health_feature/doctor_dashboard/presentation/controllers/doctor_today_appointments/doctor_today_appointments_cubit.dart';
import '../features/health_feature/doctor_dashboard/presentation/controllers/doctor_unhandled_appotinments/doctor_unhandled_appotinments_cubit.dart';
import '../features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_personal_info/edit_doctor_personal_info_cubit.dart';
import '../features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_profile/edit_doctor_profile_cubit.dart';
import '../features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_timetable/edit_doctor_timetable_cubit.dart';
import '../features/health_feature/doctor_details/data/datasources/doctor_detail_remote_datasource.dart';
import '../features/health_feature/doctor_details/data/repositories/doctor_details_repo_impl.dart';
import '../features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';
import '../features/health_feature/doctor_details/domain/usecases/add_doctor_rating_use_case.dart';
import '../features/health_feature/doctor_details/domain/usecases/get_doctor_details_Id_usecase.dart';
import '../features/health_feature/doctor_details/domain/usecases/get_doctor_details_usecase.dart';
import '../features/health_feature/doctor_details/domain/usecases/get_doctor_ratings.dart';
import '../features/health_feature/doctor_details/domain/usecases/get_doctor_reviews.dart';
import '../features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import '../features/health_feature/doctor_filter/data/datasources/doctor_list_remote_datasource.dart';
import '../features/health_feature/doctor_filter/data/repositories/doctor_list_repo_impl.dart';
import '../features/health_feature/doctor_filter/domain/repositories/doctor_list_repo.dart';
import '../features/health_feature/doctor_filter/domain/usecases/get_subcategory_doctors_list_usecase.dart';
import '../features/health_feature/doctor_filter/presentation/controllers/city_filter_cubit/doctor_city_filter_cubit.dart';
import '../features/health_feature/doctor_filter/presentation/controllers/doctors_list_cubit/doctors_list_cubit.dart';
import '../features/health_feature/doctor_filter/presentation/controllers/governorate_filter_cubit/doctor_governorate_filter_cubit.dart';
import '../features/health_feature/doctor_filter/presentation/controllers/subcategory_filter_cubit/doctor_filter_cubit.dart';
import '../features/health_feature/emergency/data/datasources/emergency_remote_datasource.dart';
import '../features/health_feature/emergency/data/repositories/emergency_repo_impl.dart';
import '../features/health_feature/emergency/domain/repositories/emergency_repo.dart';
import '../features/health_feature/emergency/domain/usecases/book_emergency.dart';
import '../features/health_feature/emergency/domain/usecases/get_emergency_requests_use_case.dart';
import '../features/health_feature/emergency/presentation/cubit/emergency_cubit.dart';
import '../features/health_feature/emergency/presentation/cubit/emergency_requests_cubit.dart';
import '../features/health_feature/health/data/datasources/health_remote_datasource.dart';
import '../features/health_feature/health/data/repositories/health_repo_impl.dart';
import '../features/health_feature/health/domain/repositories/health_repo.dart';
import '../features/health_feature/health/domain/usecases/cancel_appointment_use_case.dart';
import '../features/health_feature/health/domain/usecases/doctor_info_usecase.dart';
import '../features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import '../features/health_feature/health/domain/usecases/get_medical_services.dart';
import '../features/health_feature/health/domain/usecases/get_my_appointment_bookings_usecase.dart';
import '../features/health_feature/health/domain/usecases/get_user_upcoming_appointments.dart';
import '../features/health_feature/health/domain/usecases/is_doctor_approval_usecase.dart';
import '../features/health_feature/health/domain/usecases/is_doctor_usecase.dart';
import '../features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import '../features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import '../features/subcategories/domain/usecases/delete_favorite_category_use_case.dart';
import '../features/subcategories/domain/usecases/toggle_favorite_category.dart';
import '../features/subcategories/domain/usecases/toggle_favorite_subcategory.dart';
import 'package:get_it/get_it.dart';

import '../features/health_feature/booking/data/repositories/book_doctor_appointment_repo_impl.dart';
import '../features/health_feature/booking/domain/repositories/book_doctor_appointment_repo.dart';
import '../features/health_feature/booking/presentation/cubit/book_doctor_appointment_cubit.dart';
import '../features/health_feature/doctor_filter/domain/usecases/get_doctor_list_use_case.dart';
import '../features/health_feature/health/domain/usecases/get_booking_use_case.dart';
import '../features/health_feature/health/domain/usecases/get_most_booking_use_case.dart';

class HealthServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    // -------------------Data Source ----------------------
    serviceLocator.registerLazySingleton<DoctorDetailsRemoteDataSource>(
      () => DoctorDetailsRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<DoctorListRemoteDataSource>(
      () => DoctorListRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<HealthRemoteDataSource>(
      () => HealthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );
    // serviceLocator.registerLazySingleton<NotificationRepo>(
    //       () => NotificationRepoImpl(
    //     serviceLocator(),
    //   ),
    // );

    serviceLocator.registerLazySingleton<CreateDoctorRemoteDataSource>(
        () => CreateDoctorRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<HealthEmergencyRemoteDataSource>(
        () => HealthEmergencyRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<BookAppointmentRemoteDataSource>(
        () => BookAppointmentRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<DoctorDashboardRemoteDataSource>(
        () => DoctorDashboardRemoteDataSourceImpl(serviceLocator()));
    // -------------------Repository ----------------------
    serviceLocator.registerLazySingleton<DoctorDetailsRepo>(
      () => DoctorDetailsRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<DoctorListRepo>(
      () => DoctorListRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<HealthRepo>(
      () => HealthRepoImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<CreateDoctorRepo>(
        () => CreateDoctorRepoImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<HealthEmergencyRepo>(
        () => HealthEmergencyRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<BookAppointmentRepo>(
        () => BookAppointmentRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<DoctorDashboardRepo>(
        () => DoctorDashboardRepoImpl(serviceLocator()));
    // -------------------UseCases ----------------------
    serviceLocator.registerLazySingleton<GetDoctorDetailsUseCase>(
      () => GetDoctorDetailsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetDoctorListUseCase>(
      () => GetDoctorListUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator
        .registerLazySingleton<GetMyAppointmentBookingsHistoryUseCase>(
      () => GetMyAppointmentBookingsHistoryUseCase(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<GetCitiesUseCase>(
        () => GetCitiesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<CreateDoctorUseCase>(
        () => CreateDoctorUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetGovernoratesUseCase>(
        () => GetGovernoratesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<BookHealthEmergencyUseCase>(
        () => BookHealthEmergencyUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetEmergencyRequestsUseCase>(
        () => GetEmergencyRequestsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<BookRegularAppointmentUseCase>(
        () => BookRegularAppointmentUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetUserDoctorRatessUseCase>(
        () => GetUserDoctorRatessUseCase(serviceLocator()));

    serviceLocator.registerLazySingleton<GetUserUpcomingAppointmentsUseCase>(
        () => GetUserUpcomingAppointmentsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<BookPremiumAppointmentUseCase>(
        () => BookPremiumAppointmentUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetHealthSubcategoriesUseCase>(
        () => GetHealthSubcategoriesUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetMedicalServicesUseCase>(
      () => GetMedicalServicesUseCase(serviceLocator()),
    );
    serviceLocator.registerLazySingleton<ToggleFavoriteSubcategoryUseCase>(
        () => ToggleFavoriteSubcategoryUseCase(serviceLocator()));
    serviceLocator
        .registerLazySingleton<GetDoctorSubscriptionRemainingDaysUseCase>(
            () => GetDoctorSubscriptionRemainingDaysUseCase(serviceLocator()));
    serviceLocator
        .registerLazySingleton<GetDoctorPracticingRemainingDaysUseCase>(
            () => GetDoctorPracticingRemainingDaysUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDoctorIDRemainingDaysUseCase>(
        () => GetDoctorIDRemainingDaysUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDoctorAppointmentsByDayUseCase>(
        () => GetDoctorAppointmentsByDayUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDoctorUnhandledAppointmentsUseCase>(
        () => GetDoctorUnhandledAppointmentsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<IsDoctorUsecase>(
        () => IsDoctorUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<DoctorRejectAppointmentUsecase>(
        () => DoctorRejectAppointmentUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<DoctorAcceptAppointmentUsecase>(
        () => DoctorAcceptAppointmentUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDoctorStatisticsUsecase>(
        () => GetDoctorStatisticsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetAllDoctorReservationsUsecase>(
        () => GetAllDoctorReservationsUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDoctorProfileUseCase>(
        () => GetDoctorProfileUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateDoctorIDUsecase>(
        () => UpdateDoctorIDUsecase(serviceLocator()));
    serviceLocator
        .registerLazySingleton<UpdateDoctorPracticingCirtificateUsecase>(
            () => UpdateDoctorPracticingCirtificateUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateDoctorProfilePhotoUsecase>(
        () => UpdateDoctorProfilePhotoUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<DeleteDoctorAccountUseCase>(
        () => DeleteDoctorAccountUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<IsDoctorApprovalUsecase>(
        () => IsDoctorApprovalUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<ToggleFavoriteCategoryUseCase>(
        () => ToggleFavoriteCategoryUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<DeleteFavoriteCategoryUseCase>(
        () => DeleteFavoriteCategoryUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<DoctorInfoUseCase>(
        () => DoctorInfoUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDoctorDetailsIdUseCase>(
        () => GetDoctorDetailsIdUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetSubCategoryDoctorsListUseCase>(
        () => GetSubCategoryDoctorsListUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<AddDoctorRatingUseCase>(
        () => AddDoctorRatingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDoctorReviewsUseCase>(
        () => GetDoctorReviewsUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateDoctorPersonalInfoUsecase>(
        () => UpdateDoctorPersonalInfoUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetDoctorWorkDaysUsecase>(
        () => GetDoctorWorkDaysUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<UpdateDoctorTimetableUsecase>(
        () => UpdateDoctorTimetableUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton<CancelAppointmentUseCase>(
        () => CancelAppointmentUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<AllAppointmentUseCase>(
        () => AllAppointmentUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<DoctorCancelAppointmentUseCase>(
        () => DoctorCancelAppointmentUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetBookingUseCase>(
        () => GetBookingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetMostBookingUseCase>(
        () => GetMostBookingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetHistoryBookingUseCase>(
        () => GetHistoryBookingUseCase(serviceLocator()));
    serviceLocator.registerLazySingleton<GetUserBookingUseCase>(
        () => GetUserBookingUseCase(serviceLocator()));
    // -------------------------- cubits --------------------------
    serviceLocator.registerSingleton<HealthSharedData>(HealthSharedData());
    serviceLocator.registerFactory<DoctorDetailsCubit>(() => DoctorDetailsCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator()));
    serviceLocator.registerFactory<DoctorsListCubit>(() => DoctorsListCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
    serviceLocator.registerFactory<EditDoctorPersonalInfoCubit>(
        () => EditDoctorPersonalInfoCubit(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            ));
    serviceLocator.registerFactory<EditDoctorTimetableCubit>(
        () => EditDoctorTimetableCubit(
              serviceLocator(),
              serviceLocator(),
            ));
    serviceLocator.registerFactory<HealthCubit>(() => HealthCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
    serviceLocator.registerFactory<CreateDoctorCubit>(
      () => CreateDoctorCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      )..loadData(),
    );

    serviceLocator.registerFactory<DoctorSubcategoryFilterCubit>(
        () => DoctorSubcategoryFilterCubit(
              serviceLocator(),
              serviceLocator(),
            )..loadData());

    serviceLocator.registerFactory<HealthEmergencyCubit>(() =>
        HealthEmergencyCubit(
            serviceLocator(), serviceLocator(), serviceLocator())
          ..loadData());

    serviceLocator
        .registerFactory<EmergencyRequestsCubit>(() => EmergencyRequestsCubit(
              serviceLocator(),
            ));

    serviceLocator.registerFactory(() =>
        DoctorGovernorateFilterCubit(serviceLocator(), serviceLocator())
          ..loadData());
    serviceLocator
        .registerFactory(() => DoctorCityFilterCubit(serviceLocator()));

    serviceLocator.registerFactory<BookDoctorAppointmentCubit>(
        () => BookDoctorAppointmentCubit(
              serviceLocator(),
              serviceLocator(),
            ));

    serviceLocator
        .registerFactory<AllAppointmentsCubit>(() => AllAppointmentsCubit(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            ));

    serviceLocator
        .registerFactory<DoctorDashboardCubit>(() => DoctorDashboardCubit(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            ));

    serviceLocator.registerFactory<DoctorTodayAppointmentsCubit>(
        () => DoctorTodayAppointmentsCubit(
              serviceLocator(),
              serviceLocator(),
            ));

    serviceLocator.registerFactory<DoctorUnhandledAppointmentsCubit>(
        () => DoctorUnhandledAppointmentsCubit(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            ));

    serviceLocator
        .registerFactory<DoctorStatisticsCubit>(() => DoctorStatisticsCubit(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<AllDoctorReservationsCubit>(
        () => AllDoctorReservationsCubit(serviceLocator())..loadData());

    serviceLocator
        .registerFactory<EditDoctorProfileCubit>(() => EditDoctorProfileCubit(
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
              serviceLocator(),
            )..loadData());
  }
}
