
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/reasons_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetReasonsCubit extends Cubit<RiderState> {
  ReiderRequestRepository repository;
  GetReasonsCubit({required this.repository}) : super(RiderInitial());
  get() async {
    emit(LoadingRiderState());
    var response = await repository.reasons();
    response.fold(
      (l) {
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
