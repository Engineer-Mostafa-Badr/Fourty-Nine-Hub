import 'package:fourtyninehub/features/competition/domain/entity/competition_entity.dart';
import 'package:fourtyninehub/features/competition/domain/entity/winner_competition_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/currency_entity.dart';
import '../../../../../../core/error/failure.dart';

enum CompetitionStates { loading, initial, error, success, updateSuccess }

class CompetitionState {
  final CompetitionStates status;
  final Failure? failure;
  final List<CompetitionEntity>? competition;
  final List<WinnerCompetitionEntity>? winner;
  final CurrencyEntity? currency;

  const CompetitionState({
    this.status = CompetitionStates.loading,
    this.failure,
    this.competition,
    this.winner,
    this.currency,
  });
  CompetitionState copyWith({
    CompetitionStates? status,
    Failure? failure,
    List<CompetitionEntity>? competition,
    List<WinnerCompetitionEntity>? winner,
    CurrencyEntity? currency,
  }) {
    return CompetitionState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      competition: competition ?? this.competition,
      winner: winner ?? this.winner,
      currency: currency ?? this.currency,
    );
  }
}
