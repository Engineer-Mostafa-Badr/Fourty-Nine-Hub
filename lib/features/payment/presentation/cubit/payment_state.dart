part of 'payment_cubit.dart';

class PaymentState {
  final StateStatus? status;
  final Failure? failure;
  final List<PaymentProviderEntity>? data;

  PaymentState(
      {
      this.status,
      this.failure,
      this.data,

      });

  PaymentState copyWith({
    StateStatus? status,
    Failure? failure,
    List<PaymentProviderEntity>? data,
  }) {
    return PaymentState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      data: data ?? this.data,

    );
  }
}
