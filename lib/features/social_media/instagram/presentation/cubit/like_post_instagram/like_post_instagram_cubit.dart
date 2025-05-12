import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/like_post_instagram_use_case.dart';

part 'like_post_instagram_state.dart';

class LikePostInstagramCubit extends Cubit<LikePostInstagramState> {
  LikePostInstagramCubit(this._likePostInstagramUseCase)
      : super(LikePostInstagramState(status: LikePostInstagramStatus.initial));
  final LikePostInstagramUseCase _likePostInstagramUseCase;

  Future<void> fetchLikePostInstagram(bool isLiked, int likeCount) async {
    print('likeCount $likeCount');
    print('isLiked $isLiked');
    emit(
      state.copyWith(
        isLike: isLiked,
        likeCount: likeCount,
      ),
    );
  }

  Future<void> likePostInstagram(
      String postId, int likeCount, bool isLiked) async {
    emit(state.copyWith(status: LikePostInstagramStatus.loading));
    final result = await _likePostInstagramUseCase(
      LikePostInstagramParams(
        postId: postId,
      ),
    );
    print('likeCount $likeCount');
    result.fold(
        (l) => emit(state.copyWith(status: LikePostInstagramStatus.failure)),
        (likeStatus) {
      int newLikeCount = state.likeCount ?? likeCount;
      if (state.isLike ?? isLiked && !likeStatus) {
        newLikeCount--;
      } else if (!(state.isLike ?? isLiked) && likeStatus) {
        newLikeCount++;
      }
      emit(
        state.copyWith(
          status: LikePostInstagramStatus.success,
          isLike: likeStatus,
          likeCount: newLikeCount,
        ),
      );
    });
    print('likeCount ${state.likeCount}');
  }
}
