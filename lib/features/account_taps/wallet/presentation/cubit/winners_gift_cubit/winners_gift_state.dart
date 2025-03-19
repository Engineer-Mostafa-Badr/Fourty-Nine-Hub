part of 'winners_gift_cubit.dart';

enum WinnersGiftStates { loading, initial, failure, success }

extension WinnersGiftStateX on WinnersGiftStates {
  bool get isInitial => this == WinnersGiftStates.initial;
  bool get isLoading => this == WinnersGiftStates.loading;
  bool get isFailure => this == WinnersGiftStates.failure;
  bool get isSuccess => this == WinnersGiftStates.success;
}

class WinnersGiftState {
  final WinnersGiftStates status;
  final DataWinnersGiftEntity? winnersGift;
  final bool hasReachedMax;
  final int page;
  final String? errMessage;
  const WinnersGiftState({
    this.status = WinnersGiftStates.initial,
    this.winnersGift,
    this.hasReachedMax = false,
    this.page = 1,
    this.errMessage,
  });

  WinnersGiftState copyWith({
    WinnersGiftStates? status,
    DataWinnersGiftEntity? winnersGift,
    bool? hasReachedMax,
    int? page,
    String? errMessage,
  }) {
    return WinnersGiftState(
      status: status ?? this.status,
      winnersGift: winnersGift ?? this.winnersGift,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errMessage: errMessage ?? this.errMessage,
    );
  }
}
