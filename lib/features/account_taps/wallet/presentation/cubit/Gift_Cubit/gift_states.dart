
import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/gift_entities.dart';

enum GiftStates { loading, initial, error }

class GiftState {
  final GiftStates status;
  final Failure? failure;
  final List<CompetitionWallet>? competition;
  final GiftWallet? gift;

  const GiftState({
    this.status = GiftStates.loading,
    this.failure,
    this.competition,
    this.gift,
  });
  GiftState copyWith({
    GiftStates? status,
    Failure? failure,
    List<CompetitionWallet>? competition,
    GiftWallet? gift,
  }) {
    return GiftState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      competition: competition ?? this.competition,
      gift: gift ?? this.gift,
    );
  }
}
