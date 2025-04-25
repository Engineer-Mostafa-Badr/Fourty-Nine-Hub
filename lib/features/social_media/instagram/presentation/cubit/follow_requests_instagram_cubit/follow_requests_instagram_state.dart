part of 'follow_requests_instagram_cubit.dart';

enum FollowRequestsInstagramStates { initial, loading, success, failure }

extension FollowRequestsInstagramStatesX on FollowRequestsInstagramStates {
  bool get isInitial => this == FollowRequestsInstagramStates.initial;
  bool get isLoading => this == FollowRequestsInstagramStates.loading;
  bool get isSuccess => this == FollowRequestsInstagramStates.success;
  bool get isFailure => this == FollowRequestsInstagramStates.failure;
}

class FollowRequestsInstagramState {
  final FollowRequestsInstagramStates state;
  final List<SuggestionEntity>? suggestions;
  final int suggestFollowPage;
  final Failure? failure;
  const FollowRequestsInstagramState({
    this.state = FollowRequestsInstagramStates.initial,
    this.suggestions,
    this.suggestFollowPage = 1,
    this.failure,
  });

  FollowRequestsInstagramState copyWith({
    FollowRequestsInstagramStates? state,
    Failure? failure,
    List<SuggestionEntity>? suggestions,
    int? suggestFollowPage,
  }) {
    return FollowRequestsInstagramState(
      state: state ?? this.state,
      failure: failure ?? this.failure,
      suggestions: suggestions ?? this.suggestions,
      suggestFollowPage: suggestFollowPage ?? this.suggestFollowPage,
    );
  }
}
