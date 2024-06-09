import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'offers_ride_state.dart';

class OffersRideCubit extends Cubit<OffersRideState> {
  OffersRideCubit() : super(OffersRideInitial());
}
