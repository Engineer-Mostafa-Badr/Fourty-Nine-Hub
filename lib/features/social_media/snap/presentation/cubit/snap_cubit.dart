import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/snap/domain/use_case/fetch_filter_snap_use_case.dart';
import 'snap_states.dart';

class SnapCubit extends Cubit<SnapState> {
  final FetchFilterSnapUseCase _fetchFilterSnapUseCase;

  SnapCubit(
    this._fetchFilterSnapUseCase,
  ) : super(const SnapState());

  Future<void> fetchFilter() async {
    final response = await _fetchFilterSnapUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: SnapStates.error));
    }, (data) {
      emit(state.copyWith(snap: data, status: SnapStates.success));
    });
  }
}
