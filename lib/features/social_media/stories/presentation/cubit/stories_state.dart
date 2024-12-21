part of 'stories_cubit.dart';

class StoryState {
  final List<UserStories> users;
  final bool isLoading;
  final bool hasReachedMax;
  final int currentPage;
  final bool isFetchingMore;
  final DateTime? currentStoryCreatedAt; // New field

  final List<Follower> followers;

  final ViewersResponse? viewersResponse;
  final MutedStoriesResponse? mutedStoriesResponse;

  final bool isLoadingFollower;
  final String? errorMessage;

  StoryState({
    this.mutedStoriesResponse,
    this.viewersResponse,
    this.followers = const [],
    this.isLoadingFollower = false,
    this.errorMessage,
    this.users = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.isFetchingMore = false,
    this.currentStoryCreatedAt, // Initialize the field
  });

  StoryState copyWith({
    MutedStoriesResponse? mutedStoriesResponse,
    ViewersResponse? viewersResponse,
    List<Follower>? followers,
    bool? isLoadingFollower,
    String? errorMessage,
    List<UserStories>? stories,
    bool? isLoading,
    bool? hasReachedMax,
    int? currentPage,
    bool? isFetchingMore,
    DateTime? currentStoryCreatedAt, // Include this in copyWith
  }) {
    return StoryState(
      mutedStoriesResponse: mutedStoriesResponse ?? this.mutedStoriesResponse,
      viewersResponse: viewersResponse ?? this.viewersResponse,
      currentStoryCreatedAt:
          currentStoryCreatedAt ?? this.currentStoryCreatedAt,
      // New copyWith field
      followers: followers ?? this.followers,
      isLoadingFollower: isLoadingFollower ?? this.isLoadingFollower,
      errorMessage: errorMessage,
      users: stories ?? users,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}

class StoryInitial extends StoryState {
  StoryInitial() : super();
}

class StoryError extends StoryState {
  final String error;

  StoryError(this.error) : super(users: [], followers: []);
}
