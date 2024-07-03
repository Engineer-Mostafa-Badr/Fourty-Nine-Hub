import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_blocked_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_followers_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_friend_requests_usecase.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/usecases/get_friends_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/users_list_entity.dart';

part 'lists_state.dart';



class ListsCubit extends Cubit<ListsState> {
  final GetFriendRequestsUsecase _getFriendRequestsUsecase;
  final GetBlockedUseCase _getBlockedUseCase;
  final GetFriendsUsecase _getFriendsUsecase;
  final GetFollowersUseCase _getFollowersUseCase;
  ListsCubit(this._getBlockedUseCase, this._getFollowersUseCase,
      this._getFriendRequestsUsecase, this._getFriendsUsecase)
      : super(const ListsState());

  void loadData() async {
    await getFriends();
  }

  Future<void> getFriends() async {
    final response = await _getFriendsUsecase.call(const NoParams());
    response.fold(
        (l) => emit(state.copWith(failure: l, status: ListsStates.error)),
        (data) =>
            emit(state.copWith(friends: data, status: ListsStates.initial)));
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
}
