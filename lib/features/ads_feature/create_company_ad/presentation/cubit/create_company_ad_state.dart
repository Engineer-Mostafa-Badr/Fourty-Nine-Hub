part of 'create_company_ad_cubit.dart';

class CreateCompanyAdState {
  final StateStatus status;
  final Failure? failure;
  final PriceEntity? price;
  final List<CompanyAdOptionEntity>? advertise;
  final List<CompanyAdEntity>? posts;
  final num totalPrice;

  const CreateCompanyAdState({
    this.status = StateStatus.loading,
    this.failure,
    this.price,
    this.advertise,
    this.posts,
    this.totalPrice = 0, // Default to 0
  });
  CreateCompanyAdState copyWith({
    StateStatus? status,
    Failure? failure,
    PriceEntity? price,
    List<CompanyAdOptionEntity>? advertise,
    List<CompanyAdEntity>? posts,
    num? totalPrice,
  }) {
    return CreateCompanyAdState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      price: price ?? this.price,
      advertise: advertise ?? this.advertise,
      posts: posts ?? this.posts,
      totalPrice: totalPrice ?? this.totalPrice, // Ensure totalPrice is copied
    );
  }
}
