import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'voice_meeting_event.dart';
part 'voice_meeting_state.dart';

class VoiceMeetingBloc extends Bloc<VoiceMeetingEvent, VoiceMeetingState> {
  VoiceMeetingBloc() : super(VoiceMeetingInitial()) {
    on<VoiceMeetingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
