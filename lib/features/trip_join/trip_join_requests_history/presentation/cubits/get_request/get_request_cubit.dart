import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/tripjoin_request_history_entity.dart';
import '../../../domain/usecases/get_request_usecase.dart';
import '../../../../../../res/strings/labels.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'get_request_state.dart';

class GetRequestCubit extends Cubit<GetRequestState> {
  final GetRequestUsecase getRequestUsecase;
  GetRequestCubit({required this.getRequestUsecase})
      : super(GetRequestInitial());
  List<TripJoinRequestHistoryEntity> requests = [];
  int page = 1;
  Future<void> getRequets({required String id}) async {
    emit(GetRequestLoading());
    final response = await getRequestUsecase.call(id: id, page: page);
    response.fold(
      (Failure failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        emit(GetRequestFailed(Labels.errorHappened));
      },
      (data) {
        requests.addAll(data);

        emit(GetRequestSuccess(data));
      },
    );
  }
}
