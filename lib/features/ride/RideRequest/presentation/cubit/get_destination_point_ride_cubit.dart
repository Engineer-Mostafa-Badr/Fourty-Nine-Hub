import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class GetDestinationPointRideCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  String type = '';
  double? endLat;
  double? endLong;
  GetDestinationPointRideCubit({required this.repository})
      : super(RiderInitial());
  getDestinationPoint({required String address}) async {
    endLat = null;
    endLong = null;
    emit(DestintionLocationLoading());
    var response = await repository.getAddressFromLatAndLong(address: address);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(DestinationLocationFailed());
      },
      (r) {
        type = r['data']['type'];
        endLat = r['data']['lat'];
        endLong = r['data']['lng'];
        emit(SuccessGetDestinationPointState(
            address: r['data']['address'],
            lat: r['data']['lat'],
            lng: r['data']['lng'],
            type: r['data']['type']));
      },
    );
  }
}
