import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'club_house_event.dart';
part 'club_house_state.dart';

class ClubHouseBloc extends Bloc<ClubHouseEvent, ClubHouseState> {
  ClubHouseBloc() : super(ClubHouseInitial()) {
    on<ClubHouseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
