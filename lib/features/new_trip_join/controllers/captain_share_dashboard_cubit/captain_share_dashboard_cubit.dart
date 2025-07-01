import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/settings_dashboard_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_settings_dashboard_usecase.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/accept_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/get_driver_available_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/get_driver_running_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/listen_to_new_route_driver_use_case.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

part 'captain_share_dashboard_state.dart';

class CaptainShareDashboardCubit extends Cubit<CaptainShareDashboardState> {
  final GetSettingsDashboardUsecase getSettingsDashboardUsecase;
  final GetDriverAvailableBookingsUseCase getDriverAvailableBookingsUseCase;
  final GetDriverRunningRouteUseCase getDriverRunningRouteUseCase;
  final ListenToNewRouteDriverUseCase listenToNewRouteDriverUseCase;
  final AcceptRouteUseCase acceptRouteUseCase;

  CaptainShareDashboardCubit(this.getSettingsDashboardUsecase,this.getDriverRunningRouteUseCase,this.acceptRouteUseCase,this.getDriverAvailableBookingsUseCase,this.listenToNewRouteDriverUseCase)
      : super(const CaptainShareDashboardState());


  loadInitData(BuildContext context){
    listenToNewRoute(context);
    loadInitialAvailableData(context);
  }


  void listenToNewRoute(BuildContext context) {
    CliLogger.info('listenToNewDriverRoute');
    // TripsResponseEntity
    listenToNewRouteDriverUseCase((route) {
        if(state.tapIndex==0){
          availableBookings.insert(0, route);
          showSuccessMessage(context, context.isArabic?'تم استقبال رحلة جديدة':'New route accepted');
        }else{
          changeTapIndex(0,context);
          loadInitialAvailableData(context);
          showSuccessMessage(context, context.isArabic?'تم استقبال رحلة جديدة':'New route accepted');
        }
        emit(state.copyWith(status: CaptainShareDashboardStates.success));
    });
  }


  Future<void> getSettings(BuildContext context) async {
    log("getSettingsgetSettings");
    final Either<Failure, SettingsDashboardEntityResponse> result =
    await getSettingsDashboardUsecase(const NoParams());
    result.fold(
          (failure) {
        log("getSettingsError${getFailureMessage(failure, context)}");

        emit(state.copyWith(status: CaptainShareDashboardStates.error, failure: failure));
      },
          (settings) {
        log("Suzccess $settings");
        String captain = '62c8ba9f8e28a58a3edf57eb';
        String lady = '62ea012a69ea29c91dfc3917';
        log("settings.data.categoryIds.any((e)=>e.id==captain||e.id==lady) ${(settings.data.categoryIds.any((e)=>e.id==captain||e.id==lady))}");
        log("settings.data.isReady==true ${(settings.data.isReady==true&&(settings.data.categoryIds.any((e)=>e.id==captain||e.id==lady)))}");
        bool isCaptain = (settings.data.isReady==true&&settings.data.categoryIds.any((e)=>e.id==captain||e.id==lady));
        emit(state.copyWith(
            status: CaptainShareDashboardStates.success,setting: settings,isCaptain:isCaptain));
      },
    );
  }

  changeTapIndex(int index,BuildContext context){
    if(index==0)loadInitialAvailableData(context);
    emit(state.copyWith(tapIndex: index,status: CaptainShareDashboardStates.success));
  }



  List<MyBookingEntity> availableBookings = [];
  MyBookingEntity? runningRoute;
  bool isLoadingMoreAvailable = false;
  bool isLoadingAvailableBookings = false;
  bool hasMoreAvailableData = true;
  int currentAvailablePage = 1;
  int pageSize = 10;

  void loadInitialAvailableData(BuildContext context) async {
    isLoadingAvailableBookings=true;
    emit(state.copyWith(status: CaptainShareDashboardStates.loading));
    print("object");
    availableBookings.clear();
    currentAvailablePage = 1;
    hasMoreAvailableData = true;
    isLoadingMoreAvailable = false;
    await getAvailableBookings(context);
    isLoadingAvailableBookings=false;
    emit(state.copyWith(status: CaptainShareDashboardStates.success));
  }

  Future<void> getAvailableBookings(BuildContext context) async {
    if (!hasMoreAvailableData || isLoadingMoreAvailable) return;

    emit(state.copyWith(status: CaptainShareDashboardStates.loading));
    isLoadingMoreAvailable = true;

    final response = await getDriverAvailableBookingsUseCase(
      PaginationParams(
          limit: 10,page: currentAvailablePage),
    );

    response.fold(
          (failure) {
        print("objectFailure ${getFailureMessage(failure, context)}");
        emit(
            state.copyWith(failure: failure, status: CaptainShareDashboardStates.error));
      },
          (data) {
        print("objectData ${data.length}");
        availableBookings.addAll(data);
        print("objectData ${availableBookings.length}");

        if (data.length < pageSize) {
          hasMoreAvailableData = false;
        } else {
          currentAvailablePage++;
        }

        isLoadingMoreAvailable = false;
        emit(state.copyWith(status: CaptainShareDashboardStates.success));
      },
    );
  }


  Future<void> getRunningRoute(BuildContext context) async {

    emit(state.copyWith(status: CaptainShareDashboardStates.loading));

    final response = await getDriverRunningRouteUseCase(NoParams());

    response.fold(
          (failure) {
        print("objectFailure ${getFailureMessage(failure, context)}");
        emit(
            state.copyWith(failure: failure, status: CaptainShareDashboardStates.error));
      },
          (data) {
        runningRoute = data;
        emit(state.copyWith(status: CaptainShareDashboardStates.success,runningRoute:data));
      },
    );
  }



  Future<void> acceptRoute(
      {required String id, required BuildContext context}) async {
    showLoadingDialog(context);
    final response = await acceptRouteUseCase(id);
    response.fold((l) {
      context.pop();
      String errorName = getFailureName(l, context);
      // errorName == 'DebtError'
      //     ? showDebtDialog(context, subCategoryId)
      //     : errorName == 'SubscribeError'
      //     ? showSubscribeDialog(context, subCategoryId)
      //     : showErrorMessage(context, getFailureMessage(l, context));
      showSuccessMessage(context,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareDashboardStates.error));
    }, (data) {
      context.pop();
        availableBookings.removeWhere((e)=> e.id==id);
      showSuccessMessage(context, context.isArabic?'تم قبول الحجز بنجاح':'Booking Accepted Successfully');
      emit(state.copyWith(status: CaptainShareDashboardStates.success));
    });
  }
}
