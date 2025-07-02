part of 'captain_share_dashboard_cubit.dart';

enum CaptainShareDashboardStates {
  initState,
  loading,
  loadingSubmitRequest,
  error,
  success,
}

extension CaptainShareDashboardStatex on CaptainShareDashboardState {
  bool get isInitial => status == CaptainShareDashboardStates.initState;
  bool get isLoading => status == CaptainShareDashboardStates.loading;
  bool get isError => status == CaptainShareDashboardStates.error;
  bool get isSuccess => status == CaptainShareDashboardStates.success;
  bool get isLoadingSubmitRequest => status == CaptainShareDashboardStates.loadingSubmitRequest;
}

class CaptainShareDashboardState {
  final CaptainShareDashboardStates status;
  final Failure? failure;
  final int? tapIndex;
  final String? hintText;
  final SettingsDashboardEntityResponse? setting;
  final MyBookingEntity? runningRoute;
  final bool? isCaptain;

  const CaptainShareDashboardState({
    this.failure,
    this.setting,
    this.runningRoute,
    this.tapIndex=0,
    this.hintText='',
    this.isCaptain=false,
    this.status = CaptainShareDashboardStates.initState,
  });
  CaptainShareDashboardState copyWith({
    CaptainShareDashboardStates? status,
    MyBookingEntity? runningRoute,
    SettingsDashboardEntityResponse? setting,
    Failure? failure,
    int? tapIndex,
    String? hintText,
    bool? isCaptain,
  }) {
    return CaptainShareDashboardState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      tapIndex: tapIndex ?? this.tapIndex,
      hintText: hintText ?? this.hintText,
      setting: setting ?? this.setting,
      isCaptain: isCaptain ?? this.isCaptain,
      runningRoute: runningRoute ?? this.runningRoute,
    );
  }
}
