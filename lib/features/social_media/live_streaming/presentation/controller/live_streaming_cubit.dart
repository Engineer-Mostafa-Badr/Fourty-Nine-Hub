import '../../../../zoom/presentation/bloc/meeting_cubit.dart';
import '../../../../zoom/presentation/bloc/meeting_state.dart';

extension TiktokController on StreamCubit {
  void setTopic(String? option) {
    emit(state.copyWith(status: StreamsStates.changeTopic, topic: option));
  }
}
