part of 'gift_two_cubit.dart';

sealed class GiftTwoState extends Equatable {
  const GiftTwoState();

  @override
  List<Object> get props => [];
}

final class GiftTwoInitial extends GiftTwoState {}

final class GiftTwoLoading extends GiftTwoState {}

final class GiftTwoSuccess extends GiftTwoState {
  // final GiftEntity giftEntity;
  final WheelWalletEntity wheelWalletEntity;

  const GiftTwoSuccess({
    // required this.giftEntity,
    required this.wheelWalletEntity,
  });
}

final class GiftTwoFailure extends GiftTwoState {
  final String message;

  const GiftTwoFailure({required this.message});
}
