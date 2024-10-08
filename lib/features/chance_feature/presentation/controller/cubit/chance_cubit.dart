import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_use_case.dart';

import 'chance_states.dart';

class ChanceCubit extends Cubit<ChanceState> {
  final FetchChanceUseCase _fetchChanceUseCase;

  ChanceCubit(this._fetchChanceUseCase) : super(const ChanceState());

  Future<void> fetchChance() async {
    emit(state.copyWith(status: ChanceStates.loading));
    final result = await _fetchChanceUseCase(const NoParams());

    emit(result.fold(
      (failure) => state.copyWith(status: ChanceStates.error, failure: failure),
      (chance) => state.copyWith(chance: chance, status: ChanceStates.success),
    ));
  }
}
