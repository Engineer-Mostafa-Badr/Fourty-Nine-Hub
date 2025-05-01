part of 'profile_instagram_cubit.dart';

enum LoadingStatus {
  initial,
  loading,
  success,
  failure,
}

extension LoadingStatusX on LoadingStatus {
  bool get isInitial => this == LoadingStatus.initial;
  bool get isLoading => this == LoadingStatus.loading;
  bool get isSuccess => this == LoadingStatus.success;
  bool get isFailure => this == LoadingStatus.failure;
}

class ProfileInstagramState {
  final LoadingStatus profileStatus;
  final LoadingStatus reelsStatus;
  final LoadingStatus suggestFollowStatus;

  final ProfileInstagramDataEntity? profileData;
  // final List<InstagramProfilePostEntity>? allPosts;
  final ReelsSpecificUserDataEntity? reelsData;
  final DataSuggestFollowInstagramEntity? suggestFollowsData;

  final int postsPage;
  final int reelsPage;
  final int suggestFollowPage;

  final Failure? profileFailure;
  final Failure? reelsFailure;
  final Failure? suggestFollowFailure;

  const ProfileInstagramState({
    this.profileStatus = LoadingStatus.initial,
    this.reelsStatus = LoadingStatus.initial,
    this.suggestFollowStatus = LoadingStatus.initial,
    this.profileData,
    // this.allPosts,
    this.reelsData,
    this.suggestFollowsData,
    this.postsPage = 1,
    this.reelsPage = 1,
    this.suggestFollowPage = 1,
    this.profileFailure,
    this.reelsFailure,
    this.suggestFollowFailure,
  });

  ProfileInstagramState copyWith({
    LoadingStatus? profileStatus,
    LoadingStatus? reelsStatus,
    LoadingStatus? suggestFollowStatus,
    ProfileInstagramDataEntity? profileData,
    // List<InstagramProfilePostEntity>? allPosts,
    ReelsSpecificUserDataEntity? reelsData,
    DataSuggestFollowInstagramEntity? suggestFollowsData,
    int? postsPage,
    int? reelsPage,
    int? suggestFollowPage,
    Failure? profileFailure,
    Failure? reelsFailure,
    Failure? suggestFollowFailure,
  }) {
    return ProfileInstagramState(
      profileStatus: profileStatus ?? this.profileStatus,
      reelsStatus: reelsStatus ?? this.reelsStatus,
      suggestFollowStatus: suggestFollowStatus ?? this.suggestFollowStatus,
      profileData: profileData ?? this.profileData,
      // allPosts: allPosts ?? this.allPosts,
      reelsData: reelsData ?? this.reelsData,
      suggestFollowsData: suggestFollowsData ?? this.suggestFollowsData,
      postsPage: postsPage ?? this.postsPage,
      reelsPage: reelsPage ?? this.reelsPage,
      suggestFollowPage: suggestFollowPage ?? this.suggestFollowPage,
      profileFailure: profileFailure ?? this.profileFailure,
      reelsFailure: reelsFailure ?? this.reelsFailure,
      suggestFollowFailure: suggestFollowFailure ?? this.suggestFollowFailure,
    );
  }

  // طرق مفيدة للتحقق من الحالة العامة
  bool get isAllInitial =>
      profileStatus.isInitial &&
      reelsStatus.isInitial &&
      suggestFollowStatus.isInitial;

  bool get isAnyLoading =>
      profileStatus.isLoading ||
      reelsStatus.isLoading ||
      suggestFollowStatus.isLoading;

  bool get isAllSuccess =>
      profileStatus.isSuccess &&
      reelsStatus.isSuccess &&
      suggestFollowStatus.isSuccess;

  bool get isAnyFailure =>
      profileStatus.isFailure ||
      reelsStatus.isFailure ||
      suggestFollowStatus.isFailure;
}
