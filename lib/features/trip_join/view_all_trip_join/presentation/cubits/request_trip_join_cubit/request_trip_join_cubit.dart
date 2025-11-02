import 'package:bloc/bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/usecases/request_trip_join_usecase.dart';
import '../../../../../../res/strings/labels.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'request_trip_join_state.dart';

class RequestTripJoinCubit extends Cubit<RequestTripJoinState> {
  final RequstTripJoinUseCase requestTripJoinUseCase;
  RequestTripJoinCubit({
    required this.requestTripJoinUseCase,
  }) : super(RequestTripJoinInitial());
  Future<void> makeTripJoinRequest(
      {required String addId,
      required String mobile,
      required String subCategory,
      required String url,
      bool premuimRequest = false}) async {
    emit(RequestTripJoinLoading());
    final response = await requestTripJoinUseCase.call(
      url: url,
      subCategory: subCategory,
      addId: addId,
      mobile: mobile,
      premuimRequest: premuimRequest,
    );
    response.fold(
      (Failure failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
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
