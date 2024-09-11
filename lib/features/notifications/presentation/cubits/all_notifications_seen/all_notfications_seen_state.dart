part of 'all_notfications_seen_cubit.dart';

sealed class AllNotficationsSeenState {}

final class AllNotficationsSeenInitial extends AllNotficationsSeenState {}

final class AllNotficationsSeenLoading extends AllNotficationsSeenState {}

final class AllNotficationsSeenFailed extends AllNotficationsSeenState {
  final String message;

  AllNotficationsSeenFailed(this.message);
}

final class AllNotficationsSeenSuccess extends AllNotficationsSeenState {}
