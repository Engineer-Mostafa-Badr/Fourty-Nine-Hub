import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/change_react.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/react_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/block_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_friend_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/edit_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/face_advertisement_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/face_tweet_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/follow_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/friend_request_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comment_replies_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/hide_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/remove_friend_request_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/remove_suggest_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/send_greet_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/share_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/un_follow_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/user_profile_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
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
  final DeleteCommentUseCase _deleteCommentUseCase;
  final HidePostUseCase _hidePostUseCase;
  final SuggestedFriendsUseCase _suggestedFriendsUseCase;
  final FriedRequestUseCase _friedRequestUseCase;
  final FollowUserUseCase _followUserUseCase;
  final UnFollowUserUseCase _unFollowUserUseCase;
  final SendGreetMessageUseCase _sendGreetMessageUseCase;
  final RemoveSuggestUserUseCase _removeSuggestUserUseCase;
  final SharePostUseCase _sharePostUseCase;
  final CommentReactUseCase _commentReactUseCase;
  final GetPostCommentRepliesUseCase _getPostCommentRepliesUseCase;
  final ReplyOnCommentUseCase _replyOnCommentUseCase;
  final FaceTweetUseCase _getTwitterFeedUseCase;
  final FaceAdvertisementUseCase _advertisementUseCase;
  final GetPostUseCase _getPostUseCase;
  final UserProfileUseCase _userProfileUseCase;
  final RemoveFriedRequestUseCase _removeFriedRequestUseCase;
  final BlocUserUseCase _blocUserUseCase;
  final EditCommentUseCase _editCommentUseCase;
  final AcceptRejectFriendRequestUseCase _acceptRejectFriendRequestUseCase;
  final DeleteFriendUseCase _deleteFriendUseCase;

  SocialPostsCubit(
    this._getFeedUseCase,
    this._getUserPostsUseCase,
    this._postReactUseCase,
    this._getPostCommentsUseCase,
    this._postCommentUseCase,
    this._deletePostUseCase,
    this._hidePostUseCase,
    this._suggestedFriendsUseCase,
    this._friedRequestUseCase,
    this._followUserUseCase,
    this._sendGreetMessageUseCase,
    this._removeSuggestUserUseCase,
    this._sharePostUseCase,
    this._commentReactUseCase,
    this._getPostCommentRepliesUseCase,
    this._replyOnCommentUseCase,
    this._getTwitterFeedUseCase,
    this._advertisementUseCase,
    this._getPostUseCase,
    this._deleteCommentUseCase,
    this._userProfileUseCase,
    this._unFollowUserUseCase,
    this._removeFriedRequestUseCase,
    this._blocUserUseCase,
    this._editCommentUseCase, this._acceptRejectFriendRequestUseCase, this._deleteFriendUseCase,
  ) : super(const SocialPostsState());

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

  void loadComments(BuildContext context, String postId) async {
    await getPostComments(context: context, postId: postId, page: 1);
    commentsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPostComments(context: context, postId: postId, page: pageKey);
    });
  }

  void loadReplies(BuildContext context, String commentId) async {
    await getCommentReplies(context: context, commentId: commentId, page: 1);
    commentsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getCommentReplies(context: context, commentId: commentId, page: pageKey);
    });
  }

  void loadPostDetails(BuildContext context, String postId) async {
    await getPostDetails(postId);
    await getPostComments(context: context, postId: postId, page: 1);
    commentsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPostComments(context: context, postId: postId, page: pageKey);
    });
  }

  void onRefresh() async {
    emit(state.copyWith(
        tweetPage: 0, suggestedFriends: [], advertisementsPage: 0));
    feedPagingController.refresh();
    suggestUserPagingController.refresh();
  }

  void onRefreshPostDetails() async {
    emit(state.copyWith(status: StateStatus.loading));
    commentsPagingController.refresh();
  }

  void refreshPosts(List<PostEntity>? posts) {
    feedPagingController.refresh();
  }

  void loadUserPosts(String userId) async {
    await getMyPosts(1, userId);
    userPostsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getMyPosts(pageKey, userId);
    });
  }

  void refreshUserPosts() {
    userPostsPagingController.refresh();
  }

// get feed posts
  Future<void> getFeed(int page) async {
    final response =
        await _getFeedUseCase(TwitterFeedParams(limit: 3, page: page));
    List<PostEntity> tweets = [];
    List<PostEntity> advertisements = [];
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) async {
      if (data.isNotEmpty) {
        tweets = await getTwitterFeed();
        advertisements = await getAdvertisements();
      }
      List<PostEntity> totalPosts = [];
      totalPosts.addAll(data);
      totalPosts.addAll(tweets);
      totalPosts.addAll(advertisements);
      final isLastPage = totalPosts.length < (3);
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

// get feed posts
  Future<void> getPostDetails(String postId) async {
    emit(state.copyWith(status: StateStatus.loading));
    final response = await _getPostUseCase(postId);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) async {
      emit(state.copyWith(postDetails: data, status: StateStatus.initial));
    });
  }

  // get advertisements
  Future<List<PostEntity>> getAdvertisements() async {
    final response = await _advertisementUseCase(
        TwitterFeedParams(limit: 1, page: state.advertisementsPage! + 1));
    List<PostEntity> advertisements = [];
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      advertisements.addAll(data);
      int? page = state.advertisementsPage! + 1;
      emit(state.copyWith(
          advertisementsPage: page, posts: data, status: StateStatus.success));
    });
    print("advertisements:${advertisements.length}");
    return advertisements;
  }

  Future<List<PostEntity>> getTwitterFeed() async {
    final response = await _getTwitterFeedUseCase(
        TwitterFeedParams(limit: 1, page: state.tweetPage! + 1));
    List<PostEntity> tweets = [];
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      tweets.addAll(data);
      int? page = state.tweetPage! + 1;
      emit(state.copyWith(
          tweetPage: page, posts: data, status: StateStatus.success));
    });
    print("tweets:${tweets.length}");
    return tweets;
  }

  final int pageSize = 10;
  final PagingController<int, SuggestUserEntity> suggestUserPagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, PostEntity> feedPagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, PostEntity> userPostsPagingController =
      PagingController(firstPageKey: 1);
  // get suggested friends
  Future<void> getSuggestedFriends(int page) async {
    if (page != 4) {
      final response = await _suggestedFriendsUseCase(
          SuggestedFriendsParams(limit: pageSize, page: page));
      response.fold(
          (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
          (data) {
        final isLastPage = data.length < pageSize||page==3;
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
        emit(state.copyWith(
            suggestedFriends: data, status: StateStatus.initial));
        print("suggestLength${state.suggestedFriends?.length}");
      });
    }
  }

  // get feed posts
  Future<void> getMyPosts(int page, String userId) async {
    // final user = context.read<UserCubit>().state.data;
    final response = await _getUserPostsUseCase(
        UserPostsParams(page: page, limit: pageSize, userId: userId));
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        userPostsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        userPostsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        userPostsPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copyWith(myPosts: data, status: StateStatus.success));
    });
  }

  // get user profile
  Future<void> getUserProfile({required String id}) async {
    emit(state.copyWith(status: StateStatus.loading));
    final response = await _userProfileUseCase(id);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) => emit(
            state.copyWith(profileData: data, status: StateStatus.success)));
  }

  void changeUserPage(int page) {
    emit(state.copyWith(profilePage: page, status: StateStatus.success));
  }

// react on a post
  Future<bool> onReact(
      {required PostReactParams params, required String from}) async {
    var response = await _postReactUseCase(params);
    bool value = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (r) {
      if (from == 'details') {
        // changeReaction(state.postDetails, params.react);
      } else if (from == 'userPosts') {
        var currentUserPost = userPostsPagingController.itemList
            ?.firstWhere((element) => element.id == params.postId);
        changeReaction(currentUserPost, params.react);
      } else {
        var currentPost = feedPagingController.itemList
            ?.firstWhere((element) => element.id == params.postId);
        changeReaction(currentPost, params.react);
        changeReaction(state.postDetails, params.react);
        // changeReaction(currentUserPost, params.react);
      }
      value = r;
      emit(state.copyWith(status: StateStatus.success));
    });
    return value;
  }

  // react on a comment
  Future<bool> onCommentReact({required PostReactParams params}) async {
    var response = await _commentReactUseCase(params);
    bool value = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (r) {
      print(params.postId);
      var currentComment = commentsPagingController.itemList
          ?.firstWhere((element) => element.id == params.postId);
      var currentReply = repliesPagingController.itemList
          ?.firstWhere((element) => element.id == params.postId);
      changeReaction(currentComment, params.react);
      changeReaction(currentReply, params.react);
      value = r;
    });
    return value;
  }

  // edit on a comment
  Future<bool> editComment({required PostCommentParams params}) async {
    var response = await _editCommentUseCase(params);
    bool value = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (r) {
      value = r;
    });
    return value;
  }

  // acceptRejectFriend
  Future<bool> acceptRejectFriend({required AcceptRejectFriendRequestParams params}) async {
    var response = await _acceptRejectFriendRequestUseCase(params);
    bool value = false;
    response.fold(
            (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
            (r) {
          value = r;
        });
    return value;
  }

  // Delete Friend
  Future<bool> deleteFriend({required String userId}) async {
    var response = await _deleteFriendUseCase(userId);
    bool value = false;
    response.fold(
            (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
            (r) {
          value = r;
        });
    return value;
  }

// add comment
  Future<CommentEntity> onPostComment(
      {required PostCommentParams params, required String from}) async {
    var response = await _postCommentUseCase(params);
    CommentEntity? model;
    response.fold(
        (failure) => emit(
              state.copyWith(failure: failure, status: StateStatus.error),
            ), (data) {
      model = data;
      if (from == 'feed') {
        print(feedPagingController.itemList!.length);
        var currentPost = feedPagingController.itemList
            ?.firstWhere((element) => element.id == params.postId);
        print("comment count${currentPost?.commentsCount}");

        currentPost?.commentsCount = (currentPost.commentsCount! + 1);
      }
      emit(state.copyWith(status: StateStatus.success));
    });
    return model!;
  }

  // add reply
  Future<CommentEntity> replyOnComment(
      {required ReplyOnCommentParams params, required String from}) async {
    var response = await _replyOnCommentUseCase(params);
    CommentEntity? model;
    response.fold(
        (failure) => emit(
              state.copyWith(failure: failure, status: StateStatus.error),
            ), (data) {
      model = data;
      if (from == 'feed') {
        var currentPost = feedPagingController.itemList
            ?.firstWhere((element) => element.id == params.postId);
        print("commmmmment count${currentPost?.commentsCount}");

        currentPost?.commentsCount = (currentPost.commentsCount! + 1);
      }

      emit(state.copyWith(newComment: data, status: StateStatus.success));
    });
    return model!;
  }

  // show comments with rendered data

  final PagingController<int, CommentEntity> commentsPagingController =
      PagingController(firstPageKey: 1);

  Future<void> getPostComments(
      {required BuildContext context,
      required String postId,
      required int page}) async {
    final response = await _getPostCommentsUseCase(
      PostCommentsParams(
        page: page,
        limit: pageSize,
        postId: postId,
      ),
    );
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        commentsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        commentsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        commentsPagingController.appendPage(data, nextPageKey);
      }
      emit(
        state.copyWith(
          postComments: data,
          status: StateStatus.success,
        ),
      );
    });
  }

  final PagingController<int, CommentEntity> repliesPagingController =
      PagingController(firstPageKey: 1);
  Future<void> getCommentReplies(
      {required BuildContext context,
      required String commentId,
      required int page}) async {
    final response = await _getPostCommentRepliesUseCase(
      PostCommentsParams(
        page: page,
        limit: pageSize,
        postId: commentId,
      ),
    );
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        repliesPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        repliesPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        repliesPagingController.appendPage(data, nextPageKey);
      }
      emit(
        state.copyWith(
          status: StateStatus.success,
        ),
      );
    });
  }

  Future<void> deletePost(
      {required BuildContext context, required String postId}) async {
    final response = await _deletePostUseCase(postId);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      feedPagingController.itemList?.removeWhere((e) => e.id == postId);
      emit(state.copyWith(posts: feedPagingController.itemList));
      showSuccessMessage(context, "Post delete successfully");
    });
  }

  Future<bool> deleteComment(
      {required BuildContext context,
      required String commentId,
      required String postId,
      required String from}) async {
    final response = await _deleteCommentUseCase(commentId);
    bool result = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      result = r;
      if (from == 'feed') {
        var currentPost = feedPagingController.itemList
            ?.firstWhere((element) => element.id == postId);
        print("commmmmment count${currentPost?.commentsCount}");

        currentPost?.commentsCount = (currentPost.commentsCount! - 1);
      } else {
        if (state.postDetails != null) {
          state.postDetails?.commentsCount =
              (state.postDetails!.commentsCount! - 1);
        }
      }
      emit(state.copyWith(status: StateStatus.success));
      showSuccessMessage(context, "Comment delete successfully");
    });
    return result;
  }

  Future<void> hidePost(
      {required BuildContext context, required String postId}) async {
    final response = await _hidePostUseCase(postId);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      feedPagingController.itemList?.removeWhere((e) => e.id == postId);
      emit(state.copyWith(posts: feedPagingController.itemList));
      showSuccessMessage(context, "Post hide successfully");
    });
  }

  Future<bool> friendRequest(
      {required BuildContext context, required String userId}) async {
    final response = await _friedRequestUseCase(userId);
    bool isAdd = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      isAdd = r;
      emit(state.copyWith(friendRequest: r, status: StateStatus.success));
    });
    return isAdd;
  }

  Future<bool> removeFriendRequest(
      {required BuildContext context, required String userId}) async {
    final response = await _removeFriedRequestUseCase(userId);
    bool isRemoved = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      isRemoved = r;
      emit(state.copyWith(friendRequest: r, status: StateStatus.success));
    });
    return isRemoved;
  }

  Future<bool> blockUser(
      {required BuildContext context, required String userId}) async {
    final response = await _blocUserUseCase(userId);
    bool isBlocked = false;
    response.fold((l) {
      print("isBlocked$isBlocked");
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (r) {
      print("objectRight");
      isBlocked = r;
      print("isBlocked$isBlocked");
      emit(state.copyWith(status: StateStatus.success));
    });
    return isBlocked;
  }

  Future<bool> followRequest(
      {required BuildContext context, required String userId}) async {
    final response = await _followUserUseCase(userId);
    bool isFollow = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      isFollow = r;
      emit(state.copyWith(friendRequest: r, status: StateStatus.success));
    });
    return isFollow;
  }

  Future<bool> unFollowRequest(
      {required BuildContext context, required String userId}) async {
    final response = await _unFollowUserUseCase(userId);
    bool unFollow = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      unFollow = r;
      emit(state.copyWith(status: StateStatus.success));
    });
    return unFollow;
  }

  Future<bool> sendGreetMessage(
      {required BuildContext context,
      required String userId,
      required String message}) async {
    final response = await _sendGreetMessageUseCase(SendGreetMessageParams(
      userId: userId,
      message: message,
    ));
    bool isAdd = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      print("object $r}");
      isAdd = r;
      emit(state.copyWith(friendRequest: r, status: StateStatus.success));
    });
    print(isAdd);
    return isAdd;
  }

  Future<bool> removeSuggestUser(
      {required BuildContext context, required String userId}) async {
    final response = await _removeSuggestUserUseCase(userId);
    bool isAdd = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      print("object $r}");
      isAdd = r;
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
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      value = data;
      emit(state.copyWith(status: StateStatus.success));
    });
    return value;
  }

  List<ReactEntity> reacts = [
    ReactEntity(
      image: Assets.wowReaction,
      react: 'wow',
    ),
    ReactEntity(
      image: Assets.loveReaction,
      react: 'love',
    ),
    ReactEntity(
      image: Assets.sadReaction,
      react: 'sad',
    ),
    ReactEntity(
      image: Assets.angryReaction,
      react: 'angry',
    ),
    ReactEntity(
      image: Assets.hahaReaction,
      react: 'haha',
    ),
    ReactEntity(
      image: Assets.likeReaction,
      react: 'likes',
    ),
  ];

  void triggerBlock() {}
}
