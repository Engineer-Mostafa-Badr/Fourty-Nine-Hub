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
  final ProfileInstagramDataEntity? profileData;
  final ReelsSpecificUserDataEntity? reelsData;
  final DataSuggestFollowInstagramEntity? suggestFollowsData;
  final int postsPage;
  final int reelsPage;
  final int suggestFollowPage;
  final Failure? failure;
  const ProfileInstagramState({
    this.status = ProfileInstagramStatus.initial,
    this.profileData,
    this.reelsData,
    this.suggestFollowsData,
    this.postsPage = 1,
    this.reelsPage = 1,
    this.suggestFollowPage = 1,
    this.failure,
  });

  ProfileInstagramState copyWith({
    ProfileInstagramStatus? status,
    ProfileInstagramDataEntity? profileData,
    ReelsSpecificUserDataEntity? reelsData,
    DataSuggestFollowInstagramEntity? suggestFollowsData,
    int? postsPage,
    int? reelsPage,
    int? suggestFollowPage,
    Failure? failure,
  }) {
    return ProfileInstagramState(
      status: status ?? this.status,
      profileData: profileData ?? this.profileData,
      reelsData: reelsData ?? this.reelsData,
      suggestFollowsData: suggestFollowsData ?? this.suggestFollowsData,
      postsPage: postsPage ?? this.postsPage,
      reelsPage: reelsPage ?? this.reelsPage,
      suggestFollowPage: suggestFollowPage ?? this.suggestFollowPage,
      failure: failure ?? this.failure,
    );
  }
}
