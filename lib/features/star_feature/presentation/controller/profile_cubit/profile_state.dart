part of 'profile_cubit.dart';
class ProfileState extends Equatable {
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

  // Helper getters
  bool get isLoading => status == ProfileStatus.loading;
  bool get isUpdating => status == ProfileStatus.updating;
  bool get isSuccess => status == ProfileStatus.success;
  bool get isError => status == ProfileStatus.error;
  bool get hasProfile => profile != null;
  bool get hasError => failure != null;
  bool get hasMessage => message != null;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    Failure? failure,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      failure: failure, // Don't use ?? here to allow null clearing
      message: message, // Don't use ?? here to allow null clearing
    );
  }

  @override
  List<Object?> get props => [status, profile, failure, message];

  @override
  String toString() {
    return 'ProfileState(status: $status, hasProfile: $hasProfile, hasError: $hasError, hasMessage: $hasMessage)';
  }
}
