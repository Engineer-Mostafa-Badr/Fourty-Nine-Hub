import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ride_event.dart';
part 'ride_state.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  RideBloc() : super(RideInitial()) {
    on<RideEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
