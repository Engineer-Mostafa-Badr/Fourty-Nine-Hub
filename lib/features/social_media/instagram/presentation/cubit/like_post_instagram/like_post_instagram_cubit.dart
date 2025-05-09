import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/like_post_instagram_use_case.dart';

part 'like_post_instagram_state.dart';

class LikePostInstagramCubit extends Cubit<LikePostInstagramState> {
  LikePostInstagramCubit(this._likePostInstagramUseCase)
      : super(LikePostInstagramState(status: LikePostInstagramStatus.initial));
  final LikePostInstagramUseCase _likePostInstagramUseCase;

  Future<void> likePostInstagram(String postId, int likeCount) async {
    emit(state.copyWith(status: LikePostInstagramStatus.loading));
    final result = await _likePostInstagramUseCase(
      LikePostInstagramParams(
        postId: postId,
      ),
    );
    print('likeCount $likeCount');
    result.fold(
        (l) => emit(state.copyWith(status: LikePostInstagramStatus.failure)),
        (r) {
          if (r) {
            likeCount++;
          } else {
            likeCount;
          }
      emit(
        state.copyWith(
          status: LikePostInstagramStatus.success,
          isLike: r,
          likeCount: likeCount,
        ),
      );
    });
    print('likeCount $likeCount');
  }
}
