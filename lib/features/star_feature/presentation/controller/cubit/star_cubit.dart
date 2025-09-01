import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../domain/entity/profile_entity.dart';
import '../../../domain/entity/star_entity.dart';
import '../../../domain/entity/star_winner_entity.dart';
import '../../../domain/use_case/delete_my_star_use_case.dart';
import '../../../domain/use_case/fetch_all_star_use_case.dart';
import '../../../domain/use_case/fetch_banner_use_case.dart';
import '../../../domain/use_case/fetch_myl_star_use_case.dart';
import '../../../domain/use_case/fetch_winner_star_use_case.dart';
import '../../../domain/use_case/search_profiles_use_case.dart';
import '../../../domain/use_case/upload_my_star_use_case.dart';
import 'star_state.dart';

class StarCubit extends Cubit<StarState> {
  final FetchAllStarUseCase _allStarUseCase;
  final FetchMylStarUseCase _fetchMylStarUseCase;
  final FetchWinnerStarUseCase _fetchWinnerStarUseCase;
  final UploadMyStarUseCase _uploadMyStarUseCase;
  final DeleteMyStarUseCase _deleteMyTalentUseCase;
  final FetchBannerUseCase _bannerUseCase;
  final SearchProfilesUseCase _searchProfilesUseCase;

  static const int pageSize = 10;

  StarCubit(
    this._allStarUseCase,
    this._fetchMylStarUseCase,
    this._uploadMyStarUseCase,
    this._deleteMyTalentUseCase,
    this._fetchWinnerStarUseCase,
    this._bannerUseCase,
    this._searchProfilesUseCase,
  ) : super(StarState());

  // Initialize all data
  Future<void> initializeAllData() async {
    emit(state.copyWith(status: StarStates.loading));

    await Future.wait([
      loadTalents(TalentCategory.available, refresh: true),
      loadTalents(TalentCategory.myTalents, refresh: true),
      _fetchBanner(),
    ]);

    emit(state.copyWith(status: StarStates.success));
  }

  // Unified method to load talents by category
  Future<void> loadTalents(
    TalentCategory category, {
    bool refresh = false,
  }) async {
    if (refresh) {
      _resetPagination(category);
    }

    if (state.isLoading(category) || !state.hasMore(category)) return;

    // Update loading state
    final newLoadingStates =
        Map<TalentCategory, bool>.from(state.loadingStates);
    newLoadingStates[category] = true;
    emit(state.copyWith(loadingStates: newLoadingStates));

    try {
      List<StarEntity> newTalents = [];

      switch (category) {
        case TalentCategory.available:
          newTalents = await _fetchAvailableTalents();
          break;
        case TalentCategory.myTalents:
          newTalents = await _fetchMyTalents();
          break;
        case TalentCategory.history:
          newTalents = await _fetchHistoryTalents();
          break;
        case TalentCategory.favorites:
          newTalents = _updateFavoritesList();
          break;
      }

      _updateTalentsData(category, newTalents, refresh);
    } catch (e) {
      _handleError(category, e);
    }
  }

  Future<List<StarEntity>> _fetchAvailableTalents() async {
    final response = await _allStarUseCase(
      StarPaginationParams(
        page: state.getCurrentPage(TalentCategory.available),
        limit: pageSize,
      ),
    );

    return response.fold(
      (failure) => throw failure,
      (data) => data,
    );
  }

  // Future<List<StarEntity>> _fetchAvailableTalents() async {
  //   final response = await _allStarUseCase(
  //     StarPaginationParams(
  //       page: state.getCurrentPage(TalentCategory.available),
  //       limit: pageSize,
  //     ),
  //   );

  //   return response.fold(
  //     (failure) => throw failure,
  //     (data) {
  //       // تكرار البيانات 5 مرات لملء الشاشة للتجربة
  //       List<StarEntity> duplicatedData = [];
  //       for (int i = 0; i < 5; i++) {
  //         duplicatedData.addAll(data.map((talent) {
  //           // Create a copy with modified ID to avoid duplicates
  //           return StarEntity(
  //             id: '${talent.id}_copy_$i',
  //             title: talent.title,
  //             description: talent.description,
  //             user: talent.user,
  //             mediaUrl: talent.mediaUrl,
  //             totalViews: talent.totalViews,
  //             averageRating: talent.averageRating,
  //             isApproved: talent.isApproved,
  //             haveStories: talent.haveStories,
  //             storyCount: talent.storyCount,
  //             createdAt: talent.createdAt,
  //           );
  //         }));
  //       }
  //       return duplicatedData;
  //     },
  //   );
  // }

  Future<List<StarEntity>> _fetchMyTalents() async {
    final response = await _fetchMylStarUseCase.call(const NoParams());

    return response.fold(
      (failure) => throw failure,
      (data) => data,
    );
  }

  Future<List<StarEntity>> _fetchHistoryTalents() async {
    // Mock implementation - replace with actual history API call
    // For now, return a subset of available talents
    return state.availableTalents.take(8).toList();
  }

  List<StarEntity> _updateFavoritesList() {
    return state.availableTalents
        .where((talent) => state.favoriteIds.contains(talent.id))
        .toList();
  }

  void _updateTalentsData(
    TalentCategory category,
    List<StarEntity> newTalents,
    bool refresh,
  ) {
    final talents = Map<TalentCategory, List<StarEntity>>.from(state.talents);
    final pages = Map<TalentCategory, int>.from(state.currentPages);
    final hasMore = Map<TalentCategory, bool>.from(state.hasMoreData);
    final loadingStates = Map<TalentCategory, bool>.from(state.loadingStates);

    if (refresh) {
      talents[category] = newTalents;
    } else {
      talents[category] = [...(talents[category] ?? []), ...newTalents];
    }

    // Update pagination
    if (newTalents.length < pageSize) {
      hasMore[category] = false;
    } else {
      pages[category] = (pages[category] ?? 1) + 1;
    }

    loadingStates[category] = false;

    emit(state.copyWith(
      talents: talents,
      currentPages: pages,
      hasMoreData: hasMore,
      loadingStates: loadingStates,
      status: StarStates.success,
    ));
  }

  void _resetPagination(TalentCategory category) {
    final pages = Map<TalentCategory, int>.from(state.currentPages);
    final hasMore = Map<TalentCategory, bool>.from(state.hasMoreData);

    pages[category] = 1;
    hasMore[category] = true;

    emit(state.copyWith(
      currentPages: pages,
      hasMoreData: hasMore,
    ));
  }

  // Profile search functionality
  void searchProfiles(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(
        searchProfileResults: [],
        isSearchingProfiles: false,
      ));
      return;
    }

    emit(state.copyWith(isSearchingProfiles: true));

    final response = await _searchProfilesUseCase(
      SearchProfileParams(
        query: query,
        page: 1,
        limit: 20,
      ),
    );

    response.fold(
      (failure) {
        _showErrorMessage(failure);
        emit(state.copyWith(
          isSearchingProfiles: false,
          status: StarStates.error,
          failure: failure,
        ));
      },
      (profiles) {
        emit(state.copyWith(
          searchProfileResults: profiles,
          isSearchingProfiles: false,
          status: StarStates.success,
        ));
      },
    );
  }

  void clearProfileSearch() {
    emit(state.copyWith(
      searchProfileResults: [],
      isSearchingProfiles: false,
    ));
  }

  void _handleError(TalentCategory category, dynamic error) {
    final loadingStates = Map<TalentCategory, bool>.from(state.loadingStates);
    loadingStates[category] = false;

    emit(state.copyWith(
      loadingStates: loadingStates,
      status: StarStates.error,
      failure: error is Failure ? error : null,
    ));

    _showErrorMessage(error);
  }

  // Favorites management
  void toggleFavorite(String talentId) {
    final favoriteIds = Set<String>.from(state.favoriteIds);

    if (favoriteIds.contains(talentId)) {
      favoriteIds.remove(talentId);
    } else {
      favoriteIds.add(talentId);
    }

    emit(state.copyWith(favoriteIds: favoriteIds));

    // Update favorites list
    loadTalents(TalentCategory.favorites, refresh: true);
  }

  bool isFavorite(String talentId) {
    return state.favoriteIds.contains(talentId);
  }

  // Search functionality
  void searchTalents(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(searchQuery: '', searchResults: []));
      return;
    }

    final searchResults = state.availableTalents.where((talent) {
      return talent.title.toLowerCase().contains(query.toLowerCase()) ||
          talent.user.firstName.toLowerCase().contains(query.toLowerCase()) ||
          talent.user.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      searchResults: searchResults,
    ));
  }

  // Delete talent with proper data cleanup
  Future<void> deleteMyTalent({required String id}) async {
    emit(state.copyWith(status: StarStates.loading));

    final response = await _deleteMyTalentUseCase(id);

    response.fold(
      (failure) {
        _showErrorMessage(failure);
        emit(state.copyWith(failure: failure, status: StarStates.error));
      },
      (data) {
        // Remove from all relevant lists
        final talents =
            Map<TalentCategory, List<StarEntity>>.from(state.talents);
        final favoriteIds = Set<String>.from(state.favoriteIds);

        for (final category in TalentCategory.values) {
          talents[category] =
              talents[category]?.where((talent) => talent.id != id).toList() ??
                  [];
        }

        favoriteIds.remove(id);

        emit(state.copyWith(
          talents: talents,
          favoriteIds: favoriteIds,
          status: StarStates.success,
        ));
      },
    );
  }

  // Rating management
  void updateRating(String id, int rating) {
    final talents = Map<TalentCategory, List<StarEntity>>.from(state.talents);

    for (final category in TalentCategory.values) {
      talents[category] = talents[category]?.map((talent) {
            if (talent.id == id) {
              return talent.copyWith(averageRating: rating);
            }
            return talent;
          }).toList() ??
          [];
    }

    emit(state.copyWith(talents: talents));
  }

  // Banner management
  Future<void> _fetchBanner() async {
    final response = await _bannerUseCase(const NoParams());

    response.fold(
      (failure) => _showErrorMessage(failure),
      (data) => emit(state.copyWith(banner: data)),
    );
  }

  void _showErrorMessage(dynamic error) {
    final currentContext =
        AppPages.router.configuration.navigatorKey.currentContext;
    if (currentContext != null) {
      showErrorMessage(
        currentContext,
        getFailureMessage(error, currentContext),
      );
    }
  }

  // Helper methods for backward compatibility
  List<StarEntity> get allTalents => state.availableTalents;
  List<StarEntity> get favoriteTalents => state.favoriteTalents;
  Set<String> get favoriteIds => state.favoriteIds;
}
