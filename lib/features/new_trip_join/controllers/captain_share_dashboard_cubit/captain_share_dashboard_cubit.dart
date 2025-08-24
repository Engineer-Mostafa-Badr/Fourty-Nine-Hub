import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/route_client_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/settings_dashboard_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_running_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_settings_dashboard_usecase.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/accept_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/arrived_to_client_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/client_not_shown_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/complete_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/drop_client_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/get_driver_available_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/get_driver_past_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/get_driver_running_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/listen_to_client_coming_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/listen_to_new_route_driver_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/driver/pick_client_use_case.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

part 'captain_share_dashboard_state.dart';

class CaptainShareDashboardCubit extends Cubit<CaptainShareDashboardState> {
  final GetSettingsDashboardUsecase getSettingsDashboardUsecase;
  final GetRunningTripUseCase getRunningTripUseCase;
  final GetDriverAvailableBookingsUseCase getDriverAvailableBookingsUseCase;
  final GetDriverRunningRouteUseCase getDriverRunningRouteUseCase;
  final ListenToNewRouteDriverUseCase listenToNewRouteDriverUseCase;
  final ListenToClientComingUseCase listenToClientComingUseCase;
  final AcceptRouteUseCase acceptRouteUseCase;
  final CompleteRouteUseCase completeRouteUseCase;
  final PickClientUseCase pickClientUseCase;
  final DropClientUseCase dropClientUseCase;
  final CaptainArrivedToClientUseCase arrivedToClientUseCase;
  final ClientNotShownUseCase clientNotShownUseCase;
  final GetDriverPastBookingsUseCase getDriverPastBookingsUseCase;

  CaptainShareDashboardCubit(this.getSettingsDashboardUsecase,this.listenToClientComingUseCase,this.completeRouteUseCase,this.getRunningTripUseCase,this.arrivedToClientUseCase,this.clientNotShownUseCase,this.dropClientUseCase,this.getDriverPastBookingsUseCase,this.pickClientUseCase,this.getDriverRunningRouteUseCase,this.acceptRouteUseCase,this.getDriverAvailableBookingsUseCase,this.listenToNewRouteDriverUseCase)
      : super(const CaptainShareDashboardState());


  loadInitData(BuildContext context){
    listenToNewRoute(context);
    listenToComingClient(context);
    loadInitialAvailableData(context);
  }


  void listenToNewRoute(BuildContext context) {
    CliLogger.info('listenToNewDriverRoute');
    // Store the context safely by getting it when needed
    listenToNewRouteDriverUseCase((route) {
        // Check if cubit is still active before proceeding
        if (isClosed) return;
        
        // Get current context safely
        final currentContext = AppPages.router.configuration.navigatorKey.currentContext;
        if (currentContext == null) {
          CliLogger.info('Context is null, widget may be disposed');
          return;
        }
        
        // Check if the context is still mounted
        if (!currentContext.mounted) {
          CliLogger.info('Context is not mounted, widget may be disposed');
          return;
        }
        
        if(state.tapIndex==0){
          availableBookings.insert(0, route);
          showSuccessMessage(currentContext, currentContext.isArabic?'تم استقبال رحلة جديدة':'New route accepted');
        }else{
          changeTapIndex(0,currentContext);
          loadInitialAvailableData(currentContext);
          showSuccessMessage(currentContext, currentContext.isArabic?'تم استقبال رحلة جديدة':'New route accepted');
        }
        emit(state.copyWith(status: CaptainShareDashboardStates.success));
    });
  }
  void listenToComingClient(BuildContext context) {
    CliLogger.info('listenToComingClient');
    // Store the context safely by getting it when needed
    listenToClientComingUseCase((route) {
      var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
      showSuccessMessage(currentContext, currentContext.isArabic?'العميل في طريقه اليك':'Client on the way');

      emit(state.copyWith(status: CaptainShareDashboardStates.success));
    });
  }

  initData() async {
    emit(state.copyWith(status: CaptainShareDashboardStates.loading));
    final currentContext = AppPages.router.configuration.navigatorKey.currentContext;
    if (currentContext == null) {
      CliLogger.info('Context is null during initData');
      return;
    }
    // showLoadingDialog(currentContext);
    await Future.wait([
      getActiveTrip(currentContext),
      getSettings(currentContext),
    ]);
    if (!isClosed) {
      emit(state.copyWith(status: CaptainShareDashboardStates.success));
    }
  }

  RunningTripEntity? activeTrip;
  Future<void> getActiveTrip(BuildContext context) async {
    activeTrip = null;

    final Either<Failure, RunningTripEntity> result =
    await getRunningTripUseCase(const NoParams());

    if (isClosed) return;
    result.fold(
          (failure) {
            // context.pop();
        emit(state.copyWith(
            status: CaptainShareDashboardStates.error,
            failure: failure));
      },
          (trip) {
            // context.pop();
        activeTrip =trip;
        // emit(state.copyWith(
        //     status: CaptainShareDashboardStates.success,));
      },
    );
  }


  Future<void> getSettings(BuildContext context) async {
    // showLoadingDialog(context);
    log("getSettingsgetSettings");
    final Either<Failure, SettingsDashboardEntityResponse> result =
    await getSettingsDashboardUsecase(const NoParams());
    result.fold(
          (failure) {
            // context.pop();
        log("getSettingsError${getFailureMessage(failure, context)}");

        emit(state.copyWith(status: CaptainShareDashboardStates.error, failure: failure,isCaptain:false));
      },
          (settings) {
        bool isCaptain = settings.data.isCaptainShareEnabled==true;
        getActiveTrip(context);
        emit(state.copyWith(
            setting: settings,isCaptain:isCaptain));
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
    if(clients.isNotEmpty){
      if(clients[0].status=='pickedUp'){
        return clients[0];
      }else if(clients.length>1&&clients[1].status=='pickedUp'){
        return clients[1];
      }else if(clients.length>=2&&clients[2].status=='pickedUp'){
        return clients[2];
      }
    }
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
  List<BookingClientEntity> clients = [];

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
            clients = List.from(data.clients ?? []);
            clients.sort((a, b) => (a.pickupDistanceFromStart??0).compareTo(b.pickupDistanceFromStart??0));
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

  Future<void> onCompleteRoute(
      {required String id, required BuildContext context}) async {
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    showLoadingDialog(currentContext);
    final response = await completeRouteUseCase(id);
    response.fold((l) {
      currentContext.pop();
      String errorName = getFailureName(l, currentContext);
      showSuccessMessage(currentContext,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareDashboardStates.error));
    }, (data) {
      currentContext.pop();
      showSuccessMessage(currentContext,currentContext.isArabic?'تم انهاء الرحله بنجاح':'Trip Completed Successfully');
      changeTapIndex(0, currentContext);
      emit(state.copyWith(status: CaptainShareDashboardStates.success));
    });
  }

  Future<void> startClientRoute(
      {required String id,required String passengerId,required String otp, required BuildContext context,required int index}) async {
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
      getRunningRoute(context);
      showSuccessMessage(context, context.isArabic?'تم بدء الرحله بنجاح':'Trip Started Successfully');
      emit(state.copyWith(status: CaptainShareDashboardStates.success,runningRoute: runningRoute));
    });
  }

  Future<void> goToClient(
      {required String routeId,required String passengerId,required String otp,required int index, required BuildContext context}) async {
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    showLoadingDialog(currentContext);
    final response = await pickClientUseCase(PickClientParams(
        routeId:routeId,
        passengerId:passengerId,
        otp:otp
    ));
    response.fold((l) {
      currentContext.pop();
      String errorName = getFailureMessage(l, currentContext);
      showErrorMessage(currentContext,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareDashboardStates.error));
    }, (data) {
      currentContext.pop();
      if(otp.isEmpty)clients.firstWhere((c) => c.id == passengerId).status = RouteClientStatus.cancelled.name;
      if(otp.isNotEmpty)clients.firstWhere((c) => c.id == passengerId).status = RouteClientStatus.pickedUp.name;
      // getRunningRoute(currentContext);
      for (int i = 0; i < clients.length; i++) {
        if (clients[i].status == RouteClientStatus.pickedUp.name) {
         clients[i].polyLine = [];
        }
      }
      List<List<double>> parsedPolyline = [];
      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> decoded = polylinePoints.decodePolyline(
        data.polyline,
      );
      parsedPolyline = decoded.map((e) => [e.latitude, e.longitude]).toList();
      if(index==0){
        clients[1].polyLine = parsedPolyline;
        clients[0].pickupTime = data.currentPickupTime;
        clients[1].expectedArrivalDuration = data.expectedArrivalDuration;

      }else if(index==1){
        clients[2].polyLine = parsedPolyline;
        clients[1].pickupTime = data.currentPickupTime;
        clients[2].expectedArrivalDuration = data.expectedArrivalDuration;
      }else{
        clients[3].polyLine = parsedPolyline;
        clients[2].pickupTime = data.currentPickupTime;
        state.runningRoute?.startTime = data.currentPickupTime;
        state.runningRoute?.expectedArrivalDuration = data.expectedArrivalDuration;
      }
      if(otp.isNotEmpty)showSuccessMessage(currentContext, currentContext.isArabic?'تم التقاط الراكب بنجاح':'Client Picked Successfully');
      if(otp.isEmpty)showSuccessMessage(currentContext, currentContext.isArabic?'تم الغاء الرحله لهذا الراكب بنجاح':'Trip Cancelled For This Client Successfully');
      emit(state.copyWith(status: CaptainShareDashboardStates.success));
    });
  }

  Future<void> onDriverArrivedToClient(
      {required String routeId,required String passengerId}) async {
    final currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    final index = clients.indexWhere((c) => c.id == passengerId);
    BookingClientEntity? client = clients.firstWhereOrNull((c) => c.id == passengerId);
    if (index == -1) return;

    if (index == 0&&client?.status!='acceptedByDriver') {
      return; // First client, no restrictions
    } else if (index == 1) {
      if(clients[0].status == 'acceptedByDriver') {
        showErrorMessage(currentContext, currentContext.isArabic?'عليك التقاط العميل الاول اولا للتمكن من التقاط هذا العميل':'You must pick the first client first to be able to pick this client');
        return;
      }
    } else if (index == 2) {
      if(clients[0].status == 'acceptedByDriver'||clients[1].status == 'acceptedByDriver') {
        showErrorMessage(currentContext, currentContext.isArabic?'عليك التقاط العميل ${clients[0].status == 'acceptedByDriver'?'الاول':clients[1].status == 'acceptedByDriver'?"الثاني":''} اولا للتمكن من التقاط هذا العميل':'You must pick the ${clients[0].status == 'acceptedByDriver'?'first':clients[1].status == 'acceptedByDriver'?"second":''} client first to be able to pick this client');
        return;
      }
    }
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
      {required String routeId,required String passengerId, required BuildContext context}) async {
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    if(clients.any((c)=>c.status=='acceptedByDriver'||c.status=='cancelled')){
      showErrorMessage(currentContext, currentContext.isArabic?"برجاء التقاط جميع الركاب اولا":"Please pick all clients first");
      return;
    }
    showLoadingDialog(currentContext);
    Position? currentPosition = await getCurrentPosLatLong();

    if(currentPosition==null){
      currentContext.pop();
      showErrorMessage(currentContext, currentContext.isArabic?'يرجى الموافقة على إذن الموقع':'Please Allow Location Permission');
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
      currentContext.pop();
      String errorName = getFailureMessage(l, currentContext);
      showErrorMessage(currentContext,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareDashboardStates.error));
    }, (data) {
      currentContext.pop();
      clients.firstWhere((c) => c.id == passengerId).status = RouteClientStatus.completed.name;
      // getRunningRoute(currentContext);
      showSuccessMessage(currentContext, currentContext.isArabic?'تم توصيل الراكب بنجاح':'Client Dropped Off Successfully');
      emit(state.copyWith(status: CaptainShareDashboardStates.success));
    });
  }

  @override
  Future<void> close() {
    // Clean up socket listeners when cubit is disposed
    try {
      // Remove the socket listener to prevent accessing deactivated context
      SharedWebSocket.socket?.off('captain-share:new-available-trip');
      CliLogger.info('CaptainShareDashboardCubit disposed and socket listener removed');
    } catch (e) {
      CliLogger.info('Error during cubit disposal: $e');
    }
    return super.close();
  }
}