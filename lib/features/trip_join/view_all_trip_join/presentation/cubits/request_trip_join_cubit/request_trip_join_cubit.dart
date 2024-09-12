import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/usecases/request_trip_join_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'request_trip_join_state.dart';

class RequestTripJoinCubit extends Cubit<RequestTripJoinState> {
  final RequstTripJoinUseCase requestTripJoinUseCase;
  RequestTripJoinCubit({
    required this.requestTripJoinUseCase,
  }) : super(RequestTripJoinInitial());
  Future<void> makeTripJoinRequest({
    required String addId,
    required String mobile,
  }) async {
    emit(RequestTripJoinLoading());
    final response =
        await requestTripJoinUseCase.call(addId: addId, mobile: mobile);
    response.fold(
      (Failure failure) {
        emit(RequestTripJoinFailed(Labels.errorHappened));
        Future.delayed(const Duration(seconds: 2)).then(
          (value) => emit(RequestTripJoinInitial()),
        );
      },
      (_) {
        emit(RequestTripJoinSuccess());
        Future.delayed(const Duration(seconds: 2)).then(
          (value) => emit(RequestTripJoinInitial()),
        );
      },
    );
  }
}
