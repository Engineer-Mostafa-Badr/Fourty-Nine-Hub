part of 'ten_percent_cubit.dart';

enum TenPercentStates { loading, initState, error, success }

extension TenPercentStateX on TenPercentState {
  bool get isInitial => status == TenPercentStates.initState;
  bool get isLoading => status == TenPercentStates.loading;
  bool get isError => status == TenPercentStates.error;
  bool get isSuccess => status == TenPercentStates.success;
}

class TenPercentState {
  final TenPercentStates? status;
  final Failure? failure;
  final bool? isLast;
  final String? mobileFile;
  final String? electricityFile;
  final String? trafficFile;
  final String? mobileId;
  final String? electricityId;
  final String? trafficId;

  const TenPercentState({
    this.status,
    this.failure,
    this.isLast,
    this.mobileFile,
    this.electricityFile,
    this.trafficFile,
    this.mobileId,
    this.electricityId,
    this.trafficId,
  });
  TenPercentState copyWith(
      {TenPercentStates? status,
      Failure? failure,
      bool? isLast,
      String? mobileFile,
      String? electricityFile,
      String? trafficFile,
      String? mobileId,
      String? electricityId,
      String? trafficId}) {
    return TenPercentState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      isLast: isLast ?? this.isLast,
      mobileFile: mobileFile ?? this.mobileFile,
      electricityFile: electricityFile ?? this.electricityFile,
      trafficFile: trafficFile ?? this.trafficFile,
      mobileId: mobileId ?? this.mobileId,
      electricityId: electricityId ?? this.electricityId,
      trafficId: trafficId ?? this.trafficId,
    );
  }
}
