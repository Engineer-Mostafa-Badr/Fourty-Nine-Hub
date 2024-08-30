import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'trip_join_view_state.dart';

class TripJoinViewCubit extends Cubit<TripJoinViewState> {
  TripJoinViewCubit() : super(TripJoinViewInitial());
  bool repeate = false;
  int numberOfSeats = 1;
  DateTime tripJoinDate = DateTime.now();
  TimeOfDay tripJoinTimeOfDay = TimeOfDay.now();
  String? phoneNumber;

  void controlDateVisibilty(bool repeate) {
    this.repeate = repeate;
    emit(TripJoinViewShowDateState(repeate));
  }

  void changeNumberOfSeats(int numberOfSeats) {
    this.numberOfSeats = numberOfSeats;
    emit(TripJoinViewSeatNumberState(numberOfSeats));
  }
}
