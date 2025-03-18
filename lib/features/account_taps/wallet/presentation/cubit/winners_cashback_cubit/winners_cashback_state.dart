part of 'winners_cashback_cubit.dart';

enum WinnersCashbackStates { loading, initial, failure, success }

extension WinnersCashbackStateX on WinnersCashbackStates {
  bool get isInitial => this == WinnersCashbackStates.initial;
  bool get isLoading => this == WinnersCashbackStates.loading;
  bool get isFailure => this == WinnersCashbackStates.failure;
  bool get isSuccess => this == WinnersCashbackStates.success;
}

class WinnersCashbackState {
  final WinnersCashbackStates status;
  final DataWinnersCashbackEntity? winnersCashback;
  final bool hasReachedMax;
  final int page;
  final String? errMessage;

  WinnersCashbackState({
    this.status = WinnersCashbackStates.initial,
    this.winnersCashback,
    this.hasReachedMax = false,
    this.page = 1,
    this.errMessage,
  });

  WinnersCashbackState copyWith({
    WinnersCashbackStates? status,
    DataWinnersCashbackEntity? winnersCashback,
    bool? hasReachedMax,
    int? page,
    String? errMessage,
  }) =>
      WinnersCashbackState(
        status: status ?? this.status,
        winnersCashback: winnersCashback ?? this.winnersCashback,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page,
        errMessage: errMessage ?? this.errMessage,
      );
}
