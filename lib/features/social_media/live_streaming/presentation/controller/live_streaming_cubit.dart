// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../../../../zoom/presentation/bloc/meeting_cubit.dart';
import '../../../../zoom/presentation/bloc/meeting_state.dart';

extension TiktokController on StreamCubit {
  void setTopic(String? option) {
    emit(state.copyWith(status: StreamsStates.changeTopic, topic: option));
  }

  Future<void> getTopics() async {
    emit(state.copyWith(status: StreamsStates.loading));
    var result = await getAllTopicsUseCase(const NoParams());
    result.fold(
        (l) => emit(state.copyWith(status: StreamsStates.failure, failure: l)),
        (r) {
      topics = r;
      emit(state.copyWith(status: StreamsStates.success));
    });
  }
}
