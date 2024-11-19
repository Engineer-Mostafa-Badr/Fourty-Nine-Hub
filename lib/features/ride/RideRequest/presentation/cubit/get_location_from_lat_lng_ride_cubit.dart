import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetLocationFromLatLngRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetLocationFromLatLngRideCubit({required this.repository})
      : super(RiderInitial());
}
