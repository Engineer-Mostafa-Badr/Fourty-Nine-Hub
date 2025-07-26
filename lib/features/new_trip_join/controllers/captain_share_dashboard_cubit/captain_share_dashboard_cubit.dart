import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/route_client_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/settings_dashboard_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_settings_dashboard_usecase.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/accept_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/arrived_to_client_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/client_not_shown_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/drop_client_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/get_driver_available_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/get_driver_past_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/get_driver_running_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/listen_to_new_route_driver_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/pick_client_use_case.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

part 'captain_share_dashboard_state.dart';

class CaptainShareDashboardCubit extends Cubit<CaptainShareDashboardState> {
  final GetSettingsDashboardUsecase getSettingsDashboardUsecase;
  final GetDriverAvailableBookingsUseCase getDriverAvailableBookingsUseCase;
  final GetDriverRunningRouteUseCase getDriverRunningRouteUseCase;
  final ListenToNewRouteDriverUseCase listenToNewRouteDriverUseCase;
  final AcceptRouteUseCase acceptRouteUseCase;
  final PickClientUseCase pickClientUseCase;
  final DropClientUseCase dropClientUseCase;
  final CaptainArrivedToClientUseCase arrivedToClientUseCase;
  final ClientNotShownUseCase clientNotShownUseCase;
  final GetDriverPastBookingsUseCase getDriverPastBookingsUseCase;

  CaptainShareDashboardCubit(this.getSettingsDashboardUsecase,this.arrivedToClientUseCase,this.clientNotShownUseCase,this.dropClientUseCase,this.getDriverPastBookingsUseCase,this.pickClientUseCase,this.getDriverRunningRouteUseCase,this.acceptRouteUseCase,this.getDriverAvailableBookingsUseCase,this.listenToNewRouteDriverUseCase)
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

        emit(state.copyWith(status: CaptainShareDashboardStates.error, failure: failure,isCaptain:false));
      },
          (settings) {
        bool isCaptain = (settings.data.isReady==true&&settings.data.isCaptainShareEnabled==true);
        emit(state.copyWith(
            status: CaptainShareDashboardStates.success,setting: settings,isCaptain:isCaptain));
      },
    );
  }

  changeTapIndex(int index,BuildContext context){
    MyBookingEntity? runningRoute = state.runningRoute;
    if(runningRoute!=null){
      runningRoute.status=='';
      emit(state.copyWith(runningRoute: runningRoute));
    }
    if(index==0)loadInitialAvailableData(context);
    if(index==1)getRunningRoute(context);
    if(index==2)loadInitialPastData(context);
    emit(state.copyWith(tapIndex: index,status: CaptainShareDashboardStates.success));
  }


  BookingClientEntity? getCurrentClient(List<BookingClientEntity> clients){
    clients.sort((a, b) => (a.pickupDistanceFromStart??0).compareTo(b.pickupDistanceFromStart??0));
    BookingClientEntity? currentClient;
      if(clients.isNotEmpty&&(clients[0].status==RouteClientStatus.acceptedByDriver.name||clients[0].status==RouteClientStatus.driverNoShowPassenger.name)){
        currentClient= clients[0];
      }else if(clients.length>1&&(clients[1].status==RouteClientStatus.acceptedByDriver.name||clients[1].status==RouteClientStatus.driverNoShowPassenger.name)){
        currentClient= clients[1];
      } else if(clients.length>=2&&(clients[2].status==RouteClientStatus.acceptedByDriver.name||clients[2].status==RouteClientStatus.driverNoShowPassenger.name)){
        currentClient= clients[2];
      }
    return currentClient;
  }

  int getCurrentClientIndex(List<BookingClientEntity> clients){
    clients.sort((a, b) => (a.pickupDistanceFromStart??0).compareTo(b.pickupDistanceFromStart??0));
    int index=0;
    if(clients.isNotEmpty&&(clients[0].status==RouteClientStatus.acceptedByDriver.name||clients[0].status==RouteClientStatus.driverNoShowPassenger.name)){
      index=0;
    }else if(clients.length>1&&(clients[1].status==RouteClientStatus.acceptedByDriver.name||clients[1].status==RouteClientStatus.driverNoShowPassenger.name)){
      index=1;
    } else if(clients.length>=2&&(clients[2].status==RouteClientStatus.acceptedByDriver.name||clients[2].status==RouteClientStatus.driverNoShowPassenger.name)){
      index=2;
    }
    return index;
  }


  List<MyBookingEntity> availableBookings = [];
  // MyBookingEntity? runningRoute;
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


  List<MyBookingEntity> pastBookings = [];
  bool isLoadingMorePast = false;
  bool isLoadingPastBookings = false;
  bool hasMorePastData = true;
  int currentPastPage = 1;

  void loadInitialPastData(BuildContext context) async {
    isLoadingPastBookings=true;
    emit(state.copyWith(status: CaptainShareDashboardStates.loading));
    print("object");
    pastBookings.clear();
    currentPastPage = 1;
    hasMorePastData = true;
    isLoadingMorePast = false;
    await getPastBookings(context);
    isLoadingPastBookings=false;
    emit(state.copyWith(status: CaptainShareDashboardStates.success));
  }

  Future<void> getPastBookings(BuildContext context) async {
    if (!hasMorePastData || isLoadingMorePast) return;

    emit(state.copyWith(status: CaptainShareDashboardStates.loading));
    isLoadingMorePast = true;

    final response = await getDriverPastBookingsUseCase(
      PaginationParams(
          limit: 10,page: currentPastPage),
    );

    response.fold(
          (failure) {
        print("objectFailure ${getFailureMessage(failure, context)}");
        emit(
            state.copyWith(failure: failure, status: CaptainShareDashboardStates.error));
      },
          (data) {
        print("objectData ${data.length}");
        pastBookings.addAll(data);
        print("objectData ${pastBookings.length}");

        if (data.length < pageSize) {
          hasMorePastData = false;
        } else {
          currentPastPage++;
        }

        isLoadingMorePast = false;
        emit(state.copyWith(status: CaptainShareDashboardStates.success));
      },
    );
  }

  bool isLoadingRunningTrip = false;
  bool isGoingToClient = false;
  bool showArrived = false;
  bool showClientNotShown = false;
  bool showEndTrip = false;

  Future<void> getRunningRoute(BuildContext context) async {
    isLoadingRunningTrip = true;
    MyBookingEntity? runningRoute = state.runningRoute;
    runningRoute?.status = '';
    emit(state.copyWith(status: CaptainShareDashboardStates.loading,runningRoute: runningRoute));

    final response = await getDriverRunningRouteUseCase(NoParams());

    response.fold(
          (failure) {
        print("objectFailure ${getFailureMessage(failure, context)}");
        isLoadingRunningTrip = false;
        emit(
            state.copyWith(failure: failure, status: CaptainShareDashboardStates.error));
      },
          (data) {
            isLoadingRunningTrip = false;
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
      showSuccessMessage(context,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareDashboardStates.error));
    }, (data) {
      context.pop();
        availableBookings.removeWhere((e)=> e.id==id);
      showSuccessMessage(context, context.isArabic?'تم قبول الحجز بنجاح':'Booking Accepted Successfully');
      emit(state.copyWith(status: CaptainShareDashboardStates.success));
    });
  }

  Future<void> startClientRoute(
      {required String id,required String passengerId,required String otp, required BuildContext context}) async {
    showLoadingDialog(context);
    final response = await pickClientUseCase(PickClientParams(routeId: id,passengerId: passengerId,otp: otp));
    response.fold((l) {
      context.pop();
      String errorName = getFailureName(l, context);
      showSuccessMessage(context,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareDashboardStates.error));
    }, (data) {
      context.pop();
      MyBookingEntity? runningRoute = state.runningRoute;
      runningRoute?.clients?.firstWhereOrNull((e)=>e.id==passengerId)?.status=RouteClientStatus.pickedUp.name;

      showSuccessMessage(context, context.isArabic?'تم بدء الرحله بنجاح':'Trip Started Successfully');
      emit(state.copyWith(status: CaptainShareDashboardStates.success,runningRoute: runningRoute));
    });
  }

  Future<void> goToClient(
      {required String routeId,required String passengerId,required String otp, required BuildContext context}) async {
    showLoadingDialog(context);
    final response = await pickClientUseCase(PickClientParams(
        routeId:routeId,
        passengerId:passengerId,
        otp:otp
    ));
    response.fold((l) {
      context.pop();
      String errorName = getFailureMessage(l, context);
      showErrorMessage(context,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareDashboardStates.error));
    }, (data) {
      context.pop();
      showSuccessMessage(context, context.isArabic?'تم التقاط الراكب بنجاح':'Client Picked Successfully');
      emit(state.copyWith(status: CaptainShareDashboardStates.success));
    });
  }

  Future<void> onDriverArrivedToClient(
      {required String routeId,required String passengerId}) async {
    final currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    showLoadingDialog(currentContext);
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      currentContext.pop();
      showErrorMessage(currentContext, currentContext.isArabic?'يرجى الموافقة على إذن الموقع':'Please Allow Location Permission');
      return;
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final response = await arrivedToClientUseCase(ClientNotShownParams(
        routeId:routeId,
        passengerId:passengerId,
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude
    ));
    response.fold((l) {
      currentContext.pop();
      String errorName = getFailureMessage(l, currentContext);
      showErrorMessage(currentContext,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareDashboardStates.error));
    }, (data) {
      currentContext.pop();
      MyBookingEntity? runningRoute = state.runningRoute;
      runningRoute?.clients?.firstWhereOrNull((e)=>e.id==passengerId)?.driverArrivalTime=data;
      showSuccessMessage(currentContext, currentContext.isArabic?'تم الوصول للراكب بنجاح':'Arrived Successfully');
      emit(state.copyWith(status: CaptainShareDashboardStates.success));
    });
  }

  Future<void> onClientNotShown(
      {required String routeId,required String passengerId}) async {
    final currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    showLoadingDialog(currentContext);
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      currentContext.pop();
      showErrorMessage(currentContext, currentContext.isArabic?'يرجى الموافقة على إذن الموقع':'Please Allow Location Permission');
      return;
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final response = await clientNotShownUseCase(ClientNotShownParams(
        routeId:routeId,
        passengerId:passengerId,
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude
    ));
    response.fold((l) {
      currentContext.pop();
      String errorName = getFailureMessage(l, currentContext);
      showErrorMessage(currentContext,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareDashboardStates.error));
    }, (data) {
      currentContext.pop();
      MyBookingEntity? runningRoute = state.runningRoute;
      runningRoute?.clients?.firstWhereOrNull((e)=>e.id==passengerId)?.driverWaitingTime=data;
      emit(state.copyWith(status: CaptainShareDashboardStates.success,runningRoute:runningRoute));
    });
  }

  Future<Position?> getCurrentPosLatLong() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      debugPrint("Location services are disabled.");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      debugPrint("Location permissions are denied.");
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint("Error getting location: $e");
      return null;
    }
  }

  Future<void> dropOffClient(
      {required String routeId,required String passengerId,required String otp, required BuildContext context}) async {
    showLoadingDialog(context);
    Position? currentPosition = await getCurrentPosLatLong();

    if(currentPosition==null){
      context.pop();
      showErrorMessage(context, context.isArabic?'يرجى الموافقة على إذن الموقع':'Please Allow Location Permission');
      emit(state.copyWith(status: CaptainShareDashboardStates.success));
      return;
    }

    final response = await dropClientUseCase(DropClientParams(
        routeId:routeId,
        passengerId:passengerId,
        longitude: currentPosition.longitude,
        latitude: currentPosition.latitude
    ));
    response.fold((l) {
      context.pop();
      String errorName = getFailureMessage(l, context);
      showErrorMessage(context,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareDashboardStates.error));
    }, (data) {
      context.pop();
      showSuccessMessage(context, context.isArabic?'تم توصيل الراكب بنجاح':'Client Dropped Off Successfully');
      emit(state.copyWith(status: CaptainShareDashboardStates.success));
    });
  }
}
