import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../reels/domain/entities/reel_entity.dart';
import '../../../../twitter/domain/usecases/get_feed_usecase.dart';
import '../../../domain/usecases/get_instagram_reels_usecase.dart';

part 'reel_instagram_state.dart';

class ReelInstagramCubit extends Cubit<ReelInstagramState> {
  final GetInstagramReelsUseCase _getInstagramReelsUseCase;

  ReelInstagramCubit(this._getInstagramReelsUseCase)
      : super(const ReelInstagramState());

  Future<void> getReels() async {
    emit(state.copyWith(status: ReelInstagramStatus.loading));
    final result = await _getInstagramReelsUseCase.call(
      TwitterFeedParams(page: 1, limit: 30),
    );
    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));

        emit(
          state.copyWith(
            status: ReelInstagramStatus.failure,
            failure: failure,
          ),
        );
      },
      (reels) => emit(
        state.copyWith(
          status: ReelInstagramStatus.success,
          reels: reels.reelsData,
        ),
      ),
    );
  }
}
