part of 'create_company_ad_cubit.dart';

class CreateCompanyAdState {
  final StateStatus status;
  final Failure? failure;
  final PriceEntity? price;
  final List<CompanyAdOptionEntity>? advertise;
  final List<CompanyAdEntity>? posts;

  const CreateCompanyAdState({
    this.status = StateStatus.loading,
    this.failure,
    this.price,
    this.advertise,
    this.posts
  });
  CreateCompanyAdState copyWith({
    StateStatus? status,
    Failure? failure,
    PriceEntity? price,
    List<CompanyAdOptionEntity>? advertise,
    List<CompanyAdEntity>? posts
  }) {
    return CreateCompanyAdState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      advertise: advertise ?? this.advertise,
      posts: posts ?? this.posts,
    );
  }
}
