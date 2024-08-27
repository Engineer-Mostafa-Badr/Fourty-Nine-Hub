// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/core/api/end_points.dart';
// import 'package:fourtyninehub/core/states/basic_state.dart';
// import 'package:fourtyninehub/features/social_media/reels/domain/entities/reel_entity.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
//
// import '../../../domain/use_case/get_explore_reels_use_case.dart';
//
// class ExploreReelsCubit extends Cubit<BasicState> {
//   final GetExploreReelsUseCase _getExploreReelsUseCase;
//   late final PagingController<int, ReelEntity> exploreReelsPagingController =
//       PagingController(firstPageKey: 1)
//         ..addPageRequestListener(_getExploreReels);
//
//   ExploreReelsCubit(this._getExploreReelsUseCase) : super(const BasicState());
//
//   Future<void> _getExploreReels(int page) async {
//     final result = await _getExploreReelsUseCase(page);
//     result.fold(
//       (failure) {
//         exploreReelsPagingController.error = failure;
//       },
//       (reels) {
//         if (reels.length < EndPoints.pageSize) {
//           exploreReelsPagingController.appendLastPage(reels);
//         } else {
//           exploreReelsPagingController.appendPage(reels, page + 1);
//         }
//       },
//     );
//   }
//
//   @override
//   Future<void> close() {
//     exploreReelsPagingController.dispose();
//     return super.close();
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/new_reels_model.dart';
import '../../../data/repositories/reels_repository_impl.dart';

class ReelsState {
  final List<Reel> reels;
  final bool isLoading;
  final bool hasReachedMax;
  final int currentPage;

  ReelsState({
    required this.reels,
    required this.isLoading,
    required this.hasReachedMax,
    required this.currentPage,
  });

  ReelsState copyWith({
    List<Reel>? reels,
    bool? isLoading,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return ReelsState(
      reels: reels ?? this.reels,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class ReelsCubit extends Cubit<ReelsState> {
  final ReelsRepository repository;

  ReelsCubit({required this.repository})
      : super(ReelsState(
            reels: [], isLoading: false, hasReachedMax: false, currentPage: 0));

  Future<void> fetchReels() async {
    if (state.isLoading || state.hasReachedMax) return;

    emit(state.copyWith(isLoading: true));

    try {
      final ReelsResponse response =
          await repository.fetchReels(page: state.currentPage + 1);

      emit(state.copyWith(
        reels: [...state.reels, ...response.data.reels],
        isLoading: false,
        hasReachedMax: response.data.pagination.currentPage >=
            response.data.pagination.pageCount,
        currentPage: response.data.pagination.currentPage,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
