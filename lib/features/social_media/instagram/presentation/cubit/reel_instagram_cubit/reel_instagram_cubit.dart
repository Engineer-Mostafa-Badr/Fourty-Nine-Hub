import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/entities/reel_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';

part 'reel_instagram_state.dart';

class ReelInstagramCubit extends Cubit<ReelInstagramState> {
  ReelInstagramCubit(this._getInstagramReelsUseCase)
      : super(const ReelInstagramState());

  final GetInstagramReelsUseCase _getInstagramReelsUseCase;

  Future<void> getReels() async {
    emit(state.copyWith(status: ReelInstagramStatus.loading));
    final result = await _getInstagramReelsUseCase.call(
      TwitterFeedParams(page: 1, limit: 30),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ReelInstagramStatus.failure,
          failure: failure,
        ),
      ),
      (reels) => emit(
        state.copyWith(
          status: ReelInstagramStatus.success,
          reels: reels.reelsData,
        ),
      ),
    );
  }
}
