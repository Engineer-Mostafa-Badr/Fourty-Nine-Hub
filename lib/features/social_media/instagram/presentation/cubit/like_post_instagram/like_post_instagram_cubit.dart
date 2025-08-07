import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/instagram_post_entity.dart';
import '../../../domain/usecases/like_post_instagram_use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'like_post_instagram_state.dart';

class LikePostInstagramCubit extends Cubit<LikePostInstagramState> {
  LikePostInstagramCubit(this._likePostInstagramUseCase)
      : super(LikePostInstagramState(status: LikePostInstagramStatus.initial));
  final LikePostInstagramUseCase _likePostInstagramUseCase;

  Future<void> fetchLikePostInstagram(
      List<InstagramPostEntity> posts, int currentPost) async {
    emit(
      state.copyWith(
        posts: posts,
        currentPost: currentPost,
      ),
    );
  }

  Future<void> likePostInstagram(
    String postId,
    int likeCount,
    bool isLiked,
    int currentPost,
  ) async {
    emit(state.copyWith(status: LikePostInstagramStatus.loading));

    print("postId $postId");
    print("currentPost $currentPost");
    print("state.posts ${state.posts}");
    final result = await _likePostInstagramUseCase(
      LikePostInstagramParams(postId: postId),
    );

    result.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
         emit(state.copyWith(status: LikePostInstagramStatus.failure));},
      (likeStatus) {
        final List<InstagramPostEntity> updatedPosts = List.from(state.posts!);
        InstagramPostEntity currentPostEntity = updatedPosts[currentPost];

        int updatedLikeCount = currentPostEntity.likesCounter;

        if (isLiked && !likeStatus) {
          updatedLikeCount--;
        } else if (!isLiked && likeStatus) {
          updatedLikeCount++;
        }

        updatedPosts[currentPost] = currentPostEntity.copyWith(
          isLiked: likeStatus,
          likesCounter: updatedLikeCount,
        );

        print('likesCounter:: ${updatedPosts[currentPost].likesCounter}');
        emit(
          state.copyWith(
            status: LikePostInstagramStatus.success,
            posts: updatedPosts,
            // isLike: likeStatus,
            // likeCount: updatedLikeCount,
          ),
        );
      },
    );
  }
}
