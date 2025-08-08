import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/followers_entity.dart';

enum FollowStates { loading, initState, error, success }

extension FollowStateX on FollowState {
  bool get isInitial => status == FollowStates.initState;
  bool get isLoading => status == FollowStates.loading;
  bool get isError => status == FollowStates.error;
  bool get isSuccess => status == FollowStates.success;
}

class FollowState {
  final FollowStates? status;
  final Failure? failure;
  final bool? isLast;
  final List<FollowersEntity>? followers;
  final List<FollowersEntity>? following;

  FollowState({
    this.status,
    this.failure,
    this.followers,
    this.following,
    this.isLast,
  });
  FollowState copyWith({
    FollowStates? status,
    Failure? failure,
    List<FollowersEntity>? followers,
    List<FollowersEntity>? following,
    bool? isLast,
  }) {
    return FollowState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isLast: isLast ?? this.isLast,
    );
  }
}
