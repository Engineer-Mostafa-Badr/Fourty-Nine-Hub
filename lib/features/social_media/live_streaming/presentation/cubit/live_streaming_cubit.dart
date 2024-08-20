import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'live_streaming_state.dart';

class LiveStreamingCubit extends Cubit<LiveStreamingState> {
  LiveStreamingCubit() : super(LiveStreamingInitial());
}
