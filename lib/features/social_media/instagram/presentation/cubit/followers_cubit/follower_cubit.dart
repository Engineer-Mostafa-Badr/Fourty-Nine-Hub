import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/followers_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/following_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_all_followers_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_all_following_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/followers_cubit/followers_state.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';

class FollowCubit extends Cubit<FollowState> {
  final GetAllFollowersUseCase _allFollowersUseCase;
  final GetAllFollowingUseCase _allFollowingUseCase;

  TextEditingController searchController = TextEditingController();
  List<FollowersEntity> followers = [];
  List<FollowingEntity> following = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final int pageSize;

  FollowCubit(this._allFollowersUseCase, this._allFollowingUseCase, {this.pageSize = 10})
      : super(FollowState());

  void loadInitialData(String search) async {
    emit(state.copyWith(status: FollowStates.loading, failure: null));
    followers.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchAllFollowers(search);
  }

  void loadInitialDataFollowing(String search) async {
    emit(state.copyWith(status: FollowStates.loading, failure: null));
    following.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchAllFollowing(search);
  }
  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }

  Future<void> _fetchData<T>(
      String search, Function(TwitterFeedParams) useCase, List<T> dataList) async {
    if (!hasMoreData || isLoadingMore) return;

    emit(state.copyWith(status: FollowStates.loading));
    isLoadingMore = true;

    final response = await useCase(
      TwitterFeedParams(page: currentPage, limit: pageSize, search: search),
    );

    response.fold(
          (failure) {
        isLoadingMore = false;
        emit(state.copyWith(failure: failure, status: FollowStates.error));
      },
          (data) {
        dataList.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(status: FollowStates.success));
      },
    );
  }

  Future<void> fetchAllFollowers(String search) async {
    await _fetchData(search, _allFollowersUseCase.call, followers);
  }

  Future<void> fetchAllFollowing(String search) async {
    await _fetchData(search, _allFollowingUseCase.call, following);
  }
}

