import 'package:bloc/bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../data/models/get_requests_pick_me_model.dart';
import '../../../domain/use_case/get_requests_pick_me_use_case.dart';
import '../../../../../../res/strings/labels.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'get_requests_pick_me_state.dart';

class GetRequestsPickMeCubit extends Cubit<GetRequestsPickMeState> {
  final GetRequestsPickMeUseCase getRequestsPickMeUseCase;
  bool subscriptionPremium = false;
  GetRequestsPickMeCubit({required this.getRequestsPickMeUseCase})
      : super(GetRequestsPickMeInitial());
  List<TripDataWithRequests> tripDataWithRequests = [];
  Future<void> getRequestsPickMe() async {
    emit(GetRequestsPickMeLoading());
    print("Loaaaaading  == \n");
    final response = await getRequestsPickMeUseCase.call();
    response.fold((Failure failure) {
      var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
      emit(GetRequestsPickMeFailure(errorMessage: Labels.errorHappened));
    }, (data) {
      print("Sucessss === \n");
      tripDataWithRequests.addAll(data);
      emit(
          GetRequestsPickMeSuccess(tripDataWithRequests: tripDataWithRequests));
    });
  }
}
