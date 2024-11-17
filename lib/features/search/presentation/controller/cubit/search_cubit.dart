import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/change_react.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
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
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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

  SearchCubit(this._fetchSearchUseCase,
      this._toggleFavoriteCategoryUseCase,
      this._fetchUserSearchUseCase,
      this._fetchAdsSearchUseCase, this._fetchPostsSearchUseCase,
      this._sharePostUseCase,
      this._deletePostUseCase, this._deleteCommentUseCase,
      this._hidePostUseCase, this._postReactUseCase,
       this._postCommentUseCase, this._replyOnCommentUseCase, this._editCommentUseCase, this._commentReactUseCase, this._fetchTripComeSearchUseCase, this._fetchReelSearchUseCase, this._fetchSearchSubCategoryUseCase,) : super(SearchState());

  TextEditingController searchController = TextEditingController();
  final shareFormKey = GlobalKey<FormState>();

  String? content;

  void changeContent({
    required String v,
  }) {
    content = v;
    print(content);
  }

  void onRefresh() async {
    searchPagingController.refresh();
    searchPagingSubCategoryController.refresh();
    searchPagingUserController.refresh();
    searchPagingAdsController.refresh();
    searchPagingPostsController.refresh();
    searchPagingTripComeController.refresh();
    searchPagingReelsController.refresh();
  }

  initPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filter', 'totalUsers');
  }

  void loadData(SearchParams params) async {
    //   await getFeed(1);
    getPaginatedSearch(params, 1);
    getPaginatedSubCategorySearch(params, 1);
    getPaginatedUserSearch(params, 1);
    getPaginatedAdsSearch(params, 1);
    getPaginatedPostsSearch(params, 1);
    getPaginatedTripComeSearch(params, 1);
    getPaginatedReelsSearch(params, 1);
    searchPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedSearch(params, pageKey);
    });
    searchPagingSubCategoryController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedSearch(params, pageKey);
    });
    searchPagingUserController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedUserSearch(params, pageKey);
    });
    searchPagingAdsController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedAdsSearch(params, pageKey);
    });
    searchPagingPostsController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedPostsSearch(params, pageKey);
    });
    searchPagingTripComeController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedTripComeSearch(params, pageKey);
    });
    searchPagingReelsController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedReelsSearch(params, pageKey);
    });
  }

  final PagingController<int, MainCategoryEntity>
  searchPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, SubCategoryEntity>
  searchPagingSubCategoryController = PagingController(firstPageKey: 1);
  final PagingController<int, UserSearchEntity> searchPagingUserController =
  PagingController(firstPageKey: 1);
  final PagingController<int, AdsSearchEntity> searchPagingAdsController =
  PagingController(firstPageKey: 1);
  final PagingController<int, PostEntity> searchPagingPostsController =
  PagingController(firstPageKey: 1);
  final int pageSize = 10;
  final PagingController<int, TripComeWithYouEntity> searchPagingTripComeController =
  PagingController(firstPageKey: 1);
  final PagingController<int, ReelsSearchEntity> searchPagingReelsController =
  PagingController(firstPageKey: 1);

  Future<List<MainCategoryEntity>> getPaginatedSearch(
      SearchParams params, int page) async {
    emit(state.copyWith(status: SearchStates.loading));
    List<MainCategoryEntity> main = [];
    final response = await _fetchSearchUseCase.call(params);

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: SearchStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        searchPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        searchPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        searchPagingController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      main = data;
      emit(state.copyWith(search: data, status: SearchStates.success));
    });
    return main;
  }

  Future<List<SubCategoryEntity>> getPaginatedSubCategorySearch(
      SearchParams params, int page) async {
    emit(state.copyWith(status: SearchStates.loading));
    List<SubCategoryEntity> sub = [];
    final response = await _fetchSearchSubCategoryUseCase.call(params);

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: SearchStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        searchPagingSubCategoryController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        searchPagingSubCategoryController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        searchPagingSubCategoryController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      sub = data;
      emit(state.copyWith(searchSubCategory: data, status: SearchStates.success));
    });
    return sub;
  }

  Future<List<UserSearchEntity>> getPaginatedUserSearch(SearchParams params,
      int page) async {
    emit(state.copyWith(status: SearchStates.loading));
    List<UserSearchEntity> user = [];
    final response = await _fetchUserSearchUseCase.call(params);

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: SearchStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        searchPagingUserController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        searchPagingUserController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        searchPagingUserController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      user = data;
      emit(state.copyWith(userSearch: data, status: SearchStates.success));
    });
    return user;
  }


  Future<List<AdsSearchEntity>> getPaginatedAdsSearch(SearchParams params,
      int page) async {
    emit(state.copyWith(status: SearchStates.loading));
    List<AdsSearchEntity> ads = [];
    final response = await _fetchAdsSearchUseCase.call(params);

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: SearchStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        searchPagingAdsController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        searchPagingAdsController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        searchPagingAdsController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      ads = data;
      emit(state.copyWith(adsSearch: data, status: SearchStates.success));
    });
    return ads;
  }


  Future<List<TripComeWithYouEntity>> getPaginatedTripComeSearch(SearchParams params,
      int page) async {
    emit(state.copyWith(status: SearchStates.loading));
    List<TripComeWithYouEntity> tripCome = [];
    final response = await _fetchTripComeSearchUseCase.call(params);

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: SearchStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        searchPagingTripComeController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        searchPagingTripComeController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        searchPagingTripComeController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      tripCome = data;
      emit(state.copyWith(tripCome: data, status: SearchStates.success));
    });
    return tripCome;
  }

  Future<List<ReelsSearchEntity>> getPaginatedReelsSearch(SearchParams params,
      int page) async {
    emit(state.copyWith(status: SearchStates.loading));
    List<ReelsSearchEntity> reels = [];
    final response = await _fetchReelSearchUseCase.call(params);

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: SearchStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        searchPagingReelsController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        searchPagingReelsController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        searchPagingReelsController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      reels = data;
      emit(state.copyWith(reels: data, status: SearchStates.success));
    });
    return reels;
  }



  Future<List<PostEntity>> getPaginatedPostsSearch(SearchParams params,
      int page) async {
    emit(state.copyWith(status: SearchStates.loading));
    List<PostEntity> posts = [];
    final response = await _fetchPostsSearchUseCase.call(params);

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: SearchStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        searchPagingPostsController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        searchPagingPostsController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        searchPagingPostsController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      posts = data;
      emit(state.copyWith(posts: data, status: SearchStates.success));
    });
    return posts;
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
          searchPagingPostsController.itemList?.removeWhere((e) => e.id == postId);
          emit(state.copyWith(posts: searchPagingPostsController.itemList));
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
            var currentPost = searchPagingPostsController.itemList
                ?.firstWhere((element) => element.id == postId);
            print("commmmmment count${currentPost?.commentsCount}");

            currentPost?.commentsCount = (currentPost.commentsCount! - 1);
          } else {
            if (state.postDetails != null) {
              state.postDetails?.commentsCount =
              (state.postDetails!.commentsCount! - 1);
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
          searchPagingPostsController.itemList?.removeWhere((e) => e.id == postId);
          emit(state.copyWith(posts: searchPagingPostsController.itemList));
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
        print(searchPagingPostsController.itemList!.length);
        var currentPost = searchPagingPostsController.itemList
            ?.firstWhere((element) => element.id == params.postId);
        print("comment count${currentPost?.commentsCount}");

        currentPost?.commentsCount = (currentPost.commentsCount! + 1);
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
        var currentPost = searchPagingPostsController.itemList
            ?.firstWhere((element) => element.id == params.postId);
        print("commmmmment count${currentPost?.commentsCount}");

        currentPost?.commentsCount = (currentPost.commentsCount! + 1);
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
            var currentPost = searchPagingPostsController.itemList
                ?.firstWhere((element) => element.id == params.postId);
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


  final PagingController<int, CommentEntity> commentsPagingController =
  PagingController(firstPageKey: 1);
  final PagingController<int, CommentEntity> repliesPagingController =
  PagingController(firstPageKey: 1);

  Future<bool> onCommentReact({required PostReactParams params}) async {
    var response = await _commentReactUseCase(params);
    bool value = false;
    response.fold(
            (failure) =>
            emit(state.copyWith(failure: failure, status: SearchStates.error)),
            (r) {
          print(params.postId);
          var currentComment = commentsPagingController.itemList
              ?.firstWhere((element) => element.id == params.postId);
          var currentReply = repliesPagingController.itemList
              ?.firstWhere((element) => element.id == params.postId);
          changeReaction(currentComment, params.react);
          changeReaction(currentReply, params.react);
          value = r;
        });
    return value;
  }
}
