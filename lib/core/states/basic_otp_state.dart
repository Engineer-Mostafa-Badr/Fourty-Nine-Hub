import 'package:equatable/equatable.dart';

import '../enums/base_status_enum.dart';
import '../error/failure.dart';

class BasicOtpState extends Equatable {
  final StateStatus status;
  final Failure? failure;
  final bool isFailureShown;
  final int remainingWrongTimes;
  final int remainingResendTimes;

  const BasicOtpState({
    this.status = StateStatus.initial,
    this.failure,
    this.isFailureShown = false,
    this.remainingWrongTimes = 3,
    this.remainingResendTimes = 5,
  });

  @override
  String toString() {
    return 'UpdateMobileNumberState2{ status: $status, failure: $failure, isFailureShown: $isFailureShown, remainingWrongTimes: $remainingWrongTimes, remainingResendTimes: $remainingResendTimes,}';
  }

  BasicOtpState copyWith({
    StateStatus? status,
    Failure? failure,
    bool? isFailureShown,
    int? remainingWrongTimes,
    int? remainingResendTimes,
  }) {
    return BasicOtpState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      isFailureShown: isFailureShown ?? this.isFailureShown,
      remainingWrongTimes: remainingWrongTimes ?? this.remainingWrongTimes,
      remainingResendTimes: remainingResendTimes ?? this.remainingResendTimes,
    );
  }

  @override
  List<Object?> get props => [
        status,
        failure,
        isFailureShown,
        remainingWrongTimes,
        remainingResendTimes,
      ];
}
