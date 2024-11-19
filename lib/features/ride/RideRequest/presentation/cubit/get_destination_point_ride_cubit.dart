import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetDestinationPointRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetDestinationPointRideCubit({required this.repository})
      : super(RiderInitial());
  getDestinationPoint({required String address}) async {
    emit(DestintionLocationLoading());
    var response = await repository.getAddressFromLatAndLong(address: address);
    response.fold(
      (l) {
        emit(DestinationLocationFailed());
      },
      (r) {
        emit(SuccessGetDestinationPointState(
            address: r['data']['address'],
            lat: r['data']['lat'],
            lng: r['data']['lng'],
            type: r['data']['type']));
      },
    );
  }
}
