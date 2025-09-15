part of 'star_cubit.dart';

class StarState {
  final StarStates status;
  final Failure? failure;

  // Unified data storage
  final Map<TalentCategory, List<StarEntity>> talents;
  final Map<TalentCategory, bool> loadingStates;
  final Map<TalentCategory, bool> hasMoreData;
  final Map<TalentCategory, int> currentPages;

  // Other data
  final List<StarWinnerEntity> winners;
  final List<UploadFileEntity>? videos;
  final BannerTalentEntity? banner;
  final Set<String> favoriteIds;
  final Set<String> watchLaterIds;
  final Set<String> ratedVideos; // Track videos that have been rated by user

  // Search and filter state
  final String searchQuery;
  final List<StarEntity> searchResults;
  final List<ProfileEntity> searchProfileResults;
  final bool isSearchingProfiles;

  // Messages
  final String? successMessage;

  StarState({
    this.status = StarStates.initial,
    this.failure,
    Map<TalentCategory, List<StarEntity>>? talents,
    Map<TalentCategory, bool>? loadingStates,
    Map<TalentCategory, bool>? hasMoreData,
    Map<TalentCategory, int>? currentPages,
    List<StarWinnerEntity>? winners,
    this.videos,
    this.banner,
    Set<String>? favoriteIds,
    Set<String>? watchLaterIds,
    Set<String>? ratedVideos,
    this.searchQuery = '',
    List<StarEntity>? searchResults,
    List<ProfileEntity>? searchProfileResults,
    this.isSearchingProfiles = false,
    this.successMessage,
  })  : searchProfileResults = searchProfileResults ?? [],
        ratedVideos = ratedVideos ?? {},
        talents = talents ??
            {
              TalentCategory.available: [],
              TalentCategory.favorites: [],
              TalentCategory.watchLater: [],
              TalentCategory.history: [],
              TalentCategory.myTalents: [],
            },
        loadingStates = loadingStates ??
            {
              TalentCategory.available: false,
              TalentCategory.favorites: false,
              TalentCategory.watchLater: false,
              TalentCategory.history: false,
              TalentCategory.myTalents: false,
            },
        hasMoreData = hasMoreData ??
            {
              TalentCategory.available: true,
              TalentCategory.favorites: true,
              TalentCategory.watchLater: true,
              TalentCategory.history: true,
              TalentCategory.myTalents: true,
            },
        currentPages = currentPages ??
            {
              TalentCategory.available: 1,
              TalentCategory.favorites: 1,
              TalentCategory.watchLater: 1,
              TalentCategory.history: 1,
              TalentCategory.myTalents: 1,
            },
        winners = winners ?? [],
        favoriteIds = favoriteIds ?? {},
        watchLaterIds = watchLaterIds ?? {},
        searchResults = searchResults ?? [];

  // Helper getters for easy access
  List<StarEntity> get availableTalents =>
      talents[TalentCategory.available] ?? [];
  List<StarEntity> get favoriteTalents =>
      talents[TalentCategory.favorites] ?? [];
  List<StarEntity> get watchLaterTalents =>
      talents[TalentCategory.watchLater] ?? [];
  List<StarEntity> get historyTalents => talents[TalentCategory.history] ?? [];
  List<StarEntity> get myTalents => talents[TalentCategory.myTalents] ?? [];

  bool isLoading(TalentCategory category) => loadingStates[category] ?? false;
  bool hasMore(TalentCategory category) => hasMoreData[category] ?? false;
  int getCurrentPage(TalentCategory category) => currentPages[category] ?? 1;

  StarState copyWith({
    StarStates? status,
    Failure? failure,
    Map<TalentCategory, List<StarEntity>>? talents,
    Map<TalentCategory, bool>? loadingStates,
    Map<TalentCategory, bool>? hasMoreData,
    Map<TalentCategory, int>? currentPages,
    List<StarWinnerEntity>? winners,
    List<UploadFileEntity>? videos,
    BannerTalentEntity? banner,
    Set<String>? favoriteIds,
    Set<String>? watchLaterIds,
    Set<String>? ratedVideos,
    String? searchQuery,
    List<StarEntity>? searchResults,
    List<ProfileEntity>? searchProfileResults,
    bool? isSearchingProfiles,
    String? successMessage,
  }) {
    return StarState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      talents: talents ?? this.talents,
      loadingStates: loadingStates ?? this.loadingStates,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPages: currentPages ?? this.currentPages,
      winners: winners ?? this.winners,
      videos: videos ?? this.videos,
      banner: banner ?? this.banner,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      watchLaterIds: watchLaterIds ?? this.watchLaterIds,
      ratedVideos: ratedVideos ?? this.ratedVideos,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      searchProfileResults: searchProfileResults ?? this.searchProfileResults,
      isSearchingProfiles: isSearchingProfiles ?? this.isSearchingProfiles,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
