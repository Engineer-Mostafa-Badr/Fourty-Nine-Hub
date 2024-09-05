part of 'create_company_ad_cubit.dart';

class CreateCompanyAdState {
  final StateStatus status;
  final Failure? failure;
  final PriceEntity? price;

  const CreateCompanyAdState({
    this.status = StateStatus.loading,
    this.failure,
    this.price,
  });
  CreateCompanyAdState copyWith({
    StateStatus? status,
    Failure? failure,
    PriceEntity? price,
  }) {
    return CreateCompanyAdState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      price: price ?? this.price,
    );
  }
}
