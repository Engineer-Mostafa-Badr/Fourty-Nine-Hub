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

import '../../../../common/models/public/pagination_params.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/const.dart';
import '../../../../core/utils/shared_pref.dart';
import '../../domain/entity/chance_entity.dart';
import '../../domain/use_case/add_chance_data.dart';

abstract class ChanceRemoteDataSource {
  Future<List<ChanceEntity>> fetchChance();

  Future<Either<Failure, bool>> addChance(AddChanceParams params);

  Future<Either<Failure, ChanceRateEntity>> fetchChanceRate(
      ChanceRateParams params);

  Future<Either<Failure, List<MainCategoryDropEntity>>> fetchMainCategory(
      MainCategoryChanceParams params);
  Future<Either<Failure, List<SubCategoryDropEntity>>> fetchSubCategory(
      SubCategoryChanceParams params);

}

class ChanceRemoteDataSourceImpl extends ChanceRemoteDataSource {
  final Dio _dio = Dio();
  final ApiConsumer _apiConsumer;

  ChanceRemoteDataSourceImpl(this._apiConsumer) {
    _initializeToken();
  }

  Future<void> _ensureTokenInitialized() async {
    token ??= await TokenManager.getAccessToken();
  }

  String? token;

  Future<void> _initializeToken() async {
    token = await TokenManager.getAccessToken();
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
      EndPoints.mainCatChance,
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
      EndPoints.mainCatChance,
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
