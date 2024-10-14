part of 'search_cubit.dart';

enum SearchStates { loading, initial, success,error }

class SearchState {
  final SearchStates status;
  final Failure? failure;
  String? filter;
  final List<MainSubCategorySearchEntity>? search;


  SearchState({
    this.status = SearchStates.loading,
    this.failure,
    this.search,
    this.filter='totalUsers',
  });

  SearchState copyWith({
    SearchStates? status,
    Failure? failure,
    String? filter,
    List<MainSubCategorySearchEntity>? search,
  }) {
    return SearchState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      search: search ?? this.search,
    );
  }
}
