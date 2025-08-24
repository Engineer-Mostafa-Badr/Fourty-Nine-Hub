import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../domain/entity/star_entity.dart';
import '../../../domain/entity/star_winner_entity.dart';
import '../../../domain/use_case/delete_my_star_use_case.dart';
import '../../../domain/use_case/fetch_all_star_use_case.dart';
import '../../../domain/use_case/fetch_banner_use_case.dart';
import '../../../domain/use_case/fetch_myl_star_use_case.dart';
import '../../../domain/use_case/fetch_winner_star_use_case.dart';
import '../../../domain/use_case/upload_my_star_use_case.dart';
import 'star_state.dart';

class StarCubit extends Cubit<StarState> {
  final FetchAllStarUseCase _allStarUseCase;
  final FetchMylStarUseCase _fetchMylStarUseCase;
  final FetchWinnerStarUseCase _fetchWinnerStarUseCase;
  final UploadMyStarUseCase _uploadMyStarUseCase;
  final DeleteMyStarUseCase _deleteMyTalentUseCase;
  final FetchBannerUseCase _bannerUseCase;

  StarCubit(
      this._allStarUseCase,
      this._fetchMylStarUseCase,
      this._uploadMyStarUseCase,
      this._deleteMyTalentUseCase,
      this._fetchWinnerStarUseCase,
      this._bannerUseCase)
      : super(StarState());

  List<StarEntity> star = [];
  List<StarWinnerEntity> winner = [];

  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  void loadInitialData() async {
    emit(state.copyWith(status: StarStates.loading));
    star.clear();
    currentPage = 1;
    hasMoreData = true;
    await getAllTalent(refresh: true);
  }

  List<StarEntity> allTalents = [];
  bool loadAllTalents = false;

  // Favorites functionality
  final Set<String> _favoriteIds = {};
  Set<String> get favoriteIds => _favoriteIds;

  List<StarEntity> get favoriteTalents {
    return allTalents
        .where((talent) => _favoriteIds.contains(talent.id))
        .toList();
  }

  void toggleFavorite(String talentId) {
    if (_favoriteIds.contains(talentId)) {
      _favoriteIds.remove(talentId);
    } else {
      _favoriteIds.add(talentId);
    }
    emit(state.copyWith(favoriteIds: _favoriteIds));
  }

  bool isFavorite(String talentId) {
    return _favoriteIds.contains(talentId);
  }

  Future loadAllTalentsData() async {
    loadAllTalents = true;
    allTalents.clear();
    allTalentsPage = 1;
    hasMoreAllTalentsData = true;
    emit(state.copyWith(status: StarStates.loading));
    await Future.wait([getAllTalents(), fetchBanner()]);
    loadAllTalents = false;
    emit(state.copyWith(status: StarStates.success));
  }

  bool isLoadingAllTalentsMore = false;
  bool hasMoreAllTalentsData = true;
  int allTalentsPage = 1;

  Future<void> getAllTalents() async {
    if (!hasMoreAllTalentsData || isLoadingAllTalentsMore) return;
    isLoadingAllTalentsMore = true;
    emit(state.copyWith(status: StarStates.loading));
    final response = await _allStarUseCase(
      StarPaginationParams(page: allTalentsPage, limit: pageSize),
    );
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: StarStates.error));
    }, (data) async {
      allTalents.addAll(data);
      if (data.length < pageSize) {
        hasMoreAllTalentsData = false;
      } else {
        allTalentsPage++;
      }
      isLoadingAllTalentsMore = false;
      emit(state.copyWith(status: StarStates.success));
    });
  }

  List<StarEntity> myTalents = [];
  bool loadMyTalents = false;

  Future loadMyTalentsData() async {
    loadMyTalents = true;
    myTalents.clear();
    myTalentsPage = 1;
    hasMoreMyTalentsData = true;
    emit(state.copyWith(status: StarStates.loading));
    await getMyTalents();
    loadMyTalents = false;
    emit(state.copyWith(status: StarStates.success));
  }

  bool isLoadingMyTalentsMore = false;
  bool hasMoreMyTalentsData = true;
  int myTalentsPage = 1;

  Future<void> getMyTalents() async {
    if (!hasMoreMyTalentsData || isLoadingMyTalentsMore) return;
    isLoadingMyTalentsMore = true;
    emit(state.copyWith(status: StarStates.loading));
    final response = await _fetchMylStarUseCase.call(const NoParams());

    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: StarStates.error));
    }, (data) async {
      myTalents.addAll(data);
      if (data.length < pageSize) {
        hasMoreMyTalentsData = false;
      } else {
        myTalentsPage++;
      }
      isLoadingMyTalentsMore = false;
      emit(state.copyWith(status: StarStates.success));
    });
  }

  void loadInitialDataWinner() async {
    emit(state.copyWith(status: StarStates.loading));
    winner.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchWinnerStar();
  }

  Future<void> getAllTalent({bool refresh = false}) async {
    if (refresh) {
      star.clear();
      currentPage = 1;
      hasMoreData = true;
      isLoadingMore = false;
    }

    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _allStarUseCase(
      StarPaginationParams(page: currentPage, limit: pageSize),
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: StarStates.error));
      },
      (data) {
        if (refresh) {
          star = data;
        } else {
          star.addAll(data);
        }

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(star: star, status: StarStates.success));
      },
    );
  }

  Future<void> fetchWinnerStar() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _fetchWinnerStarUseCase(
      StarPaginationParams(page: currentPage, limit: pageSize),
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: StarStates.error));
      },
      (data) {
        winner.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(winner: winner, status: StarStates.success));
      },
    );
  }

  Future<bool> uploadStar({
    required StarParams params,
  }) async {
    emit(state.copyWith(status: StarStates.loading));

    final response = await _uploadMyStarUseCase(params);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: StarStates.error));
        return false;
      },
      (data) {
        emit(state.copyWith(
          status: StarStates.uploadSuccess,
        ));
        return true;
      },
    );
    return false;
  }

  Future<void> fetchBanner() async {
    emit(state.copyWith(status: StarStates.loading));

    final response = await _bannerUseCase(const NoParams());

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: StarStates.error));
      },
      (data) {
        emit(state.copyWith(
          banner: data,
          status: StarStates.success,
        ));
      },
    );
  }

  Future<void> deleteMyTalent({
    required String id,
  }) async {
    emit(state.copyWith(status: StarStates.loading));

    final response = await _deleteMyTalentUseCase(id);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: StarStates.error));
      },
      (data) {
        // Remove from local lists
        allTalents.removeWhere((talent) => talent.id == id);
        myTalents.removeWhere((talent) => talent.id == id);
        star.removeWhere((talent) => talent.id == id);
        _favoriteIds.remove(id);

        emit(state.copyWith(
          status: StarStates.success,
          favoriteIds: _favoriteIds,
        ));
      },
    );
  }

  List<String>? selectedVideo;

  uploadVideo({bool isGallery = true, required BuildContext context}) async {
    final UploadFile upload = UploadFile();
    await upload.uploadVideo(
        isGallery: isGallery,
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          selectedVideo?.add(data.mediaId);
          final video = state.video ?? [];
          video.add(data);
          selectedVideo = video.map((e) => e.mediaId).toList();
          emit(state.copyWith(video: video, status: StarStates.success));
        },
        context: context);
  }

  changeRating(String id, int rating) {
    // Update in all relevant lists
    allTalents = allTalents.map((element) {
      if (element.id == id) {
        return element.copyWith(averageRating: rating);
      }
      return element;
    }).toList();

    star = star.map((element) {
      if (element.id == id) {
        return element.copyWith(averageRating: rating);
      }
      return element;
    }).toList();

    myTalents = myTalents.map((element) {
      if (element.id == id) {
        return element.copyWith(averageRating: rating);
      }
      return element;
    }).toList();

    emit(state.copyWith());
  }

  void clearSelectedVideos() {
    selectedVideo = [];
    emit(state.copyWith(video: []));
  }
}
