import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/change_react.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/reels_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/trip_come_with_you_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/user_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_ads_search_use_case.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_posts_search_use_case.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_reel_search_use_case.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_sub_category_use_case.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_trip_come_search_use_case.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_user_search_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/edit_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/hide_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/share_post_usecase.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final FetchSearchUseCase _fetchSearchUseCase;
  final FetchSearchSubCategoryUseCase _fetchSearchSubCategoryUseCase;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;
  final FetchUserSearchUseCase _fetchUserSearchUseCase;
  final FetchAdsSearchUseCase _fetchAdsSearchUseCase;
  final FetchPostsSearchUseCase _fetchPostsSearchUseCase;
  final FetchTripComeSearchUseCase _fetchTripComeSearchUseCase;
  final FetchReelSearchUseCase _fetchReelSearchUseCase;
  final SharePostUseCase _sharePostUseCase;
  final DeletePostUseCase _deletePostUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;
  final HidePostUseCase _hidePostUseCase;
  final PostReactUseCase _postReactUseCase;
  final PostCommentUseCase _postCommentUseCase;
  final ReplyOnCommentUseCase _replyOnCommentUseCase;
  final EditCommentUseCase _editCommentUseCase;
  final CommentReactUseCase _commentReactUseCase;
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;

  void clearPostsSearchResults() {
    postsSearch.clear();
    postsSearchPage = 1;
    hasMorePostsSearchData = true;
    emit(state.copyWith(
      posts: [],
      status: SearchStates.initial,
    ));
  }

  SearchCubit(
    this._fetchSearchUseCase,
    this._toggleFavoriteCategoryUseCase,
    this._fetchUserSearchUseCase,
    this._fetchAdsSearchUseCase,
    this._fetchPostsSearchUseCase,
    this._sharePostUseCase,
    this._deletePostUseCase,
    this._deleteCommentUseCase,
    this._hidePostUseCase,
    this._postReactUseCase,
    this._postCommentUseCase,
    this._replyOnCommentUseCase,
    this._editCommentUseCase,
    this._commentReactUseCase,
    this._fetchTripComeSearchUseCase,
    this._fetchReelSearchUseCase,
    this._fetchSearchSubCategoryUseCase,
    this._getMainCategoriesUseCase,
  ) : super(SearchState());

  TextEditingController searchController = TextEditingController();
  final shareFormKey = GlobalKey<FormState>();

  String? content;

  void changeContent({
    required String v,
  }) {
    content = v;
    print(content);
  }

  void clearSearchResults() {
    emit(state.copyWith(
      userSearch: [],
      posts: [],
      reels: [],
      search: [],
      // other models too
    ));
  }

  initPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filter', 'users');
  }

  final int pageSize = 10;

  List<MainCategoryEntity> paginatedSearch = [];

  bool loadPaginatedSearch = false;

  Future loadPaginatedSearchData({required SearchParams params}) async {
    loadPaginatedSearch = true;
    paginatedSearch.clear();
    paginatedSearchPage = 1;
    hasMorePaginatedSearchData = true; // 🔥 Reset this here
    emit(state.copyWith(status: SearchStates.loading));

    await getPaginatedSearch(params: params);

    loadPaginatedSearch = false;
    emit(state.copyWith(status: SearchStates.success));
  }

  bool isLoadingPaginatedSearchMore = false;
  bool hasMorePaginatedSearchData = true;
  int paginatedSearchPage = 1;

  Future<void> getPaginatedSearch({required SearchParams params}) async {
    if (!hasMorePaginatedSearchData || isLoadingPaginatedSearchMore) return;

    isLoadingPaginatedSearchMore = true;
    emit(state.copyWith(status: SearchStates.loading));

    final response = await _fetchSearchUseCase.call(params);

    response.fold(
      (l) => emit(state.copyWith(failure: l, status: SearchStates.error)),
      (data) async {
        paginatedSearch.addAll(data);

        // FIX: If it's the first page and data is empty,
        // we should keep `hasMorePaginatedSearchData = true` for future retries.
        if (params.params.page == 1 && data.isEmpty) {
          hasMorePaginatedSearchData = true;
        } else if (data.length < pageSize) {
          hasMorePaginatedSearchData = false;
        } else {
          paginatedSearchPage++;
        }

        isLoadingPaginatedSearchMore = false;
        emit(state.copyWith(
            status: SearchStates.success, search: paginatedSearch));
      },
    );
  }

  // Future loadPaginatedSearchData({required SearchParams params}) async {
  //   loadPaginatedSearch=true;
  //   paginatedSearch.clear();
  //   paginatedSearchPage = 1;
  //   hasMoreAdsData = true;
  //   emit(state.copyWith(status: SearchStates.loading));
  //
  //   await getPaginatedSearch(params:params);
  //
  //   loadPaginatedSearch=false;
  //   emit(state.copyWith(status: SearchStates.success));
  // }
  //
  //
  // bool isLoadingPaginatedSearchMore = false;
  // bool hasMorePaginatedSearchData = true;
  // int paginatedSearchPage = 1;
  // Future<void> getPaginatedSearch(
  //     {required SearchParams params}
  //     ) async {
  //   if (!hasMorePaginatedSearchData || isLoadingPaginatedSearchMore) return;
  //   isLoadingPaginatedSearchMore = true;
  //   emit(state.copyWith(status: SearchStates.loading));
  //   final response = await _fetchSearchUseCase.call(params);
  //   response.fold(
  //           (l) => emit(state.copyWith(failure: l, status: SearchStates.error)),
  //           (data) async {
  //         paginatedSearch.addAll(data);
  //         if (data.length < pageSize) {
  //           hasMorePaginatedSearchData = false;
  //         } else {
  //           paginatedSearchPage++;
  //         }
  //         isLoadingPaginatedSearchMore = false;
  //         emit(state.copyWith(status: SearchStates.success,search: paginatedSearch));
  //       });
  // }

  List<SubCategoryEntity> subCategoriesSearch = [];
  bool loadSubCategoriesSearch = false;

  Future loadSubCategoriesSearchData({required SearchParams params}) async {
    loadSubCategoriesSearch = true;
    subCategoriesSearch.clear();
    subCategoriesSearchPage = 1;
    hasMoreSubCategoriesSearchData = true; // 🔥 Reset this!
    emit(state.copyWith(status: SearchStates.loading));

    await getPaginatedSubCategorySearch(params: params);

    loadSubCategoriesSearch = false;
    emit(state.copyWith(status: SearchStates.success));
  }

  bool isLoadingSubCategoriesSearchMore = false;
  bool hasMoreSubCategoriesSearchData = true;
  int subCategoriesSearchPage = 1;

  Future<void> getPaginatedSubCategorySearch(
      {required SearchParams params}) async {
    if (!hasMoreSubCategoriesSearchData || isLoadingSubCategoriesSearchMore) {
      return;
    }
    isLoadingSubCategoriesSearchMore = true;
    emit(state.copyWith(status: SearchStates.loading));
    final response = await _fetchSearchSubCategoryUseCase.call(params);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: SearchStates.error)),
        (data) async {
      subCategoriesSearch.addAll(data);
      if (data.length < pageSize) {
        hasMoreSubCategoriesSearchData = false;
      } else {
        subCategoriesSearchPage++;
      }
      isLoadingSubCategoriesSearchMore = false;
      emit(state.copyWith(
          status: SearchStates.success,
          searchSubCategory: subCategoriesSearch));
    });
  }

  List<UserSearchEntity> usersSearch = [];
  bool loadUsersSearch = false;

  Future loadUsersSearchData({required SearchParams params}) async {
    loadUsersSearch = true;
    usersSearch.clear();
    usersSearchPage = 1;
    hasMoreUsersSearchData = true;
    emit(state.copyWith(status: SearchStates.loading));
    await getPaginatedUserSearch(params: params);
    loadUsersSearch = false;
    emit(state.copyWith(status: SearchStates.success));
  }

  bool isLoadingUsersSearchMore = false;
  bool hasMoreUsersSearchData = true;
  int usersSearchPage = 1;

  Future<void> getPaginatedUserSearch({required SearchParams params}) async {
    if (!hasMoreUsersSearchData || isLoadingUsersSearchMore) return;
    isLoadingUsersSearchMore = true;
    emit(state.copyWith(status: SearchStates.loading));
    final response = await _fetchUserSearchUseCase.call(params);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: SearchStates.error)),
        (data) async {
      usersSearch.addAll(data);
      if (data.length < pageSize) {
        hasMoreUsersSearchData = false;
      } else {
        usersSearchPage++;
      }
      isLoadingUsersSearchMore = false;
      emit(state.copyWith(status: SearchStates.success));
    });
  }

  List<AdsSearchEntity> adsSearch = [];
  bool loadAds = false;
  bool isLoadingAdsMore = false;
  bool hasMoreAdsData = true;
  int adsSearchPage = 1;

  Future<void> loadAdsData({required SearchParams params}) async {
    loadAds = true;
    adsSearch.clear();
    adsSearchPage = 1;
    hasMoreAdsData = true;
    isLoadingAdsMore = false;

    emit(state.copyWith(status: SearchStates.loading));

    await getPaginatedAdsSearch(params: params);

    loadAds = false;
    // ❌ No need to emit success again here
  }

  Future<void> getPaginatedAdsSearch({required SearchParams params}) async {
    print('==> getPaginatedAdsSearch');
    print('==> getPaginatedAdsSearch ${(!hasMoreAdsData || isLoadingAdsMore)}');
    if (!hasMoreAdsData || isLoadingAdsMore) return;
    isLoadingAdsMore = true;
    print('==> getPaginatedAdsSearch test 1');

    emit(state.copyWith(status: SearchStates.loading));
    print('==> getPaginatedAdsSearch test 2');

    final response = await _fetchAdsSearchUseCase.call(params);
    print('==> getPaginatedAdsSearch response $response');

    response.fold(
      (l) {
        print('==> failure $l');
        isLoadingAdsMore = false;
        emit(state.copyWith(failure: l, status: SearchStates.error));
      },
      (data) {
          print('==> data $data');

        adsSearch.addAll(data);
        print('==> adsSearch.length ${adsSearch.length}');

        if (data.length < pageSize) {
          hasMoreAdsData = false;
        } else {
          adsSearchPage++;
        }

        isLoadingAdsMore = false;
        emit(state.copyWith(
          status: SearchStates.success,
          adsSearch: adsSearch,
        ));
      },
    );
  }

  // Future loadAdsData({required SearchParams params}) async {
  //   loadAds=true;
  //   adsSearch.clear();
  //   adsSearchPage = 1;
  //   hasMoreAdsData = true;
  //   emit(state.copyWith(status: SearchStates.loading));
  //   await getPaginatedAdsSearch(params:params);
  //   loadAds=false;
  //   emit(state.copyWith(status: SearchStates.success));
  // }
  // bool isLoadingAdsMore = false;
  // bool hasMoreAdsData = true;
  // int adsSearchPage = 1;
  // Future<void> getPaginatedAdsSearch(
  //     {required SearchParams params}
  //     ) async {
  //   if (!hasMoreAdsData || isLoadingAdsMore) return;
  //   isLoadingAdsMore = true;
  //   emit(state.copyWith(status: SearchStates.loading));
  //   final response = await _fetchAdsSearchUseCase.call(params);
  //   response.fold(
  //           (l) => emit(state.copyWith(failure: l, status: SearchStates.error)),
  //           (data) async {
  //         adsSearch.addAll(data);
  //         if (data.length < pageSize) {
  //           hasMoreAdsData = false;
  //         } else {
  //           adsSearchPage++;
  //         }
  //         isLoadingAdsMore = false;
  //         emit(state.copyWith(status: SearchStates.success));
  //       });
  // }

  List<TripComeWithYouEntity> tripComeSearch = [];
  bool loadTripComeSearch = false;

  Future loadTripComeSearchData({required SearchParams params}) async {
    loadTripComeSearch = true;
    tripComeSearch.clear();
    tripComeSearchPage = 1;
    hasMoreAdsData = true;
    emit(state.copyWith(status: SearchStates.loading));
    await getPaginatedTripComeSearch(params: params);
    loadTripComeSearch = false;
    emit(state.copyWith(status: SearchStates.success));
  }

  bool isLoadingTripComeSearchMore = false;
  bool hasMoreTripComeSearchData = true;
  int tripComeSearchPage = 1;

  Future<void> getPaginatedTripComeSearch(
      {required SearchParams params}) async {
    if (!hasMoreTripComeSearchData || isLoadingTripComeSearchMore) return;
    isLoadingTripComeSearchMore = true;
    emit(state.copyWith(status: SearchStates.loading));
    final response = await _fetchTripComeSearchUseCase.call(params);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: SearchStates.error)),
        (data) async {
      tripComeSearch.addAll(data);
      if (data.length < pageSize) {
        hasMoreTripComeSearchData = false;
      } else {
        tripComeSearchPage++;
      }
      isLoadingTripComeSearchMore = false;
      emit(state.copyWith(status: SearchStates.success));
    });
  }

  List<ReelsSearchEntity> reelsSearch = [];
  bool loadReelsSearch = false;
  bool isLoadingReelsSearchMore = false;
  bool hasMoreReelsSearchData = true;
  int reelsSearchPage = 1;

  Future<void> loadReelsSearchData({required SearchParams params}) async {
    loadReelsSearch = true;
    reelsSearch.clear();
    reelsSearchPage = 1;
    hasMoreReelsSearchData = true;
    isLoadingReelsSearchMore = false;

    emit(state.copyWith(status: SearchStates.loading));

    await getPaginatedReelsSearch(params: params);

    loadReelsSearch = false;
    // ❌ Don't re-emit success here; it's handled in getPaginatedReelsSearch
  }

  Future<void> getPaginatedReelsSearch({required SearchParams params}) async {
    if (!hasMoreReelsSearchData || isLoadingReelsSearchMore) return;

    isLoadingReelsSearchMore = true;
    emit(state.copyWith(status: SearchStates.loading));

    final response = await _fetchReelSearchUseCase.call(params);
    response.fold(
      (l) {
        isLoadingReelsSearchMore = false;
        emit(state.copyWith(failure: l, status: SearchStates.error));
      },
      (data) {
        reelsSearch.addAll(data);

        if (data.length < pageSize) {
          hasMoreReelsSearchData = false;
        } else {
          reelsSearchPage++;
        }

        isLoadingReelsSearchMore = false;
        emit(state.copyWith(
          status: SearchStates.success,
          reels: List<ReelsSearchEntity>.from(reelsSearch),
        ));
      },
    );
  }

  List<PostEntity> postsSearch = [];
  bool loadPostsSearch = false;

  // Future<void> loadPostsSearchData({required SearchParams params}) async {
  //   loadPostsSearch = true;
  //   postsSearch.clear();
  //   postsSearchPage = 1;
  //   hasMorePostsSearchData = true;
  //   isLoadingPostsSearchMore = false; // Important reset!
  //
  //   emit(state.copyWith(status: SearchStates.loading));
  //
  //   await getPaginatedPostsSearch(params: params);
  //
  //   loadPostsSearch = false;
  //   // emit(state.copyWith(status: SearchStates.success));
  // }

  Future<void> loadPostsSearchData({required SearchParams params}) async {
    loadPostsSearch = true;
    postsSearch.clear();
    postsSearchPage = 1;
    hasMorePostsSearchData = true;
    isLoadingPostsSearchMore = false; // Important reset!

    emit(state.copyWith(status: SearchStates.loading));

    await getPaginatedPostsSearch(params: params);

    loadPostsSearch = false;
    // ❌ Remove this emit. It's already emitted inside getPaginatedPostsSearch
    // emit(state.copyWith(status: SearchStates.success));
  }

  bool isLoadingPostsSearchMore = false;
  bool hasMorePostsSearchData = true;
  int postsSearchPage = 1;

  Future<void> getPaginatedPostsSearch({required SearchParams params}) async {
    if (!hasMorePostsSearchData || isLoadingPostsSearchMore) return;
    isLoadingPostsSearchMore = true;
    emit(state.copyWith(status: SearchStates.loading));
    final response = await _fetchPostsSearchUseCase.call(params);
    response.fold(
      (l) => emit(state.copyWith(failure: l, status: SearchStates.error)),
      (data) async {
        print("Fetched data: $data"); // Debug the data
        postsSearch.addAll(data);
        if (data.length < pageSize) {
          hasMorePostsSearchData = false;
        } else {
          postsSearchPage++;
        }
        isLoadingPostsSearchMore = false;
        // Make sure to update the state with the postsSearch list
        emit(state.copyWith(status: SearchStates.success, posts: postsSearch));
      },
    );
  }

  Future<bool> toggleFavoriteMedicalService(String subcategoryId) async {
    final response = await _toggleFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: SearchStates.error)),
        (data) {
      result = data;
      emit(state.copyWith(status: SearchStates.success));
    });
    return result;
  }

  Future<bool> toggleSubCategoryToFavorites(String subcategoryId) async {
    final response = await _toggleFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: SearchStates.error)),
        (data) {
      result = data;
      emit(state.copyWith(status: SearchStates.success));
    });
    return result;
  }

  Future<bool> onShare({required String postId}) async {
    var response = await _sharePostUseCase(
        SharePostParams(postId: postId, content: content ?? ''));
    var value = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: SearchStates.error)),
        (data) {
      value = data;
      emit(state.copyWith(status: SearchStates.success));
    });
    return value;
  }

  Future<void> deletePost(
      {required BuildContext context, required String postId}) async {
    final response = await _deletePostUseCase(postId);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: SearchStates.error)),
        (r) {
      postsSearch.removeWhere((e) => e.id == postId);
      emit(state.copyWith(posts: postsSearch));
      showSuccessMessage(context, "Post delete successfully");
    });
  }

  Future<bool> deleteComment(
      {required BuildContext context,
      required String commentId,
      required String postId,
      required String from}) async {
    final response = await _deleteCommentUseCase(commentId);
    bool result = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: SearchStates.error)),
        (r) {
      result = r;
      if (from == 'feed') {
        var currentPost =
            postsSearch.firstWhere((element) => element.id == postId);
        print("commmmmment count${currentPost.commentsCount}");

        // currentPost.commentsCount = (currentPost.commentsCount - 1);
      } else {
        if (state.postDetails != null) {
          // state.postDetails?.commentsCount =
          //     (state.postDetails!.commentsCount - 1);
        }
      }
      emit(state.copyWith(status: SearchStates.success));
      showSuccessMessage(context, "Comment delete successfully");
    });
    return result;
  }

  Future<void> hidePost(
      {required BuildContext context, required String postId}) async {
    final response = await _hidePostUseCase(postId);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: SearchStates.error)),
        (r) {
      postsSearch.removeWhere((e) => e.id == postId);
      emit(state.copyWith(posts: postsSearch));
      showSuccessMessage(context, "Post hide successfully");
    });
  }

  Future<CommentEntity> onPostComment(
      {required PostCommentParams params, required String from}) async {
    var response = await _postCommentUseCase(params);
    CommentEntity? model;
    response.fold(
        (failure) => emit(
              state.copyWith(failure: failure, status: SearchStates.error),
            ), (data) {
      model = data;
      if (from == 'feed') {
        print(postsSearch.length);
        var currentPost =
            postsSearch.firstWhere((element) => element.id == params.postId);
        print("comment count${currentPost.commentsCount}");

        // currentPost.commentsCount = (currentPost.commentsCount + 1);
      }
      emit(state.copyWith(status: SearchStates.success));
    });
    return model!;
  }

  // add reply
  Future<CommentEntity> replyOnComment(
      {required ReplyOnCommentParams params, required String from}) async {
    var response = await _replyOnCommentUseCase(params);
    CommentEntity? model;
    response.fold(
        (failure) => emit(
              state.copyWith(failure: failure, status: SearchStates.error),
            ), (data) {
      model = data;
      if (from == 'feed') {
        var currentPost =
            postsSearch.firstWhere((element) => element.id == params.postId);
        print("commmmmment count${currentPost.commentsCount}");

        // currentPost.commentsCount = (currentPost.commentsCount + 1);
      }

      emit(state.copyWith(newComment: data, status: SearchStates.success));
    });
    return model!;
  }

  Future<bool> onReact(
      {required PostReactParams params, required String from}) async {
    var response = await _postReactUseCase(params);
    bool value = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: SearchStates.error)),
        (r) {
      if (from == 'details') {
        // changeReaction(state.postDetails, params.react);
      } else if (from == 'userPosts') {
        // var currentUserPost = userPostsPagingController.itemList
        //     ?.firstWhere((element) => element.id == params.postId);
        // changeReaction(currentUserPost, params.react);
      } else {
        var currentPost =
            postsSearch.firstWhere((element) => element.id == params.postId);
        changeReaction(currentPost, params.react);
        changeReaction(state.postDetails, params.react);
        // changeReaction(currentUserPost, params.react);
      }
      value = r;
      emit(state.copyWith(status: SearchStates.success));
    });
    return value;
  }

  Future<bool> editComment({required PostCommentParams params}) async {
    var response = await _editCommentUseCase(params);
    bool value = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: SearchStates.error)),
        (r) {
      value = r;
    });
    return value;
  }

  Future<bool> onCommentReact({required PostReactParams params}) async {
    var response = await _commentReactUseCase(params);
    bool value = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: SearchStates.error)),
        (r) {
      print(params.postId);

      value = r;
    });
    return value;
  }

  Future<void> loadDataMain() async {
    emit(state.copyWith(status: SearchStates.loading));
    await UserCubit.to.getUser();
    {
      final user = UserCubit.to.state.data?.id;
      print('userId1$user');
      print('userId1$user');
      final result = await _getMainCategoriesUseCase(
          MainCategoriesParams(page: 1, limit: 100, userId: user ?? ''));

      result.fold(
        (failure) {
          emit(state.copyWith(
            failure: failure,
            status: SearchStates.error,
          ));
          CliLogger.error(
              'can\'t load main categories there is an error ${failure.toString()}');
        },
        (r) {
          emit(state.copyWith(status: SearchStates.success, mainCategory: r));
        },
      );
    }
  }
}
