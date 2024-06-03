import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/entities/reel_entity.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../domain/use_case/get_explore_reels_use_case.dart';

class ExploreReelsCubit extends Cubit<BasicState> {
  final GetExploreReelsUseCase _getExploreReelsUseCase;
  late final PagingController<int, ReelEntity> exploreReelsPagingController =
      PagingController(firstPageKey: 1)
        ..addPageRequestListener(_getExploreReels);

  ExploreReelsCubit(this._getExploreReelsUseCase) : super(const BasicState());

  Future<void> _getExploreReels(int page) async {
    final result = await _getExploreReelsUseCase(page);
    result.fold(
      (failure) {
        exploreReelsPagingController.error = failure;
      },
      (reels) {
        if (reels.length < EndPoints.pageSize) {
          exploreReelsPagingController.appendLastPage(reels);
        } else {
          exploreReelsPagingController.appendPage(reels, page + 1);
        }
      },
    );
  }

  @override
  Future<void> close() {
    exploreReelsPagingController.dispose();
    return super.close();
  }
}
