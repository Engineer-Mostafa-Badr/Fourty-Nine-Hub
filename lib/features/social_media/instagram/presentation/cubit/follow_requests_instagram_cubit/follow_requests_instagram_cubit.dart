import 'package:bloc/bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/data_suggest_follow_instagram_entity.dart';
import '../../../domain/usecases/get_suggest_follow_instagram_use_case.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'follow_requests_instagram_state.dart';

class FollowRequestsInstagramCubit extends Cubit<FollowRequestsInstagramState> {
  FollowRequestsInstagramCubit(this._getSuggestFollowInstagramUseCase)
      : super(const FollowRequestsInstagramState());

  final GetSuggestFollowInstagramUseCase _getSuggestFollowInstagramUseCase;

  final int suggestFollowLimit = 10;

  Future<void> fetchInitialData() async {
    emit(state.copyWith(state: FollowRequestsInstagramStates.loading));
    final result = await _getSuggestFollowInstagramUseCase.call(
      GetSuggestFollowInstagramParams(
        limit: suggestFollowLimit,
        page: state.suggestFollowPage,
      ),
    );
    result.fold(
      (failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            state: FollowRequestsInstagramStates.failure, failure: failure));
      },
      (data) {
        emit(
          state.copyWith(
            state: FollowRequestsInstagramStates.success,
            suggestions: data.suggestions,
            suggestFollowPage: state.suggestFollowPage + 1,
          ),
        );
      },
    );
  }
}
