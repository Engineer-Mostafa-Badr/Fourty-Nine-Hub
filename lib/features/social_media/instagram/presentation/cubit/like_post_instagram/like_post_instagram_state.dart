part of 'like_post_instagram_cubit.dart';

enum LikePostInstagramStatus { initial, loading, success, failure }

extension LikePostInstagramStatusX on LikePostInstagramStatus {
  bool get isInitial => this == LikePostInstagramStatus.initial;

  bool get isLoading => this == LikePostInstagramStatus.loading;

  bool get isSuccess => this == LikePostInstagramStatus.success;

  bool get isFailure => this == LikePostInstagramStatus.failure;
}

class LikePostInstagramState extends Equatable {
  final LikePostInstagramStatus? status;
  final bool? isLike;
  final int? likeCount;
  final String? message;

  const LikePostInstagramState({
    this.status,
    this.message,
    this.likeCount,
    this.isLike,
  });

  LikePostInstagramState copyWith({
    LikePostInstagramStatus? status,
    String? message,
    bool? isLike,
    int? likeCount,
  }) {
    return LikePostInstagramState(
      status: status ?? this.status,
      message: message ?? this.message,
      isLike: isLike ?? this.isLike,
      likeCount: likeCount ?? this.likeCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        likeCount,
        isLike,
      ];
}
