import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetStartingPointRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  double? startLat;
  double? startLong;
  String type = '';
  GetStartingPointRideCubit({required this.repository}) : super(RiderInitial());
  getStartingPoint(
      {required String address,
      bool isFirstTime = false,
      double? lat,
      double? long,
      String? platformType}) async {
    emit(StartingLocationLoading());
    if (isFirstTime) {
      type = platformType!;
      startLat = lat;
      startLong = long;
      emit(SuccessGetStartingPointState(
        address: "home",
        lat: lat!,
        lng: long!,
        type: type,
      ));
    } else {
      var response =
          await repository.getAddressFromLatAndLong(address: address);
      response.fold(
        (l) {
          emit(StartingLocationFailed());
        },
        (r) {
          type = r['data']['type'];
          startLat = r['data']['lat'];
          startLong = r['data']['lng'];
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
}
