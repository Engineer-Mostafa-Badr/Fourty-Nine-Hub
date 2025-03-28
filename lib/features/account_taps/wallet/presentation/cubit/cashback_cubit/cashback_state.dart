part of 'cashback_cubit.dart';

enum CashbackStates {
  initial,
  loading,
  success,
  failure,
}

extension CashbackStateX on CashbackStates {
  bool get isInitial => this == CashbackStates.initial;
  bool get isLoading => this == CashbackStates.loading;
  bool get isSuccess => this == CashbackStates.success;
  bool get isFailure => this == CashbackStates.failure;
}

class CashbackState {
  final CashbackStates status;
  final BalanceDataEntity? cashback;
  final List<BalanceHistoryEntity>? histories;
  final bool isLoadingButton;
  final bool? buttonRequestSuccess;
  final String? messageFailure;
  final bool hasReachedMax;
  final int page;

  const CashbackState({
    this.status = CashbackStates.initial,
    this.cashback,
    this.histories,
    this.isLoadingButton = false,
    this.buttonRequestSuccess,
    this.messageFailure,
    this.hasReachedMax = false,
    this.page = 1,
  });

  CashbackState copyWith({
    CashbackStates? status,
    BalanceDataEntity? cashback,
    List<BalanceHistoryEntity>? histories,
    bool? isLoadingButton,
    bool? buttonRequestSuccess,
    String? messageFailure,
    bool? hasReachedMax,
    int? page,
  }) =>
      CashbackState(
        status: status ?? this.status,
        cashback: cashback ?? this.cashback,
        histories: histories ?? this.histories,
        isLoadingButton: isLoadingButton ?? this.isLoadingButton,
        buttonRequestSuccess: buttonRequestSuccess ?? this.buttonRequestSuccess,
        messageFailure: messageFailure ?? this.messageFailure,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page,
      );
}
// sealed class CashbackState extends Equatable {
//   const CashbackState();

//   @override
//   List<Object> get props => [];
// }

// final class CashbackInitial extends CashbackState {}

// final class CashbackLoading extends CashbackState {}

// final class CashbackSuccess extends CashbackState {
//   final BalanceDataEntity cashback;
//   final List<BalanceHistoryEntity> histories;

//   const CashbackSuccess({
//     required this.cashback,
//     required this.histories,
//   });
// }

// final class CashbackFailure extends CashbackState {
//   final String message;

//   const CashbackFailure({required this.message});
// }
