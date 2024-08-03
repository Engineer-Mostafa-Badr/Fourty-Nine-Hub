import 'package:fourtyninehub/features/health_feature/booking/data/datasources/book_doctor_appointment_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_premium_appointment.dart';
import 'package:fourtyninehub/features/health_feature/booking/domain/usecases/book_regular_appointment.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/datasources/create_doctor_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/data/repositories/create_repo_doctor_imp.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/repositories/create_doctor_repo.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_cities.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_governorates.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/datasources/doctor_dashboard_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/repositories/doctor_dashboard_repo_impl.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_bookings_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/data/datasources/doctor_detail_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/data/repositories/doctor_details_repo_impl.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_reviews.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/governorate_filter_cubit/doctor_governorate_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/city_filter_cubit/doctor_city_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/subcategory_filter_cubit/doctor_filter_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/data/datasources/doctor_list_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/data/repositories/doctor_list_repo_impl.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/repositories/doctor_list_repo.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/doctors_list_cubit/doctors_list_cubit.dart';
import 'package:fourtyninehub/features/health_feature/emergency/data/datasources/emergency_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/emergency/data/repositories/emergency_repo_impl.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/repositories/emergency_repo.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/book_emergency.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/data/datasources/health_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/health/data/repositories/health_repo_impl.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_my_appointment_bookings_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_user_upcoming_appointments.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:get_it/get_it.dart';

import '../features/health_feature/booking/data/repositories/book_doctor_appointment_repo_impl.dart';
import '../features/health_feature/booking/domain/repositories/book_doctor_appointment_repo.dart';
import '../features/health_feature/booking/presentation/cubit/book_doctor_appointment_cubit.dart';
import '../features/health_feature/doctor_dashboard/presentation/cubit/doctor_dashboard_cubit.dart';

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

    serviceLocator.registerLazySingleton<DoctorDashboardRemoteDataSource>(
      () => DoctorDashboardRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<CreateDoctorRemoteDataSource>(
        () => CreateDoctorRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<HealthEmergencyRemoteDataSource>(
        () => HealthEmergencyRemoteDataSourceImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<BookAppointmentRemoteDataSource>(
        () => BookAppointmentRemoteDataSourceImpl(serviceLocator()));
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

    serviceLocator.registerLazySingleton<DoctorDashboardRepo>(
      () => DoctorDashboardRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<CreateDoctorRepo>(
        () => CreateDoctorRepoImpl(serviceLocator()));

    serviceLocator.registerLazySingleton<HealthEmergencyRepo>(
        () => HealthEmergencyRepoImpl(serviceLocator()));
    serviceLocator.registerLazySingleton<BookAppointmentRepo>(
        () => BookAppointmentRepoImpl(serviceLocator()));
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

    serviceLocator.registerLazySingleton<GetDoctorBookingsUseCase>(
      () => GetDoctorBookingsUseCase(
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

    // -------------------------- cubits --------------------------
    serviceLocator.registerSingleton<HealthSharedData>(HealthSharedData());
    serviceLocator.registerFactory<DoctorDetailsCubit>(() => DoctorDetailsCubit(
        serviceLocator(), serviceLocator(), serviceLocator()));
    serviceLocator.registerFactory<DoctorsListCubit>(() => DoctorsListCubit(
          serviceLocator(),
          serviceLocator(),
        ));
    serviceLocator.registerFactory<HealthCubit>(() => HealthCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        )..loadData());
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
        .registerFactory<DoctorDashboardCubit>(() => DoctorDashboardCubit(
              serviceLocator(),
            )..loadData());
  }
}
