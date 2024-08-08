import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/face_advertisement_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/face_tweet_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/follow_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/friend_request_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comment_replies_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/hide_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/remove_suggest_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/send_greet_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/share_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/post_details_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/comment_replies.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/post_comments.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/enums/base_status_enum.dart';
import '../../domain/entities/post_entity.dart';

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
  final DeletePostUseCase _deletePostUseCase;
  final HidePostUseCase _hidePostUseCase;
  final SuggestedFriendsUseCase _suggestedFriendsUseCase;
  final FriedRequestUseCase _friedRequestUseCase;
  final FollowUserUseCase _followUserUseCase;
  final SendGreetMessageUseCase _sendGreetMessageUseCase;
  final RemoveSuggestUserUseCase _removeSuggestUserUseCase;
  final SharePostUseCase _sharePostUseCase;
  final CommentReactUseCase _commentReactUseCase;
  final GetPostCommentRepliesUseCase _getPostCommentRepliesUseCase;
  final ReplyOnCommentUseCase _replyOnCommentUseCase;
  final FaceTweetUseCase _getTwitterFeedUseCase;
  final FaceAdvertisementUseCase _advertisementUseCase;

  SocialPostsCubit(
      this._getFeedUseCase,
      this._getUserPostsUseCase,
      this._postReactUseCase,
      this._getPostCommentsUseCase,
      this._postCommentUseCase,
      this._deletePostUseCase,
      this._hidePostUseCase, this._suggestedFriendsUseCase, this._friedRequestUseCase, this._followUserUseCase, this._sendGreetMessageUseCase, this._removeSuggestUserUseCase, this._sharePostUseCase, this._commentReactUseCase, this._getPostCommentRepliesUseCase, this._replyOnCommentUseCase, this._getTwitterFeedUseCase, this._advertisementUseCase,)
      : super(const SocialPostsState());

  void loadData() async {
    await getFeed(1);
    feedPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getFeed(pageKey);
    });
    await getSuggestedFriends(1);
    suggestUserPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getSuggestedFriends(pageKey);
    });
  }


  void onRefresh()async{
    emit(state.copyWith(tweetPage:0,advertisementsPage:0));
    feedPagingController.refresh();
  }



// get feed posts
  Future<void> getFeed(int page) async {
    final response = await _getFeedUseCase(TwitterFeedParams(limit: 3, page: page));
    List<PostEntity> tweets=[];
    List<PostEntity> advertisements=[];
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) async{
          if(data.isNotEmpty){
            tweets = await getTwitterFeed();
            advertisements = await getAdvertisements();
          }
          List<PostEntity> totalPosts=[];
          totalPosts.addAll(data);
          totalPosts.addAll(tweets);
          totalPosts.addAll(advertisements);
          final isLastPage = totalPosts.length < (4);
          if (page == 1) {
            print("page == 1 $page");
            feedPagingController.itemList = [];
          }
          if (isLastPage) {
            print("isLastPage = $isLastPage");
            feedPagingController.appendLastPage(totalPosts);
          } else {
            print("isNotLastPage = $isLastPage");
            final nextPageKey = page + 1;
            feedPagingController.appendPage(totalPosts, nextPageKey);
          }
          emit(state.copyWith(posts: totalPosts, status: StateStatus.initial));
        });
  }

  // get advertisements
  Future<List<PostEntity>> getAdvertisements() async {
    final response =
    await _advertisementUseCase(TwitterFeedParams(limit: 1, page: state.advertisementsPage!+1));
    List<PostEntity> advertisements=[];
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) {
          advertisements.addAll(data);
          int? page = state.advertisementsPage!+1;
          emit(state.copyWith(advertisementsPage: page,posts: data, status: StateStatus.success));
        });
    print("advertisements:${advertisements.length}");
    return advertisements;
  }

  Future<List<PostEntity>> getTwitterFeed() async {
    final response =
    await _getTwitterFeedUseCase(TwitterFeedParams(limit: 1, page: state.tweetPage!+1));
    List<PostEntity> tweets=[];
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) {
              tweets.addAll(data);
              int? page = state.tweetPage!+1;
          emit(state.copyWith(tweetPage: page,posts: data, status: StateStatus.success));
        });
    print("tweets:${tweets.length}");
    return tweets;
  }
  final int pageSize = 10;
  final PagingController<int, SuggestUserEntity> suggestUserPagingController =
  PagingController(firstPageKey: 1);
  final PagingController<int, PostEntity> feedPagingController =
  PagingController(firstPageKey: 1);
  // get suggested friends
  Future<void> getSuggestedFriends(int page) async {
    final response = await _suggestedFriendsUseCase(SuggestedFriendsParams(limit: pageSize, page: page));
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) {
              final isLastPage = data.length < pageSize;
              if (page == 1) {
                print("page == 1 $page");
                suggestUserPagingController.itemList = [];
              }
              if (isLastPage) {
                print("isLastPage = $isLastPage");
                suggestUserPagingController.appendLastPage(data);
              } else {
                print("isNotLastPage = $isLastPage");
                final nextPageKey = page + 1;
                suggestUserPagingController.appendPage(data, nextPageKey);
              }
              emit(state.copyWith(suggestedFriends: data, status: StateStatus.initial));
            });
  }

  // get feed posts
  Future<void> getMyPosts({required BuildContext context}) async {
    final user = context.read<UserCubit>().state.data;
    if (user != null) {
      final response = await _getUserPostsUseCase(user.id);
      response.fold(
          (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
          (data) =>
              emit(state.copyWith(myPosts: data, status: StateStatus.initial)));
    }
  }

// react on a post
  Future<bool> onReact({required PostReactParams params}) async {
    var response =await _postReactUseCase(params);
    bool value = false;
    response.fold(
          (failure) =>
          emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (r){
          value=r;
        }
    );
    return value;

  }

  // react on a comment
  Future<bool> onCommentReact({required PostReactParams params}) async {
    var response =await _commentReactUseCase(params);
    bool value = false;
    response.fold(
          (failure) =>
          emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (r){
          value=r;
        }
    );
    return value;

  }

// add comment usecase
  Future<CommentEntity> onPostComment({required PostCommentParams params}) async {
    var response = await _postCommentUseCase(params);
    CommentEntity? model;
    response.fold((failure)=>emit(state.copyWith(failure: failure,status: StateStatus.error),),
        (data){
      model=data;
      emit(state.copyWith(newComment: data,status: StateStatus.success));
        }
    );
    return model!;
  }

  // add comment usecase
  Future<CommentEntity> replyOnComment({required ReplyOnCommentParams params}) async {
    var response = await _replyOnCommentUseCase(params);
    CommentEntity? model;
    response.fold((failure)=>emit(state.copyWith(failure: failure,status: StateStatus.error),),
        (data){
      model=data;
      emit(state.copyWith(newComment: data,status: StateStatus.success));
        }
    );
    return model!;
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
            isScrollControlled: true,
            widget: PostComments(
                comments: data,
                postId: postId,
                onAddComment: (PostCommentParams params) =>
                    onPostComment(params: params))));
  }


  // show comments with rendered data

  void showPostCommentReplies(
      {required BuildContext context, required String commentId,required String postId}) async {
    final response = await _getPostCommentRepliesUseCase(commentId);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) => bottomSheet(
            context: context,
            isScrollControlled: true,
            widget: CommentReplies(
                replies: data,
                postId: postId, commentId: commentId, onAddReply: (ReplyOnCommentParams params) {
                  replyOnComment(params: params);
            },
                )));
  }

  void showPostDetails(
      {required BuildContext context, required PostEntity post}) async {
    final response = await _getPostCommentsUseCase(post.id);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) => bottomSheet(
            context: context,
            isScrollControlled: true,
            widget: PostDetailsPage(
              comments: data,
              post: post,
              deletePost: (String postId) =>
                  deletePost(context: context, postId: postId),
              hidePost: (String postId) =>
                  hidePost(context: context, postId: postId),
              onAddComment: (PostCommentParams params) =>
                  onPostComment(params: params),
              onReact: (params) => onReact(params: params),
              showPostComments: (postId) =>
                  showPostComments(context: context, postId: postId),
              showPostDetails: (PostEntity post) =>
                  showPostDetails(context: context, post: post),
            )));
  }

  void deletePost(
      {required BuildContext context, required String postId}) async {
    final response = await _deletePostUseCase(postId);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
          List<PostEntity> posts = state.posts!;
          posts.removeWhere((e)=>e.id==postId);
      // state.posts?.removeWhere((e)=>e.id==postId);
          emit(state.copyWith(posts: posts));
          showSuccessMessage(context, "Post delete successfully");
    });
  }

  void hidePost({required BuildContext context, required String postId}) async {
    final response = await _hidePostUseCase(postId);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
          List<PostEntity> posts = state.posts!;
          posts.removeWhere((e)=>e.id==postId);
          emit(state.copyWith(posts: posts));
          showSuccessMessage(context, "Post hide successfully");
      // getMyPosts(context: context);
    });
  }

  Future<bool> friendRequest({required BuildContext context, required String userId}) async {
    final response = await _friedRequestUseCase(userId);
    bool isAdd = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      // getMyPosts(context: context);
          print("object $r}");
          isAdd=r;
          emit(state.copyWith(friendRequest: r, status: StateStatus.success));
    });
    print(isAdd);
    return isAdd;
  }

  Future<bool> followRequest({required BuildContext context, required String userId}) async {
    final response = await _followUserUseCase(userId);
    bool isAdd = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
          print("object $r}");
          isAdd=r;
          emit(state.copyWith(friendRequest: r, status: StateStatus.success));
    });
    print(isAdd);
    return isAdd;
  }

  Future<bool> sendGreetMessage({required BuildContext context, required String userId}) async {
    final response = await _sendGreetMessageUseCase(userId);
    bool isAdd = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
          print("object $r}");
          isAdd=r;
          emit(state.copyWith(friendRequest: r, status: StateStatus.success));
    });
    print(isAdd);
    return isAdd;
  }

  Future<bool> removeSuggestUser({required BuildContext context, required String userId}) async {
    final response = await _removeSuggestUserUseCase(userId);
    bool isAdd = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
          print("object $r}");
          isAdd=r;
          emit(state.copyWith(status: StateStatus.success));
    });
    print(isAdd);
    return isAdd;
  }

  // share post
  Future<bool> onShare({required String postId}) async {
    var response = await _sharePostUseCase(postId);
    var value = false;
    response.fold(
            (failure) => emit(state.copyWith(failure: failure, status: StateStatus.error)),
            (data) {
              value=data;
              emit(
            state.copyWith(status: StateStatus.success));
            });
    return value;
  }

}
