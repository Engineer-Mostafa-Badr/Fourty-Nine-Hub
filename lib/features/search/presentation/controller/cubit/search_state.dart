part of 'search_cubit.dart';

enum SearchStates { loading, initial, success,error }

class SearchState {
  final SearchStates status;
  final Failure? failure;
  String? filter;
  final List<MainSubCategorySearchEntity>? search;
  final List<UserSearchEntity>? userSearch;
  final List<AdsSearchEntity>? adsSearch;
  final List<PostEntity>? posts;
  final List<TripComeWithYouEntity>? tripCome;
  final PostEntity? postDetails;
  final CommentEntity? newComment;


  SearchState({
    this.status = SearchStates.loading,
    this.failure,
    this.search,
    this.userSearch,
    this.adsSearch,
    this.posts,
    this.postDetails,
    this.tripCome,
    this.newComment,
    this.filter='totalUsers',
  });

  SearchState copyWith({
    SearchStates? status,
    Failure? failure,
    String? filter,
    List<MainSubCategorySearchEntity>? search,
    List<UserSearchEntity>? userSearch,
    List<AdsSearchEntity>? adsSearch,
    List<PostEntity>? posts,
    List<TripComeWithYouEntity>? tripCome,
    PostEntity? postDetails,
    CommentEntity? newComment,
  }) {
    return SearchState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      search: search ?? this.search,
      userSearch: userSearch ?? this.userSearch,
      adsSearch: adsSearch ?? this.adsSearch,
      posts: posts ?? this.posts,
      postDetails: postDetails ?? this.postDetails,
      newComment: newComment ?? this.newComment,
      tripCome: tripCome ?? this.tripCome,
    );
  }
}
