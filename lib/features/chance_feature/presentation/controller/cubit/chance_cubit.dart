import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/sub_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_rate_use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_main_category.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_sub_category.dart';
import '../../../domain/use_case/add_chance_data.dart';
import '../../../domain/use_case/create_chance_ad_use_case.dart';
import '../../../domain/use_case/get_all_chance_ads_use_case.dart';
import '../../../domain/use_case/get_chance_ad_details_use_case.dart';
import '../../../domain/use_case/join_chance_ad_use_case.dart';
import '../../../domain/use_case/search_chance_ads_use_case.dart';
import '../../../domain/use_case/toggle_chance_ad_favorite_use_case.dart';
import '../../../domain/use_case/get_favorite_chance_ads_use_case.dart';
import '../../../domain/use_case/get_my_chance_ads_use_case.dart';
import '../../../domain/use_case/get_expired_chance_ads_use_case.dart';
import '../../../domain/use_case/get_chance_ad_winners_use_case.dart';
import '../../../domain/use_case/increment_chance_ad_view_use_case.dart';
import '../../../domain/use_case/get_winner_statistics_use_case.dart';
import '../../../domain/entity/chance_ad_entity.dart';
import 'chance_states.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

class ChanceCubit extends Cubit<ChanceState> {
  final FetchChanceUseCase _fetchChanceUseCase;
  final AddChanceUseCase _addChanceUseCase;
  final GetChanceRateUseCase _getChanceRateUseCase;
  final MainCategoryChanceUseCase _mainCategoryChanceUseCase;
  final SubCategoryChanceUseCase _subCategoryChanceUseCase;
  final CreateChanceAdUseCase _createChanceAdUseCase;
  final JoinChanceAdUseCase _joinChanceAdUseCase;
  final GetAllChanceAdsUseCase _getAllChanceAdsUseCase;
  final GetChanceAdDetailsUseCase _getChanceAdDetailsUseCase;
  final SearchChanceAdsUseCase _searchChanceAdsUseCase;
  final ToggleChanceAdFavoriteUseCase _toggleChanceAdFavoriteUseCase;
  final GetFavoriteChanceAdsUseCase _getFavoriteChanceAdsUseCase;
  final GetMyChanceAdsUseCase _getMyChanceAdsUseCase;
  final GetExpiredChanceAdsUseCase _getExpiredChanceAdsUseCase;
  final GetChanceAdWinnersUseCase _getChanceAdWinnersUseCase;
  final IncrementChanceAdViewUseCase _incrementChanceAdViewUseCase;
  final GetWinnerStatisticsUseCase _getWinnerStatisticsUseCase;

  ChanceCubit(
    this._fetchChanceUseCase,
    this._addChanceUseCase,
    this._getChanceRateUseCase,
    this._mainCategoryChanceUseCase,
    this._subCategoryChanceUseCase,
    this._createChanceAdUseCase,
    this._joinChanceAdUseCase,
    this._getAllChanceAdsUseCase,
    this._getChanceAdDetailsUseCase,
    this._searchChanceAdsUseCase,
    this._toggleChanceAdFavoriteUseCase,
    this._getFavoriteChanceAdsUseCase,
    this._getMyChanceAdsUseCase,
    this._getExpiredChanceAdsUseCase,
    this._getChanceAdWinnersUseCase,
    this._incrementChanceAdViewUseCase,
    this._getWinnerStatisticsUseCase,
  ) : super(const ChanceState());

  // Future<void> fetchChance() async {
  //   emit(state.copyWith(status: ChanceStates.loading));
  //   final result = await _fetchChanceUseCase(const NoParams());
  //
  //   result.fold(
  //     (failure) => emit(state.copyWith(status: ChanceStates.error, failure: failure)),
  //     (chance) => emit(state.copyWith(chance: chance, status: ChanceStates.success)),
  //   );
  // }

  Future<void> fetchChance() async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = _fetchChanceUseCase.call(const NoParams());
    return response.then((value) {
      print('_____________________');
      print(value);
      emit(state.copyWith(chance: value, status: ChanceStates.success));
    }).catchError((error) {
      print('_____________________');
      print(error.toString());
      print('_____________________');
      emit(state.copyWith(status: ChanceStates.error));
    });
    // response.fold((l) {
    //   print(getFailureMessage(l, AppPages.router.configuration.navigatorKey.currentContext!));
    //   emit(state.copyWith(failure: l, status: ChanceStates.error));
    // }, (data) {
    //   print('*********************');
    //   print(data);
    //   emit(state.copyWith(chance: data));
    // });
  }

  Future<void> addChance(AddChanceParams params) async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = await _addChanceUseCase(params);
    return response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        print('Error');
        print(failure.toString());
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (response) {
        print('Success');
        print(response);
        emit(state.copyWith(status: ChanceStates.success));
        fetchChance();
      },
    );
  }

  Future<void> getChanceRate({required String id}) async {
    final response = await _getChanceRateUseCase(
      ChanceRateParams(chanceRateParams: id),
    );
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: ChanceStates.error));
    }, (data) {
      emit(state.copyWith(rate: data, status: ChanceStates.success));
    });
  }

  Future<List<MainCategoryDropEntity>> fetchMainCategoryChance(
      {required PaginationParams paginationParams}) async {
    List<MainCategoryDropEntity> category = [];
    final response = await _mainCategoryChanceUseCase(
      MainCategoryChanceParams(
        paginationParams: paginationParams,
      ),
    );
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: ChanceStates.error));
    }, (data) {
      category = data;
    });
    return category;
  }

  Future<List<SubCategoryDropEntity>> fetchSubCategoryChance(
      {required PaginationParams paginationParams, required String id}) async {
    List<SubCategoryDropEntity> category = [];
    final response = await _subCategoryChanceUseCase(
      SubCategoryChanceParams(
        id: id,
        paginationParams: paginationParams,
      ),
    );
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: ChanceStates.error));
    }, (data) {
      category = data;
    });
    return category;
  }

  // New Chance Ads Methods
  Future<void> createChanceAd(CreateChanceAdParams params) async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = await _createChanceAdUseCase(params);
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (chanceAd) {
        emit(state.copyWith(status: ChanceStates.createSuccess));
        // Clear uploaded images after successful creation
        emit(state.copyWith(uploadedImageIds: []));
        // Refresh the chance ads list
        getAllChanceAds();
      },
    );
  }

  Future<void> joinChanceAd(JoinChanceAdParams params) async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = await _joinChanceAdUseCase(params);
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (success) {
        emit(state.copyWith(status: ChanceStates.joinSuccess));
        // Refresh the chance ads list
        getAllChanceAds();
      },
    );
  }

  Future<void> getAllChanceAds({int page = 1, int limit = 10}) async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = await _getAllChanceAdsUseCase(
      GetAllChanceAdsParams(
        paginationParams: PaginationParams(page: page, limit: limit),
      ),
    );
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (chanceAdsPagination) {
        // Check if we've reached the end or if there's no new data
        if (page > chanceAdsPagination.pagination.pages ||
            (page > 1 && chanceAdsPagination.data.isEmpty)) {
          // No more data to load, keep current state
          emit(state.copyWith(status: ChanceStates.success));
          return;
        }

        List<ChanceAdEntity> allChanceAds;

        if (page == 1) {
          // First page - replace existing data
          allChanceAds = chanceAdsPagination.data;
        } else {
          // Subsequent pages - append to existing data only if there's new data
          allChanceAds = List.from(state.chanceAds ?? []);
          if (chanceAdsPagination.data.isNotEmpty) {
            allChanceAds.addAll(chanceAdsPagination.data);
          }
        }

        emit(state.copyWith(
          chanceAdsPagination: chanceAdsPagination,
          chanceAds: allChanceAds,
          status: ChanceStates.success,
        ));
      },
    );
  }

  Future<void> getChanceAdDetails(String adId) async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = await _getChanceAdDetailsUseCase(
      GetChanceAdDetailsParams(adId: adId),
    );
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (chanceAdDetails) {
        emit(state.copyWith(
          chanceAdDetails: chanceAdDetails,
          status: ChanceStates.success,
        ));
      },
    );
  }

  Future<void> searchChanceAds(String keyword) async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = await _searchChanceAdsUseCase(
      SearchChanceAdsParams(keyword: keyword),
    );
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (searchResults) {
        emit(state.copyWith(
          searchResults: searchResults,
          status: ChanceStates.success,
        ));
      },
    );
  }

  Future<void> toggleChanceAdFavorite(String adId) async {
    if (adId.isEmpty) {
      print('Error: Cannot toggle favorite - adId is empty');
      return;
    }

    print('ChanceCubit: Toggling favorite for adId: $adId');
    final response = await _toggleChanceAdFavoriteUseCase(
      ToggleChanceAdFavoriteParams(adId: adId),
    );
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (isFavorite) {
        // Update the specific ad in the lists
        _updateAdFavoriteStatus(adId, isFavorite);
      },
    );
  }

  void _updateAdFavoriteStatus(String adId, bool isFavorite) {
    // Update in chanceAds list if it exists
    if (state.chanceAds != null) {
      final updatedChanceAds = state.chanceAds!.map((ad) {
        if (ad.id == adId) {
          return ad.copyWith(isFavorite: isFavorite);
        }
        return ad;
      }).toList();
      emit(state.copyWith(chanceAds: updatedChanceAds));
    }

    // Update in favoriteChanceAds list if it exists
    if (state.favoriteChanceAds != null) {
      final updatedFavoriteAds = state.favoriteChanceAds!.map((ad) {
        if (ad.id == adId) {
          return ad.copyWith(isFavorite: isFavorite);
        }
        return ad;
      }).toList();
      emit(state.copyWith(favoriteChanceAds: updatedFavoriteAds));
    }

    // Update in chanceAdDetails if it exists and matches the adId
    if (state.chanceAdDetails != null && state.chanceAdDetails!.id == adId) {
      final updatedDetails =
          state.chanceAdDetails!.copyWith(isFavorite: isFavorite);
      emit(state.copyWith(chanceAdDetails: updatedDetails));
    }
  }

  void addUploadedImageId(String imageId) {
    final updatedIds = List<String>.from(state.uploadedImageIds)..add(imageId);
    emit(state.copyWith(uploadedImageIds: updatedIds));
  }

  void removeUploadedImageId(String imageId) {
    final updatedIds = List<String>.from(state.uploadedImageIds)
      ..remove(imageId);
    emit(state.copyWith(uploadedImageIds: updatedIds));
  }

  void clearUploadedImages() {
    emit(state.copyWith(uploadedImageIds: []));
  }

  Future<void> getFavoriteChanceAds() async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = await _getFavoriteChanceAdsUseCase(const NoParams());
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (favoriteAds) {
        emit(state.copyWith(
          favoriteChanceAds: favoriteAds,
          status: ChanceStates.success,
        ));
      },
    );
  }

  Future<void> getMyChanceAds() async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = await _getMyChanceAdsUseCase(const NoParams());
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (myAds) {
        emit(state.copyWith(
          myChanceAds: myAds,
          status: ChanceStates.success,
        ));
      },
    );
  }

  Future<void> getExpiredChanceAds() async {
    emit(state.copyWith(status: ChanceStates.loading));
    final response = await _getExpiredChanceAdsUseCase(const NoParams());
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (expiredAds) {
        emit(
          state.copyWith(
            expiredChanceAds: expiredAds,
            status: ChanceStates.success,
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> getWinnerData(String adId) async {
    try {
      final result = await _getChanceAdWinnersUseCase(adId);
      return result.fold(
        (failure) {
          print('ERROR getting winner data: ${failure.toString()}');
          return null;
        },
        (winners) {
          if (winners.isNotEmpty) {
            final winner = winners.first;
            return {
              'name':
                  '${winner['userId']['firstName']} ${winner['userId']['lastName']}',
              'profilePicture': winner['userId']['USER_PROFILE']
                  ?['profilePictureKey']?['mediaKey'],
              'amount': winner['amount'],
            };
          }
          return null;
        },
      );
    } catch (e) {
      print('ERROR in getWinnerData: $e');
      return null;
    }
  }

  Future<void> incrementChanceAdView(String adId) async {
    print('ChanceCubit: incrementChanceAdView called with adId: $adId');
    try {
      final result = await _incrementChanceAdViewUseCase(adId);
      result.fold(
        (failure) => print('ERROR incrementing view: ${failure.toString()}'),
        (success) => print('SUCCESS: View count incremented'),
      );
    } catch (e) {
      print('EXCEPTION in incrementChanceAdView: $e');
    }
  }

  Future<void> getWinnerStatistics() async {
    final response = await _getWinnerStatisticsUseCase(const NoParams());
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: ChanceStates.error));
      },
      (winnerStatistics) {
        emit(state.copyWith(
          winnerStatistics: winnerStatistics,
          status: ChanceStates.success,
        ));
      },
    );
  }

  Future<void> getChanceWinners() async {
    // This method was referenced in ChanceWinnersView but didn't exist
    // For now, we'll use getWinnerStatistics, but you can implement
    // a separate endpoint for getting actual winner list if needed
    await getWinnerStatistics();
  }
}
