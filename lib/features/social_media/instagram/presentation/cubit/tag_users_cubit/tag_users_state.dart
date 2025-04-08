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
  final List<UserTagEntity> users;
  final Failure? failure;

  const TagUsersState({
    this.status = TagUsersStates.initial,
    this.users = const [],
    this.failure,
  });

  TagUsersState copyWith({
    TagUsersStates? status,
    List<UserTagEntity>? users,
    Failure? failure,
  }) {
    return TagUsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      failure: failure ?? this.failure,
    );
  }
}
