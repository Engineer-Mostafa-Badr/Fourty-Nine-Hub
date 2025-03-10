part of 'fetch_sub_category_wallet_cubit.dart';

sealed class FetchSubCategoryWalletState extends Equatable {
  const FetchSubCategoryWalletState();

  @override
  List<Object> get props => [];
}

final class FetchSubCategoryWalletInitial extends FetchSubCategoryWalletState {}

final class FetchSubCategoryWalletLoading extends FetchSubCategoryWalletState {}

final class FetchSubCategoryWalletSuccess extends FetchSubCategoryWalletState {
  final List<MainCategoryWalletEntity> subCategory;

  const FetchSubCategoryWalletSuccess({required this.subCategory});
}

final class FetchSubCategoryWalletError extends FetchSubCategoryWalletState {
  final Failure failure;

  const FetchSubCategoryWalletError({required this.failure});
}
