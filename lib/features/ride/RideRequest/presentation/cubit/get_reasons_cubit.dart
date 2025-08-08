import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/reasons_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class GetReasonsCubit extends Cubit<RiderState> {
  ReiderRequestRepository repository;
  GetReasonsCubit({required this.repository}) : super(RiderInitial());
  get() async {
    emit(LoadingRiderState());
    var response = await repository.reasons();
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        List<ReasonsModel> list = (r['data'] as List)
            .map(
              (e) => ReasonsModel.fromJson(e),
            )
            .toList();
        if (list.isNotEmpty) {
          emit(SuccessGetResonsState(list: list));
        }
      },
    );
  }
}
