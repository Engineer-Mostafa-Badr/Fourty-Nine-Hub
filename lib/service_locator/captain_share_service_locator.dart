import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_cubit/captain_share_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/data/datasources/captain_share_remote_data_source.dart';
import 'package:fourtyninehub/features/new_trip_join/data/repositories/captain_share_repository_imp.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/cancel_my_booking_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_available_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_expired_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_my_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_running_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/join_to_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_cancel_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_join_available_routes_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_leave_available_routes_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_new_route_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_route_use_case.dart';

class CaptainShareServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    // ================================== datasource =============================
    serviceLocator.registerLazySingleton<CaptainShareRemoteDataSource>(
        () => CaptainShareRemoteDataSourceImplementation(
              serviceLocator(),
            ));
    // ================================== repo =============================
    serviceLocator.registerLazySingleton<CaptainShareRepository>(
        () => CaptainShareRepositoryImplementation(
              serviceLocator(),
            ));
    // ================================== usecases =============================
    serviceLocator.registerLazySingleton<CreatePricePerSeatUseCase>(
        () => CreatePricePerSeatUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<CreateRouteUseCase>(
        () => CreateRouteUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetMyBookingsUseCase>(
        () => GetMyBookingsUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<CancelMyBookingUseCase>(
        () => CancelMyBookingUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetAvailableBookingsUseCase>(
        () => GetAvailableBookingsUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetExpiredBookingsUseCase>(
        () => GetExpiredBookingsUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<GetRunningBookingsUseCase>(
        () => GetRunningBookingsUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToCancelRouteUseCase>(
        () => ListenToCancelRouteUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToJoinAvailableRoutesUseCase>(
        () => ListenToJoinAvailableRoutesUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToLeaveAvailableRoutesUseCase>(
        () => ListenToLeaveAvailableRoutesUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<ListenToNewRouteUseCase>(
        () => ListenToNewRouteUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<JoinToRouteUseCase>(
        () => JoinToRouteUseCase(
              serviceLocator(),
            ));
    // ================================== cubits =============================
    serviceLocator.registerFactory<CaptainShareCubit>(
        () => CaptainShareCubit(
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
  }
}
