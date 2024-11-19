part of 'search_cubit.dart';

enum SearchStates { loading, initial, success, error }

class SearchState {
  final SearchStates status;
  final Failure? failure;
  String? filter;
  final List<MainSubCategorySearchEntity>? search;
  final List<UserSearchEntity>? userSearch;

  SearchState({
    this.status = SearchStates.loading,
    this.failure,
    this.search,
    this.userSearch,
    this.filter = 'totalUsers',
  });

  SearchState copyWith({
    SearchStates? status,
    Failure? failure,
    String? filter,
    List<MainSubCategorySearchEntity>? search,
    List<UserSearchEntity>? userSearch,
  }) {
    return SearchState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      search: search ?? this.search,
      userSearch: userSearch ?? this.userSearch,
    );
  }
}
