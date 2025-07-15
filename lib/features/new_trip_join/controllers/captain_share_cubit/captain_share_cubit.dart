import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/support_details_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_ride_screen.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/data/models/my_booking_model.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/create_price_per_seat_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/running_route_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/cancel_my_booking_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_available_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_expired_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_my_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_route_details_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_running_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_running_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/join_to_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_accept_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_cancel_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_driver_on_way_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_join_available_routes_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_leave_available_routes_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_new_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_update_route_use_case.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

part 'captain_share_state.dart';

class CaptainShareCubit extends Cubit<CaptainShareState> {
  final CreatePricePerSeatUseCase createPricePerSeatUseCase;
  final GetMyBookingsUseCase getMyBookingsUseCase;
  final GetAvailableBookingsUseCase getAvailableBookingsUseCase;
  final GetRunningBookingsUseCase getRunningBookingsUseCase;
  final GetExpiredBookingsUseCase getExpiredBookingsUseCase;
  final CancelMyBookingUseCase cancelMyBookingUseCase;
  final CreateRouteUseCase createRouteUseCase;
  final ListenToCancelRouteUseCase listenToCancelRouteUseCase;
  final ListenToJoinAvailableRoutesUseCase listenToJoinAvailableRoutesUseCase;
  final ListenToLeaveAvailableRoutesUseCase listenToLeaveAvailableRoutesUseCase;
  final ListenToNewRouteUseCase listenToNewRouteUseCase;
  final JoinToRouteUseCase joinToRouteUseCase;
  final GetRouteDetailsUseCase getRouteDetailsUseCase;
  final ListenToUpdateRouteUseCase listenToUpdateRouteUseCase;
  final GetSupportDetailsUseCase getSupportDetailsUseCase;
  final ListenToDriverOnWayUseCase listenToDriverOnWayUseCase;
  final ListenToAcceptRouteUseCase listenToAcceptRouteUseCase;
  final GetRunningRouteUseCase getRunningRouteUseCase;
  CaptainShareCubit(this.createPricePerSeatUseCase,this.listenToDriverOnWayUseCase,this.getRunningRouteUseCase,this.listenToAcceptRouteUseCase,this.getRouteDetailsUseCase,this.listenToUpdateRouteUseCase,this.listenToCancelRouteUseCase,this.joinToRouteUseCase,this.listenToJoinAvailableRoutesUseCase,this.listenToLeaveAvailableRoutesUseCase,this.listenToNewRouteUseCase,this.createRouteUseCase,this.getRunningBookingsUseCase,this.getExpiredBookingsUseCase, this.getMyBookingsUseCase, this.cancelMyBookingUseCase, this.getAvailableBookingsUseCase, this.getSupportDetailsUseCase)
      : super(const CaptainShareState());

  TextEditingController supportDescriptionController = TextEditingController();
  TextEditingController supportPhoneController = TextEditingController();


  void initData(BuildContext context)async{
    loadInitialAvailableData(context);
    await listenToJoinRoute();
    listenToNewRoute(context);
    listenToUpdateRoute(context);
    listenToCancelRoute(context);
    listenToAcceptedRoute();
    listenToAcceptedRoute();
  }

  Future<void> fetchUserLocation() async {
    emit(state.copyWith(status: CaptainShareStates.loading));

    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      String address = placemarks.isNotEmpty
          ? "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}"
          : "Unknown current Location";

      GetLocationFromAddressEntity currentLocation =
      GetLocationFromAddressEntity(
        lat: position.latitude,
        lng: position.longitude,
        address: address,
      );

      emit(state.copyWith(
          status: CaptainShareStates.success, currentLocation: currentLocation));
    } catch (e) {
      log('_fetchUserLocation ${e.toString()}');
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    print(" permanently denied$permission");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Position(
        longitude: 31.235457277186548,
        latitude: 30.047873322617807,
        timestamp: DateTime.now(),
        accuracy: 0.2,
        altitude: 0.5,
        altitudeAccuracy: 0.6,
        heading: 0.2,
        headingAccuracy: 0.1,
        speed: 20,
        speedAccuracy: 10,
      );
    }
    if (permission == LocationPermission.denied) {
      print("objectLocation permissions are permanently denied");
      // permission = await Geolocator.requestPermission();
      // if (permission == LocationPermission.deniedForever||permission == LocationPermission.whileInUse) {
      print("objectLocation permissions are permanently denied");
      return Position(
        longitude: 31.235457277186548,
        latitude: 30.047873322617807,
        timestamp: DateTime.now(),
        accuracy: 0.2,
        altitude: 0.5,
        altitudeAccuracy: 0.6,
        heading: 0.2,
        headingAccuracy: 0.1,
        speed: 20,
        speedAccuracy: 10,
      );
    }
    // }
    return await Geolocator.getCurrentPosition();
  }

  void listenToCancelRoute(BuildContext context) {
    CliLogger.info('listenToCancelRoute');
    // TripsResponseEntity
    listenToCancelRouteUseCase((routeId) {
      if(state.tapIndex==0){
        print("routeId.routeId ${routeId.routeId}");
        availableBookings.removeWhere((element) => element.id==routeId.routeId);
        showSuccessMessage(context, context.isArabic?'تم الغاء الرحله بواسطة ناشئ الرحلة':'Route canceled by creator');
      }
      if(state.tapIndex==1){
        myBookings.removeWhere((element) => element.id==routeId.routeId);
        showSuccessMessage(context, context.isArabic?'تم الغاء الرحله بواسطة ناشئ الرحلة':'Route canceled by creator');
      }
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }

  listenToJoinRoute() {
    CliLogger.info('listenToJoinRoute');
    listenToJoinAvailableRoutesUseCase((isJoined) {
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }

  listenToAcceptedRoute() {
    CliLogger.info('listenToAcceptRoute');
    listenToAcceptRouteUseCase((data) {
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }

  listenToDriverOnTheWay() {
    CliLogger.info('listenToDriverOnTheWay');
    listenToDriverOnWayUseCase((data) {
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }

  void listenToLeaveRoute() {
    CliLogger.info('listenToLeaveRoute');
    listenToLeaveAvailableRoutesUseCase((routeId) {
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }

  onNavigateToCreateRoute(BuildContext context) async {
    await context.push(Routes.newRouteScreen);
    if(state.tapIndex==0){
      loadInitialAvailableData(context);
    }else{
      onChangeTapIndex(0, context);
      loadInitialAvailableData(context);
    }
  }

  void listenToNewRoute(BuildContext context) {
    CliLogger.info('listenToNewRoute');
    listenToNewRouteUseCase((route) {
      String userId = UserCubit.to.state.data?.id??'';
      if(userId==route.creatorId){}else{
        if(state.tapIndex==0){
          availableBookings.insert(0, route);
          showSuccessMessage(context, context.isArabic?'تم استقبال رحلة جديدة':'New route accepted');
        }else{
          onChangeTapIndex(0,context);
          loadInitialAvailableData(context);
          showSuccessMessage(context, context.isArabic?'تم استقبال رحلة جديدة':'New route accepted');
        }
        emit(state.copyWith(status: CaptainShareStates.success));
      }
    });
  }

  void listenToUpdateRoute(BuildContext context) {
    CliLogger.info('listenToNewRoute');
    listenToUpdateRouteUseCase((route) {
        if(state.tapIndex==0){
          availableBookings.removeWhere((e)=>e.id==route.id);
          availableBookings.insert(0, route);
        }else if(state.tapIndex==1){
          myBookings.removeWhere((e)=>e.id==route.id);
          myBookings.insert(0, route);
        }
        emit(state.copyWith(status: CaptainShareStates.success));
    });
  }


  onChangeTapIndex(int index,BuildContext context){
    RunningRouteEntity? runningRoute = state.runningRoute;
    runningRoute?.yourStatus='';
    emit(state.copyWith(status: CaptainShareStates.success,runningRoute: runningRoute));

    if(index==0) listenToJoinRoute();
    if(index!=0) listenToLeaveRoute();
    if(index == 2) getRunningRoute(context);
    print("state.tapIndex Cubit : $index");
    emit(state.copyWith(status: CaptainShareStates.success,tapIndex: index,hintText: ''));
  }
  onShowHintTap(int index,BuildContext context){
    String hintText = '';
    if(index==0) {
      if(state.hintText=='available'){
        hintText = '';
      }else{
        hintText = 'available';
      }
    }
    if(index==1) {
      if(state.hintText=='myBooking'){
        hintText = '';
      }else{
        hintText = 'myBooking';
      }
    }
    if(index==2) {
      if(state.hintText=='running'){
        hintText = '';
      }else{
        hintText = 'running';
      }
    }
    if(index==3) {
      if(state.hintText=='expired'){
        hintText = '';
      }else{
        hintText = 'expired';
      }
    }
    emit(state.copyWith(status: CaptainShareStates.success,hintText: hintText));

  }

  Future<void> cancelMyBooking(
      {required String id, required BuildContext context, required String from}) async {
    showLoadingDialog(context);
    final response = await cancelMyBookingUseCase(id);
    response.fold((l) {
      context.pop();
      String errorName = getFailureName(l, context);
      // errorName == 'DebtError'
      //     ? showDebtDialog(context, subCategoryId)
      //     : errorName == 'SubscribeError'
      //     ? showSubscribeDialog(context, subCategoryId)
      //     : showErrorMessage(context, getFailureMessage(l, context));
      showSuccessMessage(context,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareStates.error));
    }, (data) {
      context.pop();
      if(from=='available') {
        availableBookings.removeWhere((e)=> e.id==id);
      }
      if(from=='myBookings') {
        myBookings.firstWhere((e)=> e.id==id).status='cancelled';
      }
      if(from=='expiredBookings') {
        expiredBookings.firstWhere((e)=> e.id==id).status='cancelled';
      }
      if(from=='runningBookings') {
        runningBookings.firstWhere((e)=> e.id==id).status='cancelled';
      }
      showSuccessMessage(context, context.isArabic?'تم الغاء الحجز بنجاح':'Booking canceled successfully');
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }

  Future<void> joinToRoute(
      {required String id, required BuildContext context}) async {
    showLoadingDialog(context);
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final response = await joinToRouteUseCase(JoinToRouteParams(
      routeId: id,
      lat: currentPosition.latitude,
      lng: currentPosition.longitude
    ));
    response.fold((l) {
      context.pop();
      String errorName = getFailureName(l, context);
      // errorName == 'DebtError'
      //     ? showDebtDialog(context, subCategoryId)
      //     : errorName == 'SubscribeError'
      //     ? showSubscribeDialog(context, subCategoryId)
      //     : showErrorMessage(context, getFailureMessage(l, context));
      showSuccessMessage(context,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareStates.error));
    }, (data) {
      availableBookings.firstWhere((e)=>e.id==data.id).clients = data.clients;
      availableBookings.firstWhere((e)=>e.id==data.id).availableSeats = data.availableSeats;
      context.pop();
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }

  Future<void> getRouteDetails(
      {required String id, required BuildContext context}) async {
    emit(state.copyWith(status: CaptainShareStates.loading));
    final response = await getRouteDetailsUseCase(id);
    response.fold((l) {
      context.pop();
      String errorName = getFailureMessage(l, context);
      showErrorMessage(context,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareStates.error));
    }, (data) {
      emit(state.copyWith(status: CaptainShareStates.success,routeDetails:data));
    });
  }

  Future<void> getRunningRoute(BuildContext context) async {
    emit(state.copyWith(status: CaptainShareStates.loading));
    final response = await getRunningRouteUseCase(NoParams());
    response.fold((l) {
      String errorName = getFailureMessage(l, context);
      showErrorMessage(context,  errorName);
      emit(state.copyWith(failure: l, status: CaptainShareStates.error));
    }, (data) {
      emit(state.copyWith(status: CaptainShareStates.success,runningRoute:data));
    });
  }

  // setLocation(List<double>? currentLocation, List<double>? toLocation,String? currentAddress,String? toAddress){
  //   print('objecttoLocation$toLocation');
  //   emit(state.copyWith(status: CaptainShareStates.success,currentLocation:currentLocation,toLocation:toLocation,currentAddress:currentAddress,toAddress:toAddress));
  // }

  void updateFromLocation(
      {required double lat, required double lng, required String address}) {
    GetLocationFromAddressEntity currentLocation = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );

    emit(state.copyWith(
        status: CaptainShareStates.success, currentLocation: currentLocation));
  }


  void emitRefreshState() {
    emit(state.copyWith(status: CaptainShareStates.success));
  }

  updateToLocation(
      {required double lat, required double lng, required String address}) {
    GetLocationFromAddressEntity toLocation = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );
    print("toLocation.lat ${toLocation.lat}");
    print("toLocation.lat ${toLocation.lng}");
    print("toLocation.lat ${toLocation.address}");
    emit(state.copyWith(status: CaptainShareStates.success, toLocation: toLocation));
  }

  Future<void> createOffer(
      {required CreatePricePerSeatParams params, required BuildContext context}) async {
    showLoadingDialog(context);
    final response = await createPricePerSeatUseCase(params);
    response.fold((l) {
      context.pop();
      String errorName = getFailureName(l, context);
      // errorName == 'DebtError'
      //     ? showDebtDialog(context, subCategoryId)
      //     : errorName == 'SubscribeError'
      //     ? showSubscribeDialog(context, subCategoryId)
      //     : showErrorMessage(context, getFailureMessage(l, context));
      emit(state.copyWith(failure: l, status: CaptainShareStates.error));
    }, (data) {
      context.pop();
      emit(state.copyWith(status: CaptainShareStates.success,pricePerSeat:data));
    });
  }

  Future<void> createRoute(
      {required CreatePricePerSeatParams params, required BuildContext context}) async {
    showLoadingDialog(context);
    final response = await createRouteUseCase(params);
    response.fold((l) {
      context.pop();
      String errorName = getFailureName(l, context);
      errorName == 'DebtError'||errorName == 'Insufficient Funds'
          ? showDebtDialog(context, '62c8ba9f8e28a58a3edf57ee',context.isArabic?'يجب اين يكون لديك رصيد في المحفظه لانشاء رحله':'You must have a balance to create a route')
          : errorName == 'SubscribeError'
          ? showSubscribeDialog(context, '62c8ba9f8e28a58a3edf57ee')
          : showErrorMessage(context, getFailureMessage(l, context));

      emit(state.copyWith(failure: l, status: CaptainShareStates.error));
    }, (data) {
      context.pop();
      context.pop(true);
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }


  List<MyBookingEntity> myBookings = [];
  bool isLoadingMore = false;
  bool isLoadingMyBookings = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  void loadInitialData(BuildContext context) async {
    isLoadingMyBookings=true;
    emit(state.copyWith(status: CaptainShareStates.loading));
    print("object");
    myBookings.clear();
    currentPage = 1;
    hasMoreData = true;
    isLoadingMore = false;
    await getMyBookings(context);
    isLoadingMyBookings=false;
    emit(state.copyWith(status: CaptainShareStates.success));
  }

  Future<void> getMyBookings(BuildContext context) async {
    if (!hasMoreData || isLoadingMore) return;

    emit(state.copyWith(status: CaptainShareStates.loading));
    isLoadingMore = true;

    final response = await getMyBookingsUseCase(
      PaginationParams(
          limit: 10,page: currentPage),
    );

    response.fold(
          (failure) {
            print("objectFailure ${getFailureMessage(failure, context)}");
            emit(
          state.copyWith(failure: failure, status: CaptainShareStates.error));
          },
          (data) {
            print("objectData ${data.length}");
        myBookings.addAll(data);
            print("objectData ${myBookings.length}");

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: CaptainShareStates.success));
      },
    );
  }

  List<MyBookingEntity> availableBookings = [];
  bool isLoadingMoreAvailable = false;
  bool isLoadingAvailableBookings = false;
  bool hasMoreAvailableData = true;
  int currentAvailablePage = 1;

  void loadInitialAvailableData(BuildContext context) async {
    isLoadingAvailableBookings=true;
    emit(state.copyWith(status: CaptainShareStates.loading));
    print("object");
    availableBookings.clear();
    currentAvailablePage = 1;
    hasMoreAvailableData = true;
    isLoadingMoreAvailable = false;
    await getAvailableBookings(context);
    isLoadingAvailableBookings=false;
    emit(state.copyWith(status: CaptainShareStates.success));
  }

  Future<void> getAvailableBookings(BuildContext context) async {
    if (!hasMoreAvailableData || isLoadingMoreAvailable) return;

    emit(state.copyWith(status: CaptainShareStates.loading));
    isLoadingMoreAvailable = true;

    final response = await getAvailableBookingsUseCase(
      PaginationParams(
          limit: 10,page: currentAvailablePage),
    );

    response.fold(
          (failure) {
            print("objectFailure ${getFailureMessage(failure, context)}");
            emit(
          state.copyWith(failure: failure, status: CaptainShareStates.error));
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
        emit(state.copyWith(status: CaptainShareStates.success));
      },
    );
  }

  List<MyBookingEntity> expiredBookings = [];
  bool isLoadingMoreExpired = false;
  bool isLoadingExpiredBookings = false;
  bool hasMoreExpiredData = true;
  int currentExpiredPage = 1;

  void loadInitialExpiredData(BuildContext context) async {
    isLoadingExpiredBookings=true;
    emit(state.copyWith(status: CaptainShareStates.loading));
    print("object");
    expiredBookings.clear();
    currentExpiredPage = 1;
    hasMoreExpiredData = true;
    isLoadingMoreExpired = false;
    await getExpiredBookings(context);
    isLoadingExpiredBookings=false;
    emit(state.copyWith(status: CaptainShareStates.success));
  }

  Future<void> getExpiredBookings(BuildContext context) async {
    if (!hasMoreExpiredData || isLoadingMoreExpired) return;

    emit(state.copyWith(status: CaptainShareStates.loading));
    isLoadingMoreExpired = true;

    final response = await getExpiredBookingsUseCase(
      PaginationParams(
          limit: 10,page: currentExpiredPage),
    );

    response.fold(
          (failure) {
            print("objectFailure ${getFailureMessage(failure, context)}");
            emit(
          state.copyWith(failure: failure, status: CaptainShareStates.error));
          },
          (data) {
            print("objectData ${data.length}");
            expiredBookings.addAll(data);
            print("objectData ${expiredBookings.length}");

        if (data.length < pageSize) {
          hasMoreExpiredData = false;
        } else {
          currentExpiredPage++;
        }

        isLoadingMoreExpired = false;
        emit(state.copyWith(status: CaptainShareStates.success));
      },
    );
  }

  List<MyBookingEntity> runningBookings = [];
  bool isLoadingMoreRunning = false;
  bool isLoadingRunningBookings = false;
  bool hasMoreRunningData = true;
  int currentRunningPage = 1;

  void loadInitialRunningData(BuildContext context) async {
    isLoadingRunningBookings=true;
    emit(state.copyWith(status: CaptainShareStates.loading));
    runningBookings.clear();
    currentRunningPage = 1;
    hasMoreRunningData = true;
    isLoadingMoreRunning = false;
    await getRunningBookings(context);
    isLoadingRunningBookings=false;
    emit(state.copyWith(status: CaptainShareStates.success));
  }

  Future<void> getRunningBookings(BuildContext context) async {
    if (!hasMoreRunningData || isLoadingMoreRunning) return;

    emit(state.copyWith(status: CaptainShareStates.loading));
    isLoadingMoreRunning = true;

    final response = await getRunningBookingsUseCase(
      PaginationParams(
          limit: 10,page: currentRunningPage),
    );

    response.fold(
          (failure) {
            print("objectFailure ${getFailureMessage(failure, context)}");
            emit(
          state.copyWith(failure: failure, status: CaptainShareStates.error));
          },
          (data) {
            print("objectData ${data.length}");
            runningBookings.addAll(data);
            print("objectData ${runningBookings.length}");

        if (data.length < pageSize) {
          hasMoreRunningData = false;
        } else {
          currentRunningPage++;
        }

        isLoadingMoreRunning = false;
        emit(state.copyWith(status: CaptainShareStates.success));
      },
    );
  }


  getEmergencyDetails(
      BuildContext context, SupportRideParams mainParams) async {
    GetSupportDetailsParams params = GetSupportDetailsParams(
        tripId: mainParams.tripId,
        tripType: mainParams.tripType,
        userType: mainParams.userType);
    emit(state.copyWith(status: CaptainShareStates.loading));
    final Either<Failure, SupportDetailsEntity> result =
    await getSupportDetailsUseCase(params);

    result.fold(
          (failure) {
        emit(state.copyWith(status: CaptainShareStates.error, failure: failure));
      },
          (data) async {
        emit(state.copyWith(
            supportDetails: data,
            supportStatus: data.status,
            status: CaptainShareStates.success));
      },
    );
  }

}
