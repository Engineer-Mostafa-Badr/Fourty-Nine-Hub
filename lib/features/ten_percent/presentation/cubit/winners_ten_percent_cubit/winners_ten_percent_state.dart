part of 'winners_ten_percent_cubit.dart';

enum WinnersTenPercentStatus {
  initial,
  loading,
  success,
  failure,
}

extension WinnersTenPercentStatusX on WinnersTenPercentStatus {
  bool get isInitial => this == WinnersTenPercentStatus.initial;
  bool get isLoading => this == WinnersTenPercentStatus.loading;
  bool get isSuccess => this == WinnersTenPercentStatus.success;
  bool get isFailure => this == WinnersTenPercentStatus.failure;
}

class WinnersTenPercentState {
  final WinnersTenPercentStatus status;
  final WinnersTenPercentEntity? winners;
  final int page;
  final bool hasReachedMax;
  final Failure? failure;

  const WinnersTenPercentState({
    this.status = WinnersTenPercentStatus.initial,
    this.winners,
    this.page = 1,
    this.hasReachedMax = false,
    this.failure,
  });

  WinnersTenPercentState copyWith({
    WinnersTenPercentStatus? status,
    WinnersTenPercentEntity? winners,
    int? page,
    bool? hasReachedMax,
    Failure? failure,
  }) {
    return WinnersTenPercentState(
      status: status ?? this.status,
      winners: winners ?? this.winners,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      failure: failure ?? this.failure,
    );
  }
}
