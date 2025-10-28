import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/all_trip_no_socket_model/all_trip_no_socket_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/routes/pages.dart';
class GetAllTripNoSocketCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetAllTripNoSocketCubit({required this.repository}) : super(RiderInitial());
  get() async {
    emit(LoadingRiderState());
    var response =
        await repository.getAllTripNoSocket(id: "62c8baa48e28a58a3edf57f5");
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        List<AllTripNoSocketModel> list = (r['data']['docs'] as List)
            .map(
              (e) => AllTripNoSocketModel.fromJson(e),
            )
            .toList();
        emit(SuccessGetAllTripNoSocketState(list: list));
      },
    );
  }
}
