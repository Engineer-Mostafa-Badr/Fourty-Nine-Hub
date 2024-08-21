import 'package:flutter_bloc/flutter_bloc.dart';

part 'trip_join_view_state.dart';

class TripJoinViewCubit extends Cubit<TripJoinViewState> {
  TripJoinViewCubit() : super(TripJoinViewInitial());
  bool showDate = false;
  void controlDateVisibilty(bool showDate) {
    this.showDate = showDate;
    emit(TripJoinViewShowDateState(showDate));
  }
}
