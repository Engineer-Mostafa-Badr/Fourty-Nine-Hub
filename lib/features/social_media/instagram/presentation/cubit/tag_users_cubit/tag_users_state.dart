part of 'tag_users_cubit.dart';

enum TagUsersStates { loading, initial, success, error }

extension TagUsersStateX on TagUsersStates {
  bool get isInitial => this == TagUsersStates.initial;
  bool get isLoading => this == TagUsersStates.loading;
  bool get isError => this == TagUsersStates.error;
  bool get isSuccess => this == TagUsersStates.success;
}

class TagUsersState {
  final TagUsersStates status;
  final List<UserTagEntity>? users;
  final bool isLoadingMore;
  final  bool hasMoreData;
  final int currentPage ;
  final int pageSize;
  final Failure? failure;

  const TagUsersState({
    this.status = TagUsersStates.initial,
    this.users,
    this.isLoadingMore = false,
    this.hasMoreData = true,
    this.currentPage = 1,
    this.pageSize = 10,
    this.failure,
  });

  TagUsersState copyWith({
    TagUsersStates? status,
    List<UserTagEntity>? users,
    bool? isLoadingMore,
    bool? hasMoreData,
    int? currentPage,
    int? pageSize,
    Failure? failure,
  }) {
    return TagUsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      failure: failure ?? this.failure,
    );
  }
}
