part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, error, updating }

class ProfileState {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final Failure? failure;
  final String? message;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.failure,
    this.message,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    Failure? failure,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      failure: failure ?? this.failure,
      message: message ?? this.message,
    );
  }
}
