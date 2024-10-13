part of 'search_cubit.dart';

enum SearchStates { loading, initial, success,error }

class SearchState {
  final SearchStates status;
  final Failure? failure;
  final List<MainSubCategorySearchEntity>? search;


  const SearchState({
    this.status = SearchStates.loading,
    this.failure,
    this.search,
  });

  SearchState copyWith({
    SearchStates? status,
    Failure? failure,
    List<MainSubCategorySearchEntity>? search,
  }) {
    return SearchState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      search: search ?? this.search,
    );
  }
}
