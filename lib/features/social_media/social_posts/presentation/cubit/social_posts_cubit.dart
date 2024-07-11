import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/post_comments.dart';

import '../../../../../core/enums/base_status_enum.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/social_posts_repo.dart';
import '../../domain/usecases/get_feed_usecase.dart';
import '../../domain/usecases/get_post_comments_usecase.dart';
import '../../domain/usecases/get_user_posts_usecase.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/post_react_usecase.dart';

part 'social_posts_state.dart';

class SocialPostsCubit extends Cubit<SocialPostsState> {
  final GetFeedUseCase _getFeedUseCase;
  final GetUserPostsUseCase _getUserPostsUseCase;
  final PostReactUseCase _postReactUseCase;
  final GetPostCommentsUseCase _getPostCommentsUseCase;
  final PostCommentUseCase _postCommentUseCase;
  SocialPostsCubit(
      this._getFeedUseCase,
      this._getUserPostsUseCase,
      this._postReactUseCase,
      this._getPostCommentsUseCase,
      this._postCommentUseCase)
      : super(const SocialPostsState());

  void loadData() async {
    await getFeed();
  }

// get feed posts
  Future<void> getFeed() async {
    final response = await _getFeedUseCase(const NoParams());
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) =>
            emit(state.copyWith(posts: data, status: StateStatus.initial)));
  }

// react on a post
  void onReact({required PostReactParams params}) async {
    await _postReactUseCase(params);
  }

// add comment usecase
  void onPostComment({required PostCommentParams params}) async {
    await _postCommentUseCase(params);
  }

  // show comments with rendered data

  void showPostComments(
      {required BuildContext context, required String postId}) async {
    final response = await _getPostCommentsUseCase(postId);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) => bottomSheet(
            context: context,
            widget: PostComments(
                comments: data,
                onAddComment: (PostCommentParams params) =>
                    onPostComment(params: params))));
  }
}
