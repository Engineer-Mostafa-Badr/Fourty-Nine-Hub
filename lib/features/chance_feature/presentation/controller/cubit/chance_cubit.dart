import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_use_case.dart';

import '../../../../../routes/pages.dart';
import '../../../domain/use_case/add_chance_data.dart';
import 'chance_states.dart';

class ChanceCubit extends Cubit<ChanceState> {
  final FetchChanceUseCase _fetchChanceUseCase;
  final AddChanceUseCase _addChanceUseCase;

  ChanceCubit(this._fetchChanceUseCase, this._addChanceUseCase)
      : super(const ChanceState());

  // Future<void> fetchChance() async {
  //   emit(state.copyWith(status: ChanceStates.loading));
  //   final result = await _fetchChanceUseCase(const NoParams());
  //
  //   result.fold(
  //     (failure) => emit(state.copyWith(status: ChanceStates.error, failure: failure)),
  //     (chance) => emit(state.copyWith(chance: chance, status: ChanceStates.success)),
  //   );
  // }

  Future<void> fetchChance() async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = _fetchChanceUseCase.call(const NoParams());
    return response.then((value) {
      print('_____________________');
      print(value);
      emit(state.copyWith(chance: value, status: ChanceStates.success));
    }).catchError((error) {
      print('_____________________');
      print(error.toString());
      emit(state.copyWith(status: ChanceStates.error));
    });
    // response.fold((l) {
    //   print(getFailureMessage(l, AppPages.router.configuration.navigatorKey.currentContext!));
    //   emit(state.copyWith(failure: l, status: ChanceStates.error));
    // }, (data) {
    //   print('*********************');
    //   print(data);
    //   emit(state.copyWith(chance: data));
    // });
  }

  Future<void> addChance(AddChanceParams params) async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = await _addChanceUseCase(params);
    return response.fold(
      (failure)=>emit(state.copyWith(failure: failure,status: ChanceStates.error)),
      (response) {
        emit(state.copyWith(status: ChanceStates.success));
        fetchChance();
      },
    );
  }
}
