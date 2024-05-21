import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'zoom_event.dart';
part 'zoom_state.dart';

class ZoomBloc extends Bloc<ZoomEvent, ZoomState> {
  ZoomBloc() : super(ZoomInitial()) {
    on<ZoomEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
