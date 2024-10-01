import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_history_entity.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/usecases/get_request_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

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
        emit(GetRequestFailed(Labels.errorHappened));
      },
      (data) {
        requests.addAll(data);

        emit(GetRequestSuccess(data));
      },
    );
  }
}
