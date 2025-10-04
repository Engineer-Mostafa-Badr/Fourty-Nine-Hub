import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/sub_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_rate_use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_main_category.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_sub_category.dart';

import '../entity/chance_ad_entity.dart';
import '../entity/chance_ads_pagination_entity.dart';
import '../use_case/add_chance_data.dart';
import '../use_case/create_chance_ad_use_case.dart';
import '../use_case/get_all_chance_ads_use_case.dart';
import '../use_case/get_chance_ad_details_use_case.dart';
import '../use_case/join_chance_ad_use_case.dart';
import '../use_case/search_chance_ads_use_case.dart';
import '../use_case/toggle_chance_ad_favorite_use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/cahnce_rate_entity.dart';
import '../entity/winner_statistics_entity.dart';

abstract class ChanceRepository {
  Future<List<ChanceEntity>> fetchChance();
  Future<Either<Failure, bool>> addChance(AddChanceParams params);
  Future<Either<Failure, ChanceRateEntity>> fetchChanceRate(
      ChanceRateParams params);
  Future<Either<Failure, List<MainCategoryDropEntity>>> fetchMainCategory(
      MainCategoryChanceParams params);
  Future<Either<Failure, List<SubCategoryDropEntity>>> fetchSubCategory(
      SubCategoryChanceParams params);

  // New Chance Ads Methods
  Future<Either<Failure, ChanceAdEntity>> createChanceAd(
      CreateChanceAdParams params);
  Future<Either<Failure, bool>> joinChanceAd(JoinChanceAdParams params);
  Future<Either<Failure, ChanceAdsPaginationEntity>> getAllChanceAds(
      GetAllChanceAdsParams params);
  Future<Either<Failure, ChanceAdEntity>> getChanceAdDetails(
      GetChanceAdDetailsParams params);
  Future<Either<Failure, List<ChanceAdEntity>>> searchChanceAds(
      SearchChanceAdsParams params);
  Future<Either<Failure, bool>> toggleChanceAdFavorite(
      ToggleChanceAdFavoriteParams params);
  Future<Either<Failure, List<ChanceAdEntity>>> getFavoriteChanceAds();
  Future<Either<Failure, List<ChanceAdEntity>>> getMyChanceAds();
  Future<Either<Failure, List<ChanceAdEntity>>> getExpiredChanceAds();
  Future<Either<Failure, List<dynamic>>> getChanceAdWinners(String adId);
  Future<Either<Failure, bool>> incrementChanceAdView(String adId);
  Future<Either<Failure, WinnerStatisticsEntity>> getWinnerStatistics();
}
