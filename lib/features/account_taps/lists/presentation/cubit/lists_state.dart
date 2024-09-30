part of 'lists_cubit.dart';

enum ListsStates { loading, success, error, initial }

enum ListTypes { friends, followers, requests, blocked }

extension ListsStateX on ListsState {
  bool get isLoading => ListsStates.loading == status;
  bool get isSuccess => ListsStates.success == status;
  bool get isError => ListsStates.error == status;
  bool get isInit => ListsStates.initial == status;
}

class ListsState {
  final ListsStates status;
  final Failure? failure;
  final ListTypes selectedList;
  final List<UserFriendEntity>? friends;
  final List<UserFriendEntity>? followers;
  final List<UserFriendEntity>? requests;
  final List<UserFriendEntity>? blocked;
  const ListsState(
      {this.status = ListsStates.loading,
      this.selectedList = ListTypes.friends,
      this.failure,
      this.friends,
      this.followers,
      this.requests,
      this.blocked});
  ListsState copWith({
    ListsStates? status,
    Failure? failure,
    ListTypes? selectedList,
    List<UserFriendEntity>? friends,
    List<UserFriendEntity>? followers,
    List<UserFriendEntity>? requests,
    List<UserFriendEntity>? blocked,
  }) {
    return ListsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      selectedList: selectedList ?? this.selectedList,
      friends: friends ?? this.friends,
      followers: followers ?? this.followers,
      requests: requests ?? this.requests,
      blocked: blocked ?? this.blocked,
    );
  }
}
