import '../../../../../../core/error/failure.dart';
import '../../../../../lucky_wheel/domain/entities/wheel_wallet_entity.dart';
import '../../../domain/entities/gift_entities.dart';

enum GiftStates { loading, initial, error ,success,errorRequest}

class GiftState {
  final GiftStates status;
  final Failure? failure;
  final GiftEntity? gift;
  final WheelWalletEntity? wheel;

  const GiftState({
    this.status = GiftStates.loading,
    this.failure,
    this.gift,
    this.wheel,
  });
  GiftState copyWith(
      {GiftStates? status,
      Failure? failure,
      GiftEntity? gift,
      WheelWalletEntity? wheel}) {
    return GiftState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      gift: gift ?? this.gift,
      wheel: wheel ?? this.wheel,
    );
  }
}
