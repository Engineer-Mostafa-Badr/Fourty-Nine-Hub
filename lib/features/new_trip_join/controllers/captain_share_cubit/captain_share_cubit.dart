import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/new_trip_join/data/models/my_booking_model.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/create_price_per_seat_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/cancel_my_booking_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_available_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_expired_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_my_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/get_running_bookings_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_cancel_route_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_join_available_routes_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_leave_available_routes_use_case.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/listen_to_new_route_use_case.dart';
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
  CaptainShareCubit(this.createPricePerSeatUseCase,this.listenToCancelRouteUseCase,this.listenToJoinAvailableRoutesUseCase,this.listenToLeaveAvailableRoutesUseCase,this.listenToNewRouteUseCase,this.createRouteUseCase,this.getRunningBookingsUseCase,this.getExpiredBookingsUseCase, this.getMyBookingsUseCase, this.cancelMyBookingUseCase, this.getAvailableBookingsUseCase)
      : super(const CaptainShareState());


  void initData(BuildContext context)async{
    loadInitialAvailableData(context);
    await listenToJoinRoute();
    listenToNewRoute(context);
    listenToCancelRoute(context);
  }

  void listenToCancelRoute(BuildContext context) {
    CliLogger.info('listenToCancelRoute');
    // TripsResponseEntity
    listenToCancelRouteUseCase((routeId) {
      if(state.tapIndex==0){
        availableBookings.removeWhere((element) => element.id==routeId);
        showSuccessMessage(context, context.isArabic?'تم الغاء الرحله بواسطة ناشئ الرحلة':'Route canceled by creator');
      }
      if(state.tapIndex==1){
        myBookings.removeWhere((element) => element.id==routeId);
        showSuccessMessage(context, context.isArabic?'تم الغاء الرحله بواسطة ناشئ الرحلة':'Route canceled by creator');
      }
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }

  listenToJoinRoute() {
    CliLogger.info('listenToJoinRoute');
    // TripsResponseEntity
    listenToJoinAvailableRoutesUseCase((isJoined) {
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }

  void listenToLeaveRoute() {
    CliLogger.info('listenToLeaveRoute');
    // TripsResponseEntity
    listenToLeaveAvailableRoutesUseCase((routeId) {
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }

  void listenToNewRoute(BuildContext context) {
    CliLogger.info('listenToNewRoute');
    // TripsResponseEntity
    listenToNewRouteUseCase((route) {
      if(state.tapIndex==0){
        availableBookings.insert(0, route);
        showSuccessMessage(context, context.isArabic?'تم استقبال رحلة جديدة':'New route accepted');
      }else{
        onChangeTapIndex(0,context);
        loadInitialAvailableData(context);
        showSuccessMessage(context, context.isArabic?'تم استقبال رحلة جديدة':'New route accepted');
      }
      emit(state.copyWith(status: CaptainShareStates.success));
    });
  }


  onChangeTapIndex(int index,BuildContext context){
    if(index==0) listenToJoinRoute();
    if(index!=0) listenToLeaveRoute();
    print("state.tapIndex Cubit : $index");
    emit(state.copyWith(status: CaptainShareStates.success,tapIndex: index));
  }
  onShowHintTap(int index,BuildContext context){
    if(index==0) listenToJoinRoute();
    if(index!=0) listenToLeaveRoute();
    print("state.tapIndex Cubit : $index");
    emit(state.copyWith(status: CaptainShareStates.success,tapIndex: index));
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
          ? showDebtDialog(context, '62c8ba9f8e28a58a3edf57ee')
          : errorName == 'SubscribeError'
          ? showSubscribeDialog(context, '62c8ba9f8e28a58a3edf57ee')
          : showErrorMessage(context, getFailureMessage(l, context));

      emit(state.copyWith(failure: l, status: CaptainShareStates.error));
    }, (data) {
      context.pop();
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

}
