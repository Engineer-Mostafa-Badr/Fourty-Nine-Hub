import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetStartingPointRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetStartingPointRideCubit({required this.repository}) : super(RiderInitial());
  getStartingPoint({required String address}) async {
    emit(StartingLocationLoading());
    var response = await repository.getAddressFromLatAndLong(address: address);
    response.fold(
      (l) {
        emit(StartingLocationFailed());
      },
      (r) {
        emit(SuccessGetStartingPointState(
          address: r['data']['address'],
          lat: r['data']['lat'],
          lng: r['data']['lng'],
          type: r['data']['type'],
        ));
      },
    );
  }
}
