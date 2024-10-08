import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';

import '../../../../../../core/error/failure.dart';

enum ChanceStates { loading, initial, error,success }

class ChanceState {
  final ChanceStates status;
  final Failure? failure;
  final List<ChanceEntity>? chance;

  const ChanceState({
    this.status = ChanceStates.loading,
    this.failure,
    this.chance,
  });
  ChanceState copyWith(
      {ChanceStates? status,
      Failure? failure,
        List<ChanceEntity>? chance
      }) {
    return ChanceState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      chance: chance ?? this.chance,
    );
  }
}
