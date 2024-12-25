import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class DriversNearbyCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  DriversNearbyCubit({required this.repository}) : super(RiderInitial());

  check(
      {required String tripId,
      required List location,
      required String subcategoryId,
      required String address}) {
    repository.driversNearBy(
      tripId: tripId,
      location: location,
      subcategoryId: subcategoryId,
      address: address,
      onChange: (model) {
        emit(SuccessGetDriversNearState(list: model));
      },
    );
  }
}
