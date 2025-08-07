import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../domain/use_case/fetch_filter_snap_use_case.dart';
import 'snap_states.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class SnapCubit extends Cubit<SnapState> {
  final FetchFilterSnapUseCase _fetchFilterSnapUseCase;

  SnapCubit(
    this._fetchFilterSnapUseCase,
  ) : super(const SnapState());

  Future<void> fetchFilter() async {
    final response = await _fetchFilterSnapUseCase.call(const NoParams());
    response.fold((l) {
      var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: SnapStates.error));
    }, (data) {
      emit(state.copyWith(snap: data, status: SnapStates.success));
    });
  }
}
