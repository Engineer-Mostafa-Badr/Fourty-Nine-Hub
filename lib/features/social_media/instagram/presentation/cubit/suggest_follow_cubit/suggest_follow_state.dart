part of 'suggest_follow_cubit.dart';

enum SuggestFollowStatus { initial, loading, success, failure }

extension SuggestFollowStatusX on SuggestFollowState {
  bool get isInitial => status == SuggestFollowStatus.initial;
  bool get isLoading => status == SuggestFollowStatus.loading;
  bool get isSuccess => status == SuggestFollowStatus.success;
  bool get isFailure => status == SuggestFollowStatus.failure;
}

class SuggestFollowState {
  final SuggestFollowStatus status;
  final DataSuggestFollowInstagramEntity? suggestFollowsData;
  final int suggestFollowPage;
  final Failure? failure;

  SuggestFollowState({
    this.status = SuggestFollowStatus.initial,
    this.suggestFollowsData,
    this.suggestFollowPage = 1,
    this.failure,
  });

  SuggestFollowState copyWith({
    SuggestFollowStatus? status,
    DataSuggestFollowInstagramEntity? suggestFollowsData,
    int? suggestFollowPage,
    Failure? failure,
  }) {
    return SuggestFollowState(
      status: status ?? this.status,
      suggestFollowsData: suggestFollowsData ?? this.suggestFollowsData,
      suggestFollowPage: suggestFollowPage ?? this.suggestFollowPage,
      failure: failure ?? this.failure,
    );
  }
}
