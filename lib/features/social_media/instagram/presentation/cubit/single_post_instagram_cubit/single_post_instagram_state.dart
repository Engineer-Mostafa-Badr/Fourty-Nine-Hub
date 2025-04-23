part of 'single_post_instagram_cubit.dart';

enum SinglePostInstagramStatus { initial, loading, success, failure }

extension SinglePostInstagramStatusX on SinglePostInstagramStatus {
  bool get isInitial => this == SinglePostInstagramStatus.initial;
  bool get isLoading => this == SinglePostInstagramStatus.loading;
  bool get isSuccess => this == SinglePostInstagramStatus.success;
  bool get isFailure => this == SinglePostInstagramStatus.failure;
}

class SinglePostInstagramState {
  final SinglePostInstagramStatus status;
  final SinglePostInstagramEntity? postData;
  final Failure? failure;
  const SinglePostInstagramState({
    this.status = SinglePostInstagramStatus.initial,
    this.postData,
    this.failure,
  });

  SinglePostInstagramState copyWith({
    SinglePostInstagramStatus? status,
    SinglePostInstagramEntity? postData,
    Failure? failure,
  }) {
    return SinglePostInstagramState(
      status: status ?? this.status,
      postData: postData ?? this.postData,
      failure: failure ?? this.failure,
    );
  }
}
