import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/data/data_source/chance_remote_data_source.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/cahnce_rate_entity.dart';

import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/sub_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/add_chance_data.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_rate_use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_main_category.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_sub_category.dart';

import '../../domain/entity/chance_ad_entity.dart';
import '../../domain/entity/chance_ads_pagination_entity.dart';
import '../../domain/repository/chance_repository.dart';
import '../../domain/use_case/create_chance_ad_use_case.dart';
import '../../domain/use_case/get_all_chance_ads_use_case.dart';
import '../../domain/use_case/get_chance_ad_details_use_case.dart';
import '../../domain/use_case/join_chance_ad_use_case.dart';
import '../../domain/use_case/search_chance_ads_use_case.dart';
import '../../domain/use_case/toggle_chance_ad_favorite_use_case.dart';

class ChanceRepositoryImpl extends ChanceRepository {
  final ChanceRemoteDataSource _chanceRemoteDataSource;

  ChanceRepositoryImpl(this._chanceRemoteDataSource);

  @override
  Future<List<ChanceEntity>> fetchChance() {
    return _chanceRemoteDataSource.fetchChance();
  }

  @override
  Future<Either<Failure, bool>> addChance(AddChanceParams params) {
    return _chanceRemoteDataSource.addChance(params);
  }

  @override
  Future<Either<Failure, ChanceRateEntity>> fetchChanceRate(
      ChanceRateParams params) {
    return _chanceRemoteDataSource.fetchChanceRate(params);
  }

  @override
  Future<Either<Failure, List<MainCategoryDropEntity>>> fetchMainCategory(
      MainCategoryChanceParams params) {
    return _chanceRemoteDataSource.fetchMainCategory(params);
  }

  @override
  Future<Either<Failure, List<SubCategoryDropEntity>>> fetchSubCategory(
      SubCategoryChanceParams params) {
    return _chanceRemoteDataSource.fetchSubCategory(params);
  }

  @override
  Future<Either<Failure, ChanceAdEntity>> createChanceAd(CreateChanceAdParams params) {
    return _chanceRemoteDataSource.createChanceAd(params);
  }

  @override
  Future<Either<Failure, bool>> joinChanceAd(JoinChanceAdParams params) {
    return _chanceRemoteDataSource.joinChanceAd(params);
  }

  @override
  Future<Either<Failure, ChanceAdsPaginationEntity>> getAllChanceAds(GetAllChanceAdsParams params) {
    return _chanceRemoteDataSource.getAllChanceAds(params);
  }

  @override
  Future<Either<Failure, ChanceAdEntity>> getChanceAdDetails(GetChanceAdDetailsParams params) {
    return _chanceRemoteDataSource.getChanceAdDetails(params);
  }

  @override
  Future<Either<Failure, List<ChanceAdEntity>>> searchChanceAds(SearchChanceAdsParams params) {
    return _chanceRemoteDataSource.searchChanceAds(params);
  }

  @override
  Future<Either<Failure, bool>> toggleChanceAdFavorite(ToggleChanceAdFavoriteParams params) {
    return _chanceRemoteDataSource.toggleChanceAdFavorite(params);
  }

  @override
  Future<Either<Failure, List<ChanceAdEntity>>> getFavoriteChanceAds() {
    return _chanceRemoteDataSource.getFavoriteChanceAds();
  }

  @override
  Future<Either<Failure, List<ChanceAdEntity>>> getMyChanceAds() {
    return _chanceRemoteDataSource.getMyChanceAds();
  }

  @override
  Future<Either<Failure, List<ChanceAdEntity>>> getExpiredChanceAds() {
    return _chanceRemoteDataSource.getExpiredChanceAds();
  }

  @override
  Future<Either<Failure, List<dynamic>>> getChanceAdWinners(String adId) {
    return _chanceRemoteDataSource.getChanceAdWinners(adId);
  }

  @override
  Future<Either<Failure, bool>> incrementChanceAdView(String adId) {
    return _chanceRemoteDataSource.incrementChanceAdView(adId);
  }
}
