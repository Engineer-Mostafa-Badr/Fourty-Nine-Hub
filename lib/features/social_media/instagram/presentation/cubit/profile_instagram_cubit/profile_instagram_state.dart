part of 'profile_instagram_cubit.dart';

enum ProfileInstagramStatus {
  initial,
  loading,
  success,
  failure,
}

extension ProfileInstagramStatusX on ProfileInstagramStatus {
  bool get isInitial => this == ProfileInstagramStatus.initial;
  bool get isLoading => this == ProfileInstagramStatus.loading;
  bool get isSuccess => this == ProfileInstagramStatus.success;
  bool get isFailure => this == ProfileInstagramStatus.failure;
}

class ProfileInstagramState {
  final ProfileInstagramStatus status;
  const ProfileInstagramState({
    this.status = ProfileInstagramStatus.initial,
  });

  ProfileInstagramState copyWith({
    ProfileInstagramStatus? status,
  }) {
    return ProfileInstagramState(
      status: status ?? this.status,
    );
  }
}
