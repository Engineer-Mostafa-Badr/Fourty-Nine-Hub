import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/chance_feature/data/model/chance_model.dart';
import 'package:fourtyninehub/features/chance_feature/data/model/chance_rate_model.dart';
import 'package:fourtyninehub/features/chance_feature/data/model/main_category_drop_model.dart';
import 'package:fourtyninehub/features/chance_feature/data/model/sub_category_drop_model.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/cahnce_rate_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/sub_category_drop_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_chance_rate_use_case.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_main_category.dart';
import 'package:fourtyninehub/features/chance_feature/domain/use_case/fetch_sub_category.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/shared_pref.dart';
import '../../domain/entity/chance_ad_entity.dart';
import '../../domain/entity/chance_ads_pagination_entity.dart';
import '../../domain/entity/chance_entity.dart';
import '../../domain/use_case/add_chance_data.dart';
import '../../domain/use_case/create_chance_ad_use_case.dart';
import '../../domain/use_case/get_all_chance_ads_use_case.dart';
import '../../domain/use_case/get_chance_ad_details_use_case.dart';
import '../../domain/use_case/join_chance_ad_use_case.dart';
import '../../domain/use_case/search_chance_ads_use_case.dart';
import '../../domain/use_case/toggle_chance_ad_favorite_use_case.dart';
import '../model/chance_ad_model.dart';
import '../model/chance_ads_pagination_model.dart';
import '../model/winner_statistics_model.dart';
import '../../domain/entity/winner_statistics_entity.dart';

abstract class ChanceRemoteDataSource {
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

class ChanceRemoteDataSourceImpl extends ChanceRemoteDataSource {
  final Dio _dio = Dio();
  final ApiConsumer _apiConsumer;

  ChanceRemoteDataSourceImpl(this._apiConsumer) {
    _initializeToken();
  }

  Future<void> _ensureTokenInitialized() async {
    token ??= await CacheManager.getAccessToken();
  }

  String? token;

  Future<void> _initializeToken() async {
    token = await CacheManager.getAccessToken();
  }

  @override
  Future<List<ChanceEntity>> fetchChance() async {
    try {
      await _ensureTokenInitialized();
      final response =
          await _dio.get('${EndPoints.developmentBaseUrl}${EndPoints.chance}',
              options: Options(headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              }));
      // Handle the response based on the API structure
      print('object');
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('response 1');
        print(response.data);
        final data = response.data as Map<String, dynamic>;
        final list = (data['data']['ads'] as List)
            .map((e) => ChanceModel.fromJson(e))
            .toList();

        return list; // Assuming the API returns JSON data
      } else {
        throw Exception(
            "Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Error occurred while fetching data: $error");
    }
  }

  @override
  Future<Either<Failure, bool>> addChance(AddChanceParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.addChance,
      data: params.toJson(),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, ChanceRateEntity>> fetchChanceRate(
      ChanceRateParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.rateChance(params.chanceRateParams),
    );
    return response.fold(
      (failure) {
        print('object');
        return Left(failure);
      },
      (response) {
        print("error at fetch rate data ${response.toString()}");
        return Right(ChanceRateModel.fromJson(response["data"]));
      },
    );
  }

  @override
  Future<Either<Failure, List<MainCategoryDropEntity>>> fetchMainCategory(
      MainCategoryChanceParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.mainCatChance(params),
      queryParameters: params.paginationParams.toJson(),
    );
    return response.fold(
      (failure) => Left(failure),
      (data) {
        final list = (data['data']['mainCategories'] as List)
            .map((e) => MainCategoryDropModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, List<SubCategoryDropEntity>>> fetchSubCategory(
      SubCategoryChanceParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.subCatChance,
      queryParameters: params.paginationParams.toJson(),
    );
    return response.fold(
      (failure) => Left(failure),
      (data) {
        final list = (data['data']['subcategories'] as List)
            .map((e) => SubCategoryDropModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, ChanceAdEntity>> createChanceAd(
      CreateChanceAdParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.createChanceAd,
      data: params.toModel().toJson(),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) {
        // API returns a String message instead of ChanceAdEntity object
        // So we return a dummy entity with basic info
        if (response['data'] is String) {
          return Right(ChanceAdModel(
            id: '',
            winnerId: null,
            images: [],
            description: params.description,
            title: params.title,
            price: params.price,
            isActive: true,
            isRejected: false,
            isBlocked: false,
            isBanned: false,
            subCategoryId: params.subCategoryId,
            mainCategoryId: params.mainCategoryId,
            userId: '',
            totalContributions: 0,
            contributors: 0,
            isComplete: false,
            cycleWinner: 0,
            adPercentage: 0,
            views: 0,
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
            contributorsCount: 0,
            isFavorite: false,
            userContribution: null,
          ));
        }
        return Right(ChanceAdModel.fromJson(response['data']));
      },
    );
  }

  @override
  Future<Either<Failure, bool>> joinChanceAd(JoinChanceAdParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.joinChanceAd,
      data: params.toModel().toJson(),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status'] ?? false),
    );
  }

  @override
  Future<Either<Failure, ChanceAdsPaginationEntity>> getAllChanceAds(
      GetAllChanceAdsParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getAllChanceAds(
        limit: params.paginationParams.limit,
        page: params.paginationParams.page,
      ),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(ChanceAdsPaginationModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, ChanceAdEntity>> getChanceAdDetails(
      GetChanceAdDetailsParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getChanceAdDetails(params.adId),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(ChanceAdModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, List<ChanceAdEntity>>> searchChanceAds(
      SearchChanceAdsParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.searchChanceAds(params.keyword),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data'] as List? ?? [])
            .map((e) => ChanceAdModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> toggleChanceAdFavorite(
      ToggleChanceAdFavoriteParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.toggleChanceAdFavorite(params.adId),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['data']['isFavorite'] ?? false),
    );
  }

  @override
  Future<Either<Failure, List<ChanceAdEntity>>> getFavoriteChanceAds() async {
    final response = await _apiConsumer.get(
      EndPoints.getFavoriteChanceAds,
    );
    return response.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data'] as List? ?? [])
            .where((e) => e['chanceAdId'] != null)
            .map((e) => ChanceAdModel.fromJson(e['chanceAdId']))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, List<ChanceAdEntity>>> getMyChanceAds() async {
    print('🔍 DEBUG: Calling getMyChanceAds API...');
    final response = await _apiConsumer.get(
      EndPoints.getMyChanceAds,
    );
    return response.fold(
      (failure) {
        print('❌ DEBUG: getMyChanceAds failed: ${failure.toString()}');
        return Left(failure);
      },
      (response) {
        print('✅ DEBUG: getMyChanceAds response: ${response.toString()}');
        final dataList = response['data'] as List? ?? [];
        print('📊 DEBUG: Found ${dataList.length} chance ads for user');
        final list = dataList.map((e) => ChanceAdModel.fromJson(e)).toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, List<ChanceAdEntity>>> getExpiredChanceAds() async {
    final response = await _apiConsumer.get(
      EndPoints.getExpiredChanceAds(),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data']['data'] as List? ?? [])
            .map((e) => ChanceAdModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, List<dynamic>>> getChanceAdWinners(String adId) async {
    final response = await _apiConsumer.get(
      EndPoints.getChanceAdContributors(adId),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data']['data'] as List? ?? [])
            .where((participant) => participant['isWinner'] == true)
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> incrementChanceAdView(String adId) async {
    final endpoint = EndPoints.incrementChanceAdView(adId);
    print('DATA SOURCE: Calling GET $endpoint (to increment views)');

    final response = await _apiConsumer.get(endpoint);

    return response.fold(
      (failure) {
        print('API ERROR incrementing view: ${failure.toString()}');
        return Left(failure);
      },
      (response) {
        print('API SUCCESS incrementing view: $response');
        return Right(response['status'] ?? true);
      },
    );
  }

  @override
  Future<Either<Failure, WinnerStatisticsEntity>> getWinnerStatistics() async {
    const endpoint = EndPoints.getWinnerStatistics;
    print('DATA SOURCE: Calling GET $endpoint');

    final response = await _apiConsumer.get(endpoint);

    return response.fold(
      (failure) {
        print('API ERROR getting winner statistics: ${failure.toString()}');
        return Left(failure);
      },
      (response) {
        print('API SUCCESS getting winner statistics: $response');
        final winnerStats = WinnerStatisticsModel.fromJson(response['data']);
        return Right(winnerStats);
      },
    );
  }
}
//   final response = await _dio.get(EndPoints.chance);
//
//   return response.fold(
//     (failure) {
//       print('object');
//       return Left(failure);
//     },
//     (response) {
//       print(response.toString());
//       final list = (response['data'] as List)
//           .map((e) => ChanceModel.fromJson(e))
//           .toList();
//       return Right(list);
//     },
//   );
// }
