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
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/add_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/like_model.dart';

import '../../../data/models/new_reels_model.dart';
import '../../../data/repositories/reels_repository_impl.dart';

class ReelsState {
  final List<Reel> reels;
  final bool isLoading;
  final bool hasReachedMax;
  final int currentPage;

  // Fields related to liking a reel
  final bool isLikingReel;
  final String? likeReelErrorMessage;
  final ReelLikeResponse? likeReelResponse;

  // New fields related to adding a comment
  final bool isCommenting;
  final String? commentErrorMessage;
  final AddCommentResponse? commentResponse;

  // Fields related to fetching comments
  final bool isFetchingComments;
  final String? fetchCommentsErrorMessage;
  final GetCommentsResponse? fetchedComments;

  ReelsState({
    required this.reels,
    required this.isLoading,
    required this.hasReachedMax,
    required this.currentPage,
    this.isLikingReel = false,
    this.likeReelErrorMessage,
    this.likeReelResponse,
    this.isCommenting = false,
    this.commentErrorMessage,
    this.commentResponse,
    this.isFetchingComments = false,
    this.fetchCommentsErrorMessage,
    this.fetchedComments,
  });

  ReelsState copyWith({
    List<Reel>? reels,
    bool? isLoading,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLikingReel,
    String? likeReelErrorMessage,
    ReelLikeResponse? likeReelResponse,
    bool? isCommenting,
    String? commentErrorMessage,
    AddCommentResponse? commentResponse,
    bool? isFetchingComments,
    String? fetchCommentsErrorMessage,
    GetCommentsResponse? fetchedComments,
  }) {
    return ReelsState(
      reels: reels ?? this.reels,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isLikingReel: isLikingReel ?? this.isLikingReel,
      likeReelErrorMessage: likeReelErrorMessage ?? this.likeReelErrorMessage,
      likeReelResponse: likeReelResponse ?? this.likeReelResponse,
      isCommenting: isCommenting ?? this.isCommenting,
      commentErrorMessage: commentErrorMessage ?? this.commentErrorMessage,
      commentResponse: commentResponse ?? this.commentResponse,
      isFetchingComments: isFetchingComments ?? this.isFetchingComments,
      fetchCommentsErrorMessage:
          fetchCommentsErrorMessage ?? this.fetchCommentsErrorMessage,
      fetchedComments: fetchedComments ?? this.fetchedComments,
    );
  }
}

class ReelsCubit extends Cubit<ReelsState> {
  final ReelsRepository repository;

  ReelsCubit({required this.repository})
      : super(ReelsState(
            reels: [], isLoading: false, hasReachedMax: false, currentPage: 0));

//---------------------------------------------------------------------------------------
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

//--------------------------------------------------------------------------------------------
  Future<void> likeReel(String reelId) async {
    try {
      emit(state.copyWith(
          isLikingReel: false, likeReelErrorMessage: 'loadingLike'));

      final response = await repository.likeReel(reelId);

      // Assuming you might want to update the specific reel in the list with the like status
      List<Reel> updatedReels = state.reels.map((reel) {
        if (reel.id == reelId) {
          // Update the reel here if needed
        }
        return reel;
      }).toList();

      emit(state.copyWith(
          likeReelResponse: response,
          isLikingReel:
              response.message == "Reel liked successfully" ? true : false));
    } catch (e) {
      emit(state.copyWith(
          isLikingReel: false,
          likeReelErrorMessage:
              'errorLike')); // Handle the error, possibly update the UI state or show an error message
    }
  }

  //======================================================================================
  Future<void> addComment(String reelId, String comment,
      {String? receiverComment, String? parentCommentId}) async {
    try {
      // Indicate that a comment is being added
      emit(state.copyWith(isCommenting: false));

      // Make the API call to add a comment
      final response = await repository.addComment(
        reelId: reelId,
        comment: comment,
      );

      // Update the state based on the response
      log("${response.message}=====================================--------------------------------");
      emit(state.copyWith(
        isCommenting: true,
        commentResponse: response,
        commentErrorMessage: response.status ? null : "Failed to add comment",
      ));
    } catch (e) {
      // Handle errors and update the state accordingly
      emit(state.copyWith(
        isCommenting: false,
        commentErrorMessage: "An error occurred while adding the comment",
      ));
    }
  }

  Future<void> getComments(String reelId) async {
    try {
      emit(state.copyWith(isFetchingComments: false));
      final commentsResponse = await repository.fetchComments(reelId);
      log("${commentsResponse.data.first.comment}aaaaaaaaaaaaaaaaaaaa");
      emit(state.copyWith(
          isFetchingComments: true, fetchedComments: commentsResponse));
    } catch (e) {
      emit(state.copyWith(
          isFetchingComments: false,
          fetchCommentsErrorMessage: 'fetchCommentsError'));
    }
  }
}
