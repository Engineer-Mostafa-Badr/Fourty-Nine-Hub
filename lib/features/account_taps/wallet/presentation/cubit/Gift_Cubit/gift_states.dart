import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/gift_entities.dart';

enum GiftStates { loading, initial, error }

class GiftState {
  final GiftStates status;
  final Failure? failure;
  final GiftEntity? gift;

  const GiftState({
    this.status = GiftStates.loading,
    this.failure,
    this.gift,
  });
  GiftState copyWith({
    GiftStates? status,
    Failure? failure,
    GiftEntity? gift,
  }) {
    return GiftState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      gift: gift ?? this.gift,
    );
  }
}
