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
  final XFile? file;
  final String? mediaId;

  const TenPercentState({
    this.status,
    this.failure,
    this.isLast,
    this.file,
    this.mediaId,
  });
  TenPercentState copyWith({
    TenPercentStates? status,
    Failure? failure,
    bool? isLast,
    XFile? file,
    String? mediaId
  }) {
    return TenPercentState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      isLast: isLast ?? this.isLast,
      file: file ?? this.file,
      mediaId: mediaId ?? this.mediaId,
    );
  }
}
