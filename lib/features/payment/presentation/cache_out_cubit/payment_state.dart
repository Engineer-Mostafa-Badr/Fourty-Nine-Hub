part of 'payment_cubit.dart';

class PaymentCacheOutState {
  final StateStatus? status;
  final Failure? failure;
  final InstapayCacheOutEntity? instaPay;

  PaymentCacheOutState(
      { this.status,  this.failure,  this.instaPay});

  PaymentCacheOutState copyWith({
    StateStatus? status,
    Failure? failure,
    InstapayCacheOutEntity? instaPay,
  }) {
    return PaymentCacheOutState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      instaPay: instaPay ?? this.instaPay,
    );
  }
}
