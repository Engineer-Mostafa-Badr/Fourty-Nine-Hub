import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/notifications/domain/entities/user_trip_entity.dart';
import 'package:fourtyninehub/features/notifications/domain/usecases/get_all_user_trips_usecase.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'get_user_trips_notifications_state.dart';

class GetUserTripsNotificationsCubit
    extends Cubit<GetUserTripsNotificationsState> {
  final GetAllUserTripsUseCase getAllUserTripsUseCase;

  GetUserTripsNotificationsCubit({
    required this.getAllUserTripsUseCase,
  }) : super(GetUserTripsNotificationsInitial());
  List<UserTripEntity> userTrips = [];
  int page = 1;

  Future<void> getUserTripsNotifications() async {
    emit(GetUserTripsNotificationsLoading());
    pr('getUserTripsNotifications is called');
    pr('pages: $page');
    pr('notifications: $userTrips');
    final response = await getAllUserTripsUseCase.call(const NoParams());
    response.fold(
      (Failure failure) {
        emit(GetUserTripsNotificationsFailed(Labels.errorHappened));
      },
      (data) {
        userTrips.addAll(data);
        emit(GetUserTripsNotificationsSuccess(data));
      },
    );
  }
}
