import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';

part 'get_accepted_trip_state.dart';

class GetAcceptedTripCubit extends Cubit<GetAcceptedTripState> {
  GetAcceptedTripCubit() : super(GetAcceptedTripInitial());
}
