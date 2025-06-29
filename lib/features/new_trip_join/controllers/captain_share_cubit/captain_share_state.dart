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
  final CreatePricePerSeatEntity? pricePerSeat;

  const CaptainShareState({
    this.failure,
    this.status = CaptainShareStates.initState,
    this.pricePerSeat,
  });
  CaptainShareState copyWith({
    CaptainShareStates? status,
    CreatePricePerSeatEntity? pricePerSeat,
    Failure? failure,
  }) {
    return CaptainShareState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
    );
  }
}
