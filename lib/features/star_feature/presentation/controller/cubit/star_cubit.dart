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

// class StarCubit extends Cubit<StarState> {
//   final FetchAllStarUseCase _allStarUseCase;
//   final FetchMylStarUseCase _fetchMylStarUseCase;
//   final FetchWinnerStarUseCase _fetchWinnerStarUseCase;
//   final UploadMyStarUseCase _uploadMyStarUseCase;
//   final DeleteMyStarUseCase _deleteMyTalentUseCase;
//   final FetchBannerUseCase _bannerUseCase;

//   StarCubit(
//       this._allStarUseCase,
//       this._fetchMylStarUseCase,
//       this._uploadMyStarUseCase,
//       this._deleteMyTalentUseCase,
//       this._fetchWinnerStarUseCase,
//       this._bannerUseCase)
//       : super(StarState());

//   List<StarEntity> star = [];
//   List<StarWinnerEntity> winner = [];

//   bool isLoadingMore = false;
//   bool hasMoreData = true;
//   int currentPage = 1;
//   int pageSize = 10;

//   void loadInitialData() async {
//     emit(state.copyWith(status: StarStates.loading));
//     star.clear();
//     currentPage = 1;
//     hasMoreData = true;
//     await getAllTalent(refresh: true);
//   }

//   List<StarEntity> allTalents = [];
//   bool loadAllTalents = false;

//   // Favorites functionality
//   final Set<String> _favoriteIds = {};
//   Set<String> get favoriteIds => _favoriteIds;

//   List<StarEntity> get favoriteTalents {
//     return allTalents
//         .where((talent) => _favoriteIds.contains(talent.id))
//         .toList();
//   }

//   void toggleFavorite(String talentId) {
//     if (_favoriteIds.contains(talentId)) {
//       _favoriteIds.remove(talentId);
//     } else {
//       _favoriteIds.add(talentId);
//     }
//     emit(state.copyWith(favoriteIds: _favoriteIds));
//   }

//   bool isFavorite(String talentId) {
//     return _favoriteIds.contains(talentId);
//   }

//   Future loadAllTalentsData() async {
//     loadAllTalents = true;
//     allTalents.clear();
//     allTalentsPage = 1;
//     hasMoreAllTalentsData = true;
//     emit(state.copyWith(status: StarStates.loading));
//     await Future.wait([getAllTalents(), fetchBanner()]);
//     loadAllTalents = false;
//     emit(state.copyWith(status: StarStates.success));
//   }

//   bool isLoadingAllTalentsMore = false;
//   bool hasMoreAllTalentsData = true;
//   int allTalentsPage = 1;

//   Future<void> getAllTalents() async {
//     if (!hasMoreAllTalentsData || isLoadingAllTalentsMore) return;
//     isLoadingAllTalentsMore = true;
//     emit(state.copyWith(status: StarStates.loading));
//     final response = await _allStarUseCase(
//       StarPaginationParams(page: allTalentsPage, limit: pageSize),
//     );
//     response.fold((l) {
//       var currentContext =
//           AppPages.router.configuration.navigatorKey.currentContext!;
//       showErrorMessage(currentContext, getFailureMessage(l, currentContext));
//       emit(state.copyWith(failure: l, status: StarStates.error));
//     }, (data) async {
//       allTalents.addAll(data);

//       if (data.length < pageSize) {
//         hasMoreAllTalentsData = false;
//       } else {
//         allTalentsPage++;
//       }
//       isLoadingAllTalentsMore = false;
//       emit(state.copyWith(status: StarStates.success));
//     });
//   }

//   List<StarEntity> myTalents = [];
//   bool loadMyTalents = false;

//   Future loadMyTalentsData() async {
//     loadMyTalents = true;
//     myTalents.clear();
//     myTalentsPage = 1;
//     hasMoreMyTalentsData = true;
//     emit(state.copyWith(status: StarStates.loading));
//     await getMyTalents();
//     loadMyTalents = false;
//     emit(state.copyWith(status: StarStates.success));
//   }

//   bool isLoadingMyTalentsMore = false;
//   bool hasMoreMyTalentsData = true;
//   int myTalentsPage = 1;

//   Future<void> getMyTalents() async {
//     if (!hasMoreMyTalentsData || isLoadingMyTalentsMore) return;
//     isLoadingMyTalentsMore = true;
//     emit(state.copyWith(status: StarStates.loading));
//     final response = await _fetchMylStarUseCase.call(const NoParams());

//     response.fold((l) {
//       var currentContext =
//           AppPages.router.configuration.navigatorKey.currentContext!;
//       showErrorMessage(currentContext, getFailureMessage(l, currentContext));
//       emit(state.copyWith(failure: l, status: StarStates.error));
//     }, (data) async {
//       myTalents.addAll(data);
//       if (data.length < pageSize) {
//         hasMoreMyTalentsData = false;
//       } else {
//         myTalentsPage++;
//       }
//       isLoadingMyTalentsMore = false;
//       emit(state.copyWith(status: StarStates.success));
//     });
//   }

//   void loadInitialDataWinner() async {
//     emit(state.copyWith(status: StarStates.loading));
//     winner.clear();
//     currentPage = 1;
//     hasMoreData = true;
//     await fetchWinnerStar();
//   }

//   Future<void> getAllTalent({bool refresh = false}) async {
//     if (refresh) {
//       star.clear();
//       currentPage = 1;
//       hasMoreData = true;
//       isLoadingMore = false;
//     }

//     if (!hasMoreData || isLoadingMore) return;

//     isLoadingMore = true;

//     final response = await _allStarUseCase(
//       StarPaginationParams(page: currentPage, limit: pageSize),
//     );

//     response.fold(
//       (failure) {
//         var currentContext =
//             AppPages.router.configuration.navigatorKey.currentContext!;
//         showErrorMessage(
//             currentContext, getFailureMessage(failure, currentContext));
//         emit(state.copyWith(failure: failure, status: StarStates.error));
//       },
//       (data) {
//         if (refresh) {
//           star = data;
//         } else {
//           star.addAll(data);
//         }

//         if (data.length < pageSize) {
//           hasMoreData = false;
//         } else {
//           currentPage++;
//         }

//         isLoadingMore = false;
//         emit(state.copyWith(star: star, status: StarStates.success));
//       },
//     );
//   }

//   Future<void> fetchWinnerStar() async {
//     if (!hasMoreData || isLoadingMore) return;

//     isLoadingMore = true;

//     final response = await _fetchWinnerStarUseCase(
//       StarPaginationParams(page: currentPage, limit: pageSize),
//     );

//     response.fold(
//       (failure) {
//         var currentContext =
//             AppPages.router.configuration.navigatorKey.currentContext!;
//         showErrorMessage(
//             currentContext, getFailureMessage(failure, currentContext));
//         emit(state.copyWith(failure: failure, status: StarStates.error));
//       },
//       (data) {
//         winner.addAll(data);

//         if (data.length < pageSize) {
//           hasMoreData = false;
//         } else {
//           currentPage++;
//         }

//         isLoadingMore = false;
//         emit(state.copyWith(winner: winner, status: StarStates.success));
//       },
//     );
//   }

//   Future<bool> uploadStar({
//     required StarParams params,
//   }) async {
//     emit(state.copyWith(status: StarStates.loading));

//     final response = await _uploadMyStarUseCase(params);

//     response.fold(
//       (failure) {
//         var currentContext =
//             AppPages.router.configuration.navigatorKey.currentContext!;
//         showErrorMessage(
//             currentContext, getFailureMessage(failure, currentContext));
//         emit(state.copyWith(failure: failure, status: StarStates.error));
//         return false;
//       },
//       (data) {
//         emit(state.copyWith(
//           status: StarStates.uploadSuccess,
//         ));
//         return true;
//       },
//     );
//     return false;
//   }

//   Future<void> fetchBanner() async {
//     emit(state.copyWith(status: StarStates.loading));

//     final response = await _bannerUseCase(const NoParams());

//     response.fold(
//       (failure) {
//         var currentContext =
//             AppPages.router.configuration.navigatorKey.currentContext!;
//         showErrorMessage(
//             currentContext, getFailureMessage(failure, currentContext));
//         emit(state.copyWith(failure: failure, status: StarStates.error));
//       },
//       (data) {
//         emit(state.copyWith(
//           banner: data,
//           status: StarStates.success,
//         ));
//       },
//     );
//   }

//   Future<void> deleteMyTalent({
//     required String id,
//   }) async {
//     emit(state.copyWith(status: StarStates.loading));

//     final response = await _deleteMyTalentUseCase(id);

//     response.fold(
//       (failure) {
//         var currentContext =
//             AppPages.router.configuration.navigatorKey.currentContext!;
//         showErrorMessage(
//             currentContext, getFailureMessage(failure, currentContext));
//         emit(state.copyWith(failure: failure, status: StarStates.error));
//       },
//       (data) {
//         // Remove from local lists
//         allTalents.removeWhere((talent) => talent.id == id);
//         myTalents.removeWhere((talent) => talent.id == id);
//         star.removeWhere((talent) => talent.id == id);
//         _favoriteIds.remove(id);

//         emit(state.copyWith(
//           status: StarStates.success,
//           favoriteIds: _favoriteIds,
//         ));
//       },
//     );
//   }

//   List<String>? selectedVideo;

//   uploadVideo({bool isGallery = true, required BuildContext context}) async {
//     final UploadFile upload = UploadFile();
//     await upload.uploadVideo(
//         isGallery: isGallery,
//         subCategoryId: '66a3583454e6e337915514db',
//         onUploaded: (UploadFileEntity data) {
//           selectedVideo?.add(data.mediaId);
//           final video = state.video ?? [];
//           video.add(data);
//           selectedVideo = video.map((e) => e.mediaId).toList();
//           emit(state.copyWith(video: video, status: StarStates.success));
//         },
//         context: context);
//   }

//   changeRating(String id, int rating) {
//     // Update in all relevant lists
//     allTalents = allTalents.map((element) {
//       if (element.id == id) {
//         return element.copyWith(averageRating: rating);
//       }
//       return element;
//     }).toList();

//     star = star.map((element) {
//       if (element.id == id) {
//         return element.copyWith(averageRating: rating);
//       }
//       return element;
//     }).toList();

//     myTalents = myTalents.map((element) {
//       if (element.id == id) {
//         return element.copyWith(averageRating: rating);
//       }
//       return element;
//     }).toList();

//     emit(state.copyWith());
//   }

//   void clearSelectedVideos() {
//     selectedVideo = [];
//     emit(state.copyWith(video: []));
//   }
// }

class StarCubit extends Cubit<StarState> {
  final FetchAllStarUseCase _allStarUseCase;
  final FetchMylStarUseCase _fetchMylStarUseCase;
  final FetchWinnerStarUseCase _fetchWinnerStarUseCase;
  final UploadMyStarUseCase _uploadMyStarUseCase;
  final DeleteMyStarUseCase _deleteMyTalentUseCase;
  final FetchBannerUseCase _bannerUseCase;

  static const int pageSize = 10;

  StarCubit(
    this._allStarUseCase,
    this._fetchMylStarUseCase,
    this._uploadMyStarUseCase,
    this._deleteMyTalentUseCase,
    this._fetchWinnerStarUseCase,
    this._bannerUseCase,
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
