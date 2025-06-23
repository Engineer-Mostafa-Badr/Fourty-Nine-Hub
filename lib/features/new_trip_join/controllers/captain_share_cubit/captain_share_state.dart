part of 'captain_share_cubit.dart';

enum CaptainShareStates {
  initState,
  loading,
  error,
  success,
}

extension CaptainShareStatex on CaptainShareState {
  bool get isInitial => status == CaptainShareStates.initState;
  bool get isLoading => status == CaptainShareStates.loading;
  bool get isError => status == CaptainShareStates.error;
  bool get isSuccess => status == CaptainShareStates.success;
}

class CaptainShareState {
  final CaptainShareStates status;
  final Failure? failure;
  final int? tapIndex;
  final CreatePricePerSeatEntity? pricePerSeat;

  const CaptainShareState({
    this.failure,
    this.tapIndex=0,
    this.status = CaptainShareStates.initState,
    this.pricePerSeat,
  });
  CaptainShareState copyWith({
    CaptainShareStates? status,
    CreatePricePerSeatEntity? pricePerSeat,
    Failure? failure,
    int? tapIndex,
  }) {
    return CaptainShareState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      tapIndex: tapIndex ?? this.tapIndex,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
    );
  }
}
