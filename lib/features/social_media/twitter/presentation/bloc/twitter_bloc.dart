import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_post_comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/share_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_post_details.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_comment_replied.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_comments.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'twitter_state.dart';

class TwitterCubit extends Cubit<TwitterState> {
  final GetTwitterFeedUseCase _getFeedUseCase;
  final TwitterPostReactUseCase _twitterPostReactUseCase;
  final GetTwitterPostCommentsUseCase _getTwitterPostCommentsUseCase;
  final TwitterCommentReactUseCase _twitterCommentReactUseCase;
  final TwitterSharePostUseCase _twitterSharePostUseCase;
  final TwitterPostCommentUseCase _twitterPostCommentUseCase;
  final TwitterCommentReplyUseCase _twitterCommentReplyUseCase;
  final GetTwitterCommentRepliesUseCase _twitterCommentRepliesUseCase;
  final GetTwitterPostUseCase _getTwitterPostUseCase;

  TwitterCubit(
    this._getFeedUseCase,
    this._twitterPostReactUseCase,
    this._getTwitterPostCommentsUseCase,
    this._twitterCommentReactUseCase,
    this._twitterSharePostUseCase,
    this._twitterPostCommentUseCase,
    this._twitterCommentReplyUseCase,
    this._twitterCommentRepliesUseCase, this._getTwitterPostUseCase,
  ) : super(const TwitterState());

  void loadData() async {
    //   await getFeed(1);
    getFeed(1);
    postsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getFeed(pageKey);
    });
  }

  final int reactCount = 0;

  final int pageSize = 10;
  final PagingController<int, TwitterPostEntity> postsPagingController =
      PagingController(firstPageKey: 1);
// get feed posts
  Future<void> getFeed(int page) async {
    final response =
        await _getFeedUseCase(TwitterFeedParams(limit: pageSize, page: page));
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        postsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        postsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        postsPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copyWith(posts: data, status: StateStatus.success));
    });
  }


  Future<void> getTwitterPost(BuildContext context,String postId) async {
    final response =
    await _getTwitterPostUseCase(postId);
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) {

              bottomSheet(
                  context: context,
                  isScrollControlled: true,
                  widget: TwitterPostDetails(post: data, onReact: (){
                    onReact(params: TwitterPostReactParams(postId: postId,react: 'love',),);
                  },onShare: (){
                    onShare(postId: postId);
                  },showPostComments: (id){
                    showPostComments(context: context, postId: postId);
                  },));
        });
  }

  // react on a post
  void onReact({required TwitterPostReactParams params}) async {
    await _twitterPostReactUseCase(params);
  }

  // share post
  void onShare({required String postId}) async {
    var response = await _twitterSharePostUseCase(postId);
    response.fold((failure)=>emit(state.copyWith(shareSuccess: false,failure: failure,status: StateStatus.error)),
            (data)=>emit(state.copyWith(shareSuccess: true,status: StateStatus.success)));

  }

  // react on a comment
  void onCommentReact({required TwitterCommentReactParams params}) async {
    await _twitterCommentReactUseCase(params);
  }

  // String getDifference(DateTime createdAt) {
  //   DateTime now = DateTime.now();
  //   Duration difference = now.difference(createdAt);
  //
  //   if (difference.inDays == 0) {
  //     if (difference.inHours == 0) {
  //       return "${difference.inMinutes}min";
  //     } else {
  //       return "${difference.inHours}h";
  //     }
  //   } else if (difference.inDays < 7) {
  //     return "${difference.inDays}h";
  //   } else if (difference.inDays < 30) {
  //     int weeks = (difference.inDays / 7).floor();
  //     return "$weeks w";
  //   } else if (difference.inDays < 365) {
  //     int months = (difference.inDays / 30).floor();
  //     return "$months months";
  //   } else {
  //     int years = (difference.inDays / 365).floor();
  //     return "$years years";
  //   }
  // }

  void showPostComments(
      {required BuildContext context, required String postId}) async {
    final response = await _getTwitterPostCommentsUseCase(postId);
    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: StateStatus.error)),
      // (data) => emit(state.copyWith(posts: data, status: StateStatus.success));
      (data) => bottomSheet(
        context: context,
        isScrollControlled: true,
        widget: TwitterPostComments(
          comments: data,
          postId: postId,
          onAddComment: (PostCommentParams params) =>
              onPostComment(params: params),
          onAddReply: (TwitterCommentReplyParams params) {
            onCommentReply(params: params);
          },
          onCommentReact: (TwitterCommentReactParams params){
            onCommentReact(params: params);
          },
          onGetReplies: (String id, TwitterPostCommentEntity comment) async {
            getCommentReplies(
              context: context,
              commentId: id,
              comment: comment,
            );
          },
        ),
      ),
    );
  }

  List<TwitterCommentReplyEntity> replies = [];
  getCommentReplies(
      {required BuildContext context,
      required String commentId,
      required TwitterPostCommentEntity comment}) async {
    final response = await _twitterCommentRepliesUseCase(commentId);
    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: StateStatus.error)),
      (data) => bottomSheet(
        context: context,
        isScrollControlled: true,
        widget: TwitterCommentReplies(
          replies: data,
          onAddReply: (TwitterCommentReplyParams params) {
            onCommentReply(params: params);
          },
          commentId: commentId,
        ),
      ),
    );
  }

  // add comment usecase
  void onPostComment({required PostCommentParams params}) async {
    await _twitterPostCommentUseCase(params);
  }

  // add comment reply usecase
  void onCommentReply({required TwitterCommentReplyParams params}) async {
    await _twitterCommentReplyUseCase(params);
  }

  showReplies(TwitterPostCommentEntity comment) {
    emit(ShowRepliesLoadingState());
    comment.showReplies = !comment.showReplies;
    emit(ShowRepliesSuccessState());
  }
}
