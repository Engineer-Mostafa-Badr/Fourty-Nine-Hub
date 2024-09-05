import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_blocked_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_followers_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_friend_requests_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_friends_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/block_user_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_friend_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/remove_friend_request_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/un_follow_user_usecase.dart';

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
  ListsCubit(this._getBlockedUseCase, this._getFollowersUseCase,
      this._getFriendRequestsUsecase, this._getFriendsUsecase, this._blocUserUseCase, this._deleteFriendUseCase, this._unFollowUserUseCase, this._acceptRejectFriendRequestUseCase)
      : super(const ListsState());

  void loadData() async {
    // await getFriends();
  }

  Future<void> getFriends() async {
    final response = await _getFriendsUsecase.call(const NoParams());
    response.fold(
        (l) => emit(state.copWith(failure: l, status: ListsStates.error)),
        (data) =>
            emit(state.copWith(friends: data, status: ListsStates.success)));
  }

  Future<void> getFollowers() async {
    final response = await _getFollowersUseCase.call(const NoParams());
    response.fold(
        (l) => emit(state.copWith(failure: l, status: ListsStates.error)),
        (data) =>
            emit(state.copWith(followers: data, status: ListsStates.initial)));
  }

  Future<void> getRequests() async {
    final response = await _getFriendRequestsUsecase.call(const NoParams());
    response.fold(
        (l) => emit(state.copWith(failure: l, status: ListsStates.error)),
        (data) =>
            emit(state.copWith(requests: data, status: ListsStates.initial)));
  }

  Future<void> getBlocked() async {
    final response = await _getBlockedUseCase.call(const NoParams());
    response.fold(
        (l) => emit(state.copWith(failure: l, status: ListsStates.error)),
        (data) =>
            emit(state.copWith(blocked: data, status: ListsStates.initial)));
  }

  void changeListType({required ListTypes type}) async {
    emit(state.copWith(selectedList: type, status: ListsStates.loading));
    if (type == ListTypes.friends) {
      await getFriends();
    } else if (type == ListTypes.followers) {
      await getFollowers();
    } else if (type == ListTypes.requests) {
      await getRequests();
    } else if (type == ListTypes.blocked) {
      await getBlocked();
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
            (l) => emit(state.copWith(failure: l, status: ListsStates.error)),
            (r) {
          unFollow = r;
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
          value = r;
        });
    return value;
  }

  Future<bool> acceptRejectFriend({required AcceptRejectFriendRequestParams params}) async {
    var response = await _acceptRejectFriendRequestUseCase(params);
    bool value = false;
    response.fold(
            (failure) =>
            emit(state.copWith(failure: failure, status: ListsStates.error)),
            (r) {
          value = r;
        });
    return value;
  }
}
