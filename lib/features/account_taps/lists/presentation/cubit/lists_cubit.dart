import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_blocked_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_followers_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_friend_requests_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_friends_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/block_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_friend_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/un_follow_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../core/error/failure.dart';

part 'lists_state.dart';

class ListsCubit extends Cubit<ListsState> {
  final GetFriendRequestsUsecase _getFriendRequestsUsecase;
  final GetBlockedUseCase _getBlockedUseCase;
  final GetFriendsUsecase _getFriendsUsecase;
  final GetFollowersUseCase _getFollowersUseCase;
  final BlocUserUseCase _blocUserUseCase;
  final DeleteFriendUseCase _deleteFriendUseCase;
  final AcceptRejectFriendRequestUseCase _acceptRejectFriendRequestUseCase;
  final UnFollowUserUseCase _unFollowUserUseCase;
  ListsCubit(
    this._getBlockedUseCase,
    this._getFollowersUseCase,
    this._getFriendRequestsUsecase,
    this._getFriendsUsecase,
    this._blocUserUseCase,
    this._deleteFriendUseCase,
    this._unFollowUserUseCase,
    this._acceptRejectFriendRequestUseCase,
  ) : super(const ListsState());

  void loadFriends(String search) async {
    getFriends(1, search);
    friendsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getFriends(pageKey, search);
    });
  }

  void loadFollowers(String search) async {
    getFollowers(1, search);
    followersPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getFollowers(pageKey, search);
    });
  }

  void loadRequests(String search) async {
    getRequests(1, search);
    requestsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getRequests(pageKey, search);
    });
  }

  void loadBlocked(String search) async {
    getBlocked(1, search);
    blockedPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getBlocked(pageKey, search);
    });
  }

  final int pageSize = 10;
  final PagingController<int, UserFriendEntity> friendsPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, UserFriendEntity> followersPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, UserFriendEntity> requestsPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, UserFriendEntity> blockedPagingController =
      PagingController(firstPageKey: 1);

  Future<void> getFriends(int page, String search) async {
    final response = await _getFriendsUsecase
        .call(TwitterFeedParams(page: page, limit: pageSize, search: search));
    response
        .fold((l) => emit(state.copWith(failure: l, status: ListsStates.error)),
            (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        friendsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        friendsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        friendsPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copWith(friends: data, status: ListsStates.success));
    });
  }

  Future<void> getFollowers(int page, String search) async {
    final response = await _getFollowersUseCase
        .call(TwitterFeedParams(page: page, limit: pageSize, search: search));
    response
        .fold((l) => emit(state.copWith(failure: l, status: ListsStates.error)),
            (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        followersPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        followersPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        followersPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copWith(followers: data, status: ListsStates.initial));
    });
  }

  Future<void> getRequests(int page, String search) async {
    final response = await _getFriendRequestsUsecase
        .call(TwitterFeedParams(page: page, limit: pageSize, search: search));
    response
        .fold((l) => emit(state.copWith(failure: l, status: ListsStates.error)),
            (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        requestsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        requestsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        requestsPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copWith(requests: data, status: ListsStates.initial));
    });
  }

  Future<void> getBlocked(int page, String search) async {
    final response = await _getBlockedUseCase
        .call(TwitterFeedParams(page: page, limit: pageSize, search: search));
    response
        .fold((l) => emit(state.copWith(failure: l, status: ListsStates.error)),
            (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        blockedPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        blockedPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        blockedPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copWith(blocked: data, status: ListsStates.initial));
    });
  }

  void changeListType({required ListTypes type}) async {
    emit(state.copWith(selectedList: type, status: ListsStates.loading));
    if (type == ListTypes.friends) {
      loadFriends('');
    } else if (type == ListTypes.followers) {
      loadFollowers('');
    } else if (type == ListTypes.requests) {
      loadRequests('');
    } else if (type == ListTypes.blocked) {
      loadBlocked('');
    }
    print(state.friends?.length);
  }

  Future<bool> blockUser(
      {required BuildContext context, required String userId}) async {
    final response = await _blocUserUseCase(userId);
    bool isBlocked = false;
    response.fold((l) {
      print("isBlocked$isBlocked");
      emit(state.copWith(failure: l, status: ListsStates.error));
    }, (r) {
      print("objectRight");
      isBlocked = r;
      getBlocked(1, '');
      print("isBlocked$isBlocked");
      emit(state.copWith(status: ListsStates.success));
    });
    return isBlocked;
  }

  Future<bool> unFollowRequest(
      {required BuildContext context, required String userId}) async {
    final response = await _unFollowUserUseCase(userId);
    bool unFollow = false;
    response.fold(
        (l) => emit(state.copWith(failure: l, status: ListsStates.error)), (r) {
      unFollow = r;
      getFollowers(1, '');
      emit(state.copWith(status: ListsStates.success));
    });
    return unFollow;
  }

  Future<bool> deleteFriend({required String userId}) async {
    var response = await _deleteFriendUseCase(userId);
    bool value = false;
    response.fold(
        (failure) =>
            emit(state.copWith(failure: failure, status: ListsStates.error)),
        (r) {
      value = r;getFriends(1, '');
    });
    return value;
  }

  Future<bool> acceptRejectFriend(
      {required AcceptRejectFriendRequestParams params}) async {
    var response = await _acceptRejectFriendRequestUseCase(params);
    bool value = false;
    response.fold(
        (failure) =>
            emit(state.copWith(failure: failure, status: ListsStates.error)),
        (r) {
      value = r;
      getRequests(1, '');
    });
    return value;
  }
}
