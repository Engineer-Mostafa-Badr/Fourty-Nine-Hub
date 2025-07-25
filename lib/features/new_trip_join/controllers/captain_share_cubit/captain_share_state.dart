part of 'captain_share_cubit.dart';

enum CaptainShareStates {
  initState,
  loading,
  loadingSubmitRequest,
  error,
  success,
}

extension CaptainShareStatex on CaptainShareState {
  bool get isInitial => status == CaptainShareStates.initState;
  bool get isLoading => status == CaptainShareStates.loading;
  bool get isError => status == CaptainShareStates.error;
  bool get isSuccess => status == CaptainShareStates.success;
  bool get isLoadingSubmitRequest => status == CaptainShareStates.loadingSubmitRequest;
}

class CaptainShareState {
  final CaptainShareStates status;
  final Failure? failure;
  final int? tapIndex;
  final String? hintText;
  final String? supportStatus;
  final CreatePricePerSeatEntity? pricePerSeat;
  final MyBookingEntity? routeDetails;
  final SupportDetailsEntity? supportDetails;
  final RunningRouteEntity? runningRoute;
  final GetLocationFromAddressEntity? currentLocation;
  final GetLocationFromAddressEntity? toLocation;

  const CaptainShareState({
    this.failure,
    this.tapIndex=0,
    this.hintText='',
    this.supportStatus='',
    this.status = CaptainShareStates.initState,
    this.pricePerSeat,
    this.routeDetails,
    this.supportDetails,
    this.runningRoute,
    this.currentLocation,
    this.toLocation,
  });
  CaptainShareState copyWith({
    CaptainShareStates? status,
    CreatePricePerSeatEntity? pricePerSeat,
    Failure? failure,
    int? tapIndex,
    String? hintText,
    String? supportStatus,
    SupportDetailsEntity? supportDetails,
    MyBookingEntity? routeDetails,
    RunningRouteEntity? runningRoute,
    GetLocationFromAddressEntity? currentLocation,
    GetLocationFromAddressEntity? toLocation,
  }) {
    return CaptainShareState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      tapIndex: tapIndex ?? this.tapIndex,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
      hintText: hintText ?? this.hintText,
      supportStatus: supportStatus ?? this.supportStatus,
      routeDetails: routeDetails ?? this.routeDetails,
      supportDetails: supportDetails ?? this.supportDetails,
      runningRoute: runningRoute ?? this.runningRoute,
      currentLocation: currentLocation ?? this.currentLocation,
      toLocation: toLocation ?? this.toLocation,
    );
  }
}
