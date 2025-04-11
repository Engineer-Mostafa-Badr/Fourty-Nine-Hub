part of 'reel_instagram_cubit.dart';

enum ReelInstagramStatus { initial, loading, success, failure }

extension ReelInstagramStatusX on ReelInstagramStatus {
  bool get isInitial => this == ReelInstagramStatus.initial;
  bool get isLoading => this == ReelInstagramStatus.loading;
  bool get isSuccess => this == ReelInstagramStatus.success;
  bool get isFailure => this == ReelInstagramStatus.failure;
}

class ReelInstagramState {
  final ReelInstagramStatus status;
  final List<ReelEntity>? reels;
  final Failure? failure;
  const ReelInstagramState({
    this.status = ReelInstagramStatus.initial,
    this.reels,
    this.failure,
  });

  ReelInstagramState copyWith({
    ReelInstagramStatus? status,
    List<ReelEntity>? reels,
    Failure? failure,
  }) {
    return ReelInstagramState(
      status: status ?? this.status,
      reels: reels ?? this.reels,
      failure: failure ?? this.failure,
    );
  }
}
