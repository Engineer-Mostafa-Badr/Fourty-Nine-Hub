import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_response_model/trip_response_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class GetExpiredTripCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetExpiredTripCubit({required this.repository}) : super(RiderInitial());
  get() async {
    var response = await repository.expiredTrip();
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        List<TripResponseModel> list = (r['data']['trips'] as List)
            .map(
              (e) => TripResponseModel.fromJson(e),
            )
            .toList();
        emit(SuccessGetExpairedTripRider(list: list));
      },
    );
  }
}
