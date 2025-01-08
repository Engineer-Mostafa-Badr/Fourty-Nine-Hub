part of 'search_cubit.dart';

enum SearchStates { loading, initial, success, error }

class SearchState {
  final SearchStates status;
  final Failure? failure;
  String? filter;
  final List<MainCategoryEntity>? search;
  final List<SubCategoryEntity>? searchSubCategory;
  final List<UserSearchEntity>? userSearch;
  final List<AdsSearchEntity>? adsSearch;
  final List<PostEntity>? posts;
  final List<TripComeWithYouEntity>? tripCome;
  final List<ReelsSearchEntity>? reels;
  final PostEntity? postDetails;
  final CommentEntity? newComment;
  final List<MainCategoryEntity>? mainCategory;

  SearchState({
    this.status = SearchStates.loading,
    this.failure,
    this.search,
    this.searchSubCategory,
    this.userSearch,
    this.adsSearch,
    this.posts,
    this.postDetails,
    this.tripCome,
    this.newComment,
    this.reels,
    this.mainCategory,
    this.filter = 'totalUsers',
  });

  SearchState copyWith({
    SearchStates? status,
    Failure? failure,
    String? filter,
    List<MainCategoryEntity>? search,
    List<SubCategoryEntity>? searchSubCategory,
    List<UserSearchEntity>? userSearch,
    List<AdsSearchEntity>? adsSearch,
    List<PostEntity>? posts,
    List<TripComeWithYouEntity>? tripCome,
    PostEntity? postDetails,
    CommentEntity? newComment,
    List<ReelsSearchEntity>? reels,
    List<MainCategoryEntity>? mainCategory,
  }) {
    return SearchState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      search: search ?? this.search,
      searchSubCategory: searchSubCategory ?? this.searchSubCategory,
      userSearch: userSearch ?? this.userSearch,
      adsSearch: adsSearch ?? this.adsSearch,
      posts: posts ?? this.posts,
      postDetails: postDetails ?? this.postDetails,
      newComment: newComment ?? this.newComment,
      tripCome: tripCome ?? this.tripCome,
      reels: reels ?? this.reels,
      mainCategory: mainCategory ?? this.mainCategory,
    );
  }
}
