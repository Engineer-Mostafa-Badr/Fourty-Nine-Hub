import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/cahnce_rate_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_category_drop_entity.dart';

import '../../../../../../core/error/failure.dart';
import '../../../domain/entity/chance_ad_entity.dart';
import '../../../domain/entity/chance_ads_pagination_entity.dart';
import '../../../domain/entity/winner_statistics_entity.dart';

enum ChanceStates { loading, initial, error, success, createSuccess, joinSuccess }

class ChanceState extends Equatable {
  final ChanceStates status;
  final Failure? failure;
  final List<ChanceEntity>? chance;
  final ChanceRateEntity? rate;
  final List<MainCategoryDropEntity>? mainCategory;
  final List<ChanceAdEntity>? chanceAds;
  final ChanceAdsPaginationEntity? chanceAdsPagination;
  final ChanceAdEntity? chanceAdDetails;
  final List<ChanceAdEntity>? favoriteChanceAds;
  final List<ChanceAdEntity>? myChanceAds;
  final List<ChanceAdEntity>? expiredChanceAds;
  final List<ChanceAdEntity>? searchResults;
  final List<String> uploadedImageIds;
  final WinnerStatisticsEntity? winnerStatistics;

  const ChanceState({
    this.status = ChanceStates.loading,
    this.failure,
    this.chance,
    this.rate,
    this.mainCategory,
    this.chanceAds,
    this.chanceAdsPagination,
    this.chanceAdDetails,
    this.favoriteChanceAds,
    this.myChanceAds,
    this.expiredChanceAds,
    this.searchResults,
    this.uploadedImageIds = const [],
    this.winnerStatistics,
  });

  ChanceState copyWith({
    ChanceStates? status,
    Failure? failure,
    List<ChanceEntity>? chance,
    ChanceRateEntity? rate,
    List<MainCategoryDropEntity>? mainCategory,
    List<ChanceAdEntity>? chanceAds,
    ChanceAdsPaginationEntity? chanceAdsPagination,
    ChanceAdEntity? chanceAdDetails,
    List<ChanceAdEntity>? favoriteChanceAds,
    List<ChanceAdEntity>? myChanceAds,
    List<ChanceAdEntity>? expiredChanceAds,
    List<ChanceAdEntity>? searchResults,
    List<String>? uploadedImageIds,
    WinnerStatisticsEntity? winnerStatistics,
  }) {
    return ChanceState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      chance: chance ?? this.chance,
      rate: rate ?? this.rate,
      mainCategory: mainCategory ?? this.mainCategory,
      chanceAds: chanceAds ?? this.chanceAds,
      chanceAdsPagination: chanceAdsPagination ?? this.chanceAdsPagination,
      chanceAdDetails: chanceAdDetails ?? this.chanceAdDetails,
      favoriteChanceAds: favoriteChanceAds ?? this.favoriteChanceAds,
      myChanceAds: myChanceAds ?? this.myChanceAds,
      expiredChanceAds: expiredChanceAds ?? this.expiredChanceAds,
      searchResults: searchResults ?? this.searchResults,
      uploadedImageIds: uploadedImageIds ?? this.uploadedImageIds,
      winnerStatistics: winnerStatistics ?? this.winnerStatistics,
    );
  }

  @override
  List<Object?> get props => [
    status, failure, chance, rate, mainCategory, chanceAds,
    chanceAdsPagination, chanceAdDetails, favoriteChanceAds,
    myChanceAds, expiredChanceAds, searchResults, uploadedImageIds,
    winnerStatistics
  ];
}

extension ChanceStateX on ChanceState {
  bool get isInitial => status == ChanceStates.initial;

  bool get isLoading => status == ChanceStates.loading;

  bool get isSuccess => status == ChanceStates.success;

  bool get isFailure => status == ChanceStates.error;
}
