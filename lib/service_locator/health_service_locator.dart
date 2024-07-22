import 'package:fourtyninehub/features/health_feature/book_doctor_appointment/data/datasources/book_doctor_appointment_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/datasources/doctor_dashboard_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/repositories/doctor_dashboard_repo_impl.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/get_doctor_bookings_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/data/datasources/doctor_detail_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/data/repositories/doctor_details_repo_impl.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/repositories/doctor_details_repo.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/usecases/get_doctor_details_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/cubit/doctor_login_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/data/datasources/doctor_list_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/data/repositories/doctor_list_repo_impl.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/domain/repositories/doctor_list_repo.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/domain/usecases/get_cities_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/domain/usecases/get_doctor_list_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/domain/usecases/get_states_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctors_list/presentation/cubit/doctors_list_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/data/datasources/health_remote_datasource.dart';
import 'package:fourtyninehub/features/health_feature/health/data/repositories/health_repo_impl.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/repositories/health_repo.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_my_appointment_bookings_usecase.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/cubit/health_cubit.dart';
import 'package:get_it/get_it.dart';

import '../features/health_feature/book_doctor_appointment/data/repositories/book_doctor_appointment_repo_impl.dart';
import '../features/health_feature/book_doctor_appointment/domain/repositories/book_doctor_appointment_repo.dart';
import '../features/health_feature/book_doctor_appointment/domain/usecases/get_doctor_appointment_usecase.dart';
import '../features/health_feature/book_doctor_appointment/presentation/cubit/book_doctor_appointment_cubit.dart';
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

    serviceLocator.registerLazySingleton<BookAppointmentRemoteDataSource>(
      () => BookAppointmentRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<DoctorDashboardRemoteDataSource>(
      () => DoctorDashboardRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );

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
    serviceLocator.registerLazySingleton<BookAppointmentRepo>(
      () => BookAppointmentRepoImpl(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<DoctorDashboardRepo>(
      () => DoctorDashboardRepoImpl(
        serviceLocator(),
      ),
    );
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
    serviceLocator.registerLazySingleton<GetStatesUseCase>(
      () => GetStatesUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetCitiesUseCase>(
      () => GetCitiesUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetMyAppointmentBookingsUseCase>(
      () => GetMyAppointmentBookingsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetDoctorAppointmentsUseCase>(
      () => GetDoctorAppointmentsUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetDoctorBookingsUseCase>(
      () => GetDoctorBookingsUseCase(
        serviceLocator(),
      ),
    );

    // -------------------------- cubits --------------------------
    serviceLocator.registerFactory<DoctorDetailsCubit>(
        () => DoctorDetailsCubit(serviceLocator())..loadData());
    serviceLocator.registerFactory<DoctorsListCubit>(() => DoctorsListCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        )..loadData());
    serviceLocator.registerFactory<HealthCubit>(() => HealthCubit(
          serviceLocator(),
          serviceLocator(),
        )..loadData());
    serviceLocator.registerFactory<DoctorLoginCubit>(
      () => DoctorLoginCubit(),
    );
    serviceLocator.registerFactory<BookDoctorAppointmentCubit>(
        () => BookDoctorAppointmentCubit(
              serviceLocator(),
              serviceLocator(),
            )..loadData());
    serviceLocator
        .registerFactory<DoctorDashboardCubit>(() => DoctorDashboardCubit(
              serviceLocator(),
            )..loadData());
  }
}
