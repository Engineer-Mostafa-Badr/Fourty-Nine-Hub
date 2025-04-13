part of 'comments_instagram_cubit.dart';

enum CommentsInstagramStatus {
  initial,
  loading,
  success,
  failure,
}

enum CommentsAddStatus {
  initial,
  loading,
  success,
  failure,
}

enum CommentsDeleteStatus {
  initial,
  loading,
  success,
  failure,
}

extension CommentsInstagramStatusX on CommentsInstagramStatus {
  bool get isInitial => this == CommentsInstagramStatus.initial;
  bool get isLoading => this == CommentsInstagramStatus.loading;
  bool get isSuccess => this == CommentsInstagramStatus.success;
  bool get isFailure => this == CommentsInstagramStatus.failure;
}

extension CommentsAddStatusX on CommentsAddStatus {
  bool get isInitial => this == CommentsAddStatus.initial;
  bool get isLoading => this == CommentsAddStatus.loading;
  bool get isSuccess => this == CommentsAddStatus.success;
  bool get isFailure => this == CommentsAddStatus.failure;
}

extension CommentsDeleteStatusX on CommentsDeleteStatus {
  bool get isInitial => this == CommentsDeleteStatus.initial;
  bool get isLoading => this == CommentsDeleteStatus.loading;
  bool get isSuccess => this == CommentsDeleteStatus.success;
  bool get isFailure => this == CommentsDeleteStatus.failure;
}

class CommentsInstagramState {
  final CommentsInstagramStatus status;
  final List<CommentInstagramEntity>? comments;
  final Failure? failure;
  final CommentsAddStatus addStatus;
  final Failure? addFailure;
  final CommentsDeleteStatus deleteStatus;
  final Failure? deleteFailure;

  const CommentsInstagramState(
      {this.status = CommentsInstagramStatus.initial,
      this.comments,
      this.failure,
      this.addStatus = CommentsAddStatus.initial,
      this.addFailure,
      this.deleteStatus = CommentsDeleteStatus.initial,
      this.deleteFailure});

  CommentsInstagramState copyWith({
    CommentsInstagramStatus? status,
    List<CommentInstagramEntity>? comments,
    Failure? failure,
    CommentsAddStatus? addStatus,
    Failure? addFailure,
    CommentsDeleteStatus? deleteStatus,
    Failure? deleteFailure,
  }) {
    return CommentsInstagramState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      failure: failure ?? this.failure,
      addStatus: addStatus ?? this.addStatus,
      addFailure: addFailure ?? this.addFailure,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      deleteFailure: deleteFailure ?? this.deleteFailure,
    );
  }
}
