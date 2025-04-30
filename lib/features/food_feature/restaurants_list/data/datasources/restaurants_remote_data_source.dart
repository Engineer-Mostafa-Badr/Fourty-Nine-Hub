import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/create_restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/getsubcategory_restaurants_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';

import '../../../../../res/assets/jsons.dart';
import '../../domain/entities/food_ads_entity.dart';
import '../../domain/entities/log_count_entity.dart';
import '../../domain/entities/logs_entity.dart';
import '../../domain/entities/rate_response_entity.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/set_request_seen_entity.dart';
import '../../domain/entities/user_order_entity.dart';
import '../../domain/usecases/add_rate_restaurant_use_case.dart';
import '../../domain/usecases/get_user_order_use_case.dart';
import '../../domain/usecases/set_request_log_seen_use_case.dart';
import '../models/food_ads_model.dart';
import '../models/food_category_model.dart';
import '../models/log_count_model.dart';
import '../models/logs_model.dart';
import '../models/rate_response_model.dart';
import '../models/set_request_seen_model.dart';
import '../models/user_order_model.dart';

abstract class RestaurantsRemoteDataSource {
  Future<Either<Failure, bool>> createRestaurant(CreateRestaurantParams params);
  Future<Either<Failure, bool>> changeConnectivity(bool isActive);
  Future<Either<Failure, ExpiredRequestsResponse>> getExpiredOrders(
      PaginationParams params);
  Future<Either<Failure, List<FoodCategoryModel>>> getFoodCategories();
  Future<Either<Failure, List<FoodCategoryModel>>>
      getMealCategoriesWithCountRestaurants(
          {required PostCommentsParams params});
  Future<Either<Failure, List<GetAllRestaurantEntity>>> getAllRestaurantsWithMenu(
      {required PostCommentsParams params});
  Future<Either<Failure, List<GetAllRestaurantEntity>>> searchRestaurants(
      {required String city,
      required String subCategory,
      required String government,
      PostCommentsParams? params});
  Future<Either<Failure, List<GetAllRestaurantEntity>>> getNearByReasturants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, List<GetAllRestaurantEntity>>> getTrendingRestaurants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, int>> numOfRestaurants();
  Future<Either<Failure, bool>> toggleRestaurantFavourite(
      {required String params});
  Future<Either<Failure, List<GetAllRestaurantEntity>>> getSubCategoryRestaurants(
      {required GetSubCategoryRestaurants params});
  Future<Either<Failure, IsRestaurantModel>> isRestaurant();

  Future<Either<Failure, List<UserOrderEntity>>> getUserOrder({required GetUserOrderParams params});

  Future<Either<Failure, List<LogsRequestLogsEntity>>> getReqLogs(
      PaginationParams params);

  Future<Either<Failure, RateResponseEntity>> addRateRestaurant({required AddRateRestaurantParams params});
  Future<Either<Failure, RequestLogCountEntity>> getReqCount();

  Future<Either<Failure, SetRequestSeenEntity >> setLogSeen({required SetRequestLogSeenParams params});
  Future<Either<Failure, List<GetAllRestaurantEntity>>> getFoodAds(
      PaginationParams params);

}

class RestaurantsRemoteDataSourceImpl implements RestaurantsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  RestaurantsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<FoodCategoryModel>>> getFoodCategories() async {
    final response = await _apiConsumer.get(Jsons.foodCategoriesList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['categories'] as List)
            .map((e) => FoodCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<GetAllRestaurantEntity>>> getNearByReasturants(
      {required double lat, required double lng}) async {
    final response = await _apiConsumer.get(Jsons.restaurantsList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['restaurants'] as List)
            .map((e) => GetAllRestaurantModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<GetAllRestaurantEntity>>> getTrendingRestaurants(
      {required double lat, required double lng}) async {
    final response = await _apiConsumer.get(Jsons.restaurantsList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['restaurants'] as List)
            .map((e) => GetAllRestaurantModel .fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<GetAllRestaurantEntity>>> getSubCategoryRestaurants(
      {required GetSubCategoryRestaurants params}) async {
    final response =
        await _apiConsumer.get(EndPoints.subCategoryRestaurants(params));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['restaurant'] as List)
            .map((e) => GetAllRestaurantModel .fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, int>> numOfRestaurants() async {
    final response = await _apiConsumer.get(EndPoints.getNumOfResturants);
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['data'] as int));
  }

  @override
  Future<Either<Failure, IsRestaurantModel>> isRestaurant() async {
    final response = await _apiConsumer.get(EndPoints.isResturant);
    return response.fold((l) => Left(l),
        (data) => Right(IsRestaurantModel.fromMap(data['data'])));
  }

  @override
  Future<Either<Failure, List<FoodCategoryModel>>>
      getMealCategoriesWithCountRestaurants(
          {required PostCommentsParams params}) async {
    final response = await _apiConsumer
        .get(EndPoints.getMealsWithCountRestaurant(params: params));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['subCategories'] as List)
            .map((e) => FoodCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<GetAllRestaurantEntity>>> getAllRestaurantsWithMenu(
      {required PostCommentsParams params}) async {
    final response = await _apiConsumer.get(
      EndPoints.getAllRestaurantWithMenu(params: params),
    );
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(
        List.from(
          data["data"].map((e) => GetAllRestaurantModel .fromJson(e)).toList(),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, List<GetAllRestaurantEntity>>> searchRestaurants(
      {required String city,
      required String subCategory,
      required String government,
      PostCommentsParams? params}) async {
    final data = {
      "city": city,
      "subcategoryId": subCategory,
      "government": government
    };
    log("data: ${jsonEncode(data)}");
    final response = await _apiConsumer.get(
        EndPoints.searchRestaurants(params: params),
        data: data,
        queryParameters: {"subCategory": subCategory});
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(
        List.from(
          data["data"].map((e) => GetAllRestaurantModel.fromJson(e)).toList(),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> createRestaurant(
      CreateRestaurantParams params) async {
    List<Map<String, dynamic>> mneu = [];
    params.mneu?.forEach((element) {
      final toMap = {
        "foodName": element.foodName,
        "picture": element.photo,
        "price": element.price,
      };
      mneu.add(toMap);
    });
    Map<String, dynamic> data = {
      "name": params.name,
      "phone": params.number,
      "subcategoryId": params.subcategoryId,
      "restaurantMedia": params.restaurantMedia,
      "licenseMedia": params.licenseMedia,
      "government": params.government,
      "city": params.city,
      "menu": mneu,
    };

    final response =
        await _apiConsumer.post(EndPoints.createRestaurant, data: data);

    return response.fold(
      (Failure failure) {
        return Left(failure);
      },
      (data) {
        return Right(data['status']);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> changeConnectivity(bool isActive) async {
    final response = await _apiConsumer
        .patch(EndPoints.changeConnectivity, data: {'isActive': isActive});

    return response.fold(
      (Failure failure) {
        return Left(failure);
      },
      (data) {
        return Right(data['status']);
      },
    );
  }

  @override
  Future<Either<Failure, ExpiredRequestsResponse>> getExpiredOrders(
      PaginationParams params) async {
    final response =
        await _apiConsumer.get(EndPoints.foodExpiredOrders(params));
    return response.fold((failure) => Left(failure),
        (data) => Right(ExpiredRequestsResponse.fromJson(data)));
  }

  @override
  Future<Either<Failure, bool>> toggleRestaurantFavourite(
      {required String params}) async {
    final response =
        await _apiConsumer.post(EndPoints.toggleRestaurantFavourite(params));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<UserOrderEntity>>> getUserOrder({required GetUserOrderParams params}) async{
    final String url =
        "${EndPoints.userOrder}?page=${params.page}&limit=${params.limit}}";

    final response = await _apiConsumer.get(url);

    return response.fold(
          (failure) => Left(failure),
          (data) {
        final balanceData = (data['data'] as List)
            .map((e) => UserOrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(balanceData);
      },
    );
  }

  @override
  Future<Either<Failure, List<LogsRequestLogsEntity>>> getReqLogs(PaginationParams params) async{
    final response =
    await _apiConsumer.get(EndPoints.foodReqLogs(params));
    return response.fold(
          (failure) => Left(failure),
          (data) {
        final balanceData = (data['data'] as List)
            .map((e) => LogsRequestLogsModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(balanceData);
      },
    );
  }

  @override
  Future<Either<Failure, RateResponseEntity>> addRateRestaurant({required AddRateRestaurantParams params}) async{
    final url = "${EndPoints.addRateRestaurant}${params.restaurantId}";

    final response = await _apiConsumer.post(url,data: params.toJson());

    return response.fold(
          (l) => Left(l),
          (data) {
        final blockHealthModel = RateResponseModel.fromJson(data);
        return Right(blockHealthModel);
      },
    );
  }

  @override
  Future<Either<Failure, RequestLogCountEntity>> getReqCount() async{
    final url = "${EndPoints.getReqLogCount}";

    final response = await _apiConsumer.get(url,);

    return response.fold(
          (l) => Left(l),
          (data) {
        return Right(RequestLogCountModel.fromJson(data));
      },
    );
  }

  @override
  Future<Either<Failure, SetRequestSeenEntity>> setLogSeen({required SetRequestLogSeenParams params})async {
    final url = "${EndPoints.setRequestLogSeen}${params.requestId}";

    final response = await _apiConsumer.put(url);

    return response.fold(
          (l) => Left(l),
          (data) {
        return Right(SetRequestSeenModel.fromJson(data));
      },
    );
  }

  @override
  Future<Either<Failure, List<GetAllRestaurantEntity>>> getFoodAds(PaginationParams params)async {
    final response =
        await _apiConsumer.get(EndPoints.foodAds(params));
    return response.fold(
          (failure) => Left(failure),
          (data) {
        final balanceData = (data['data']['favoriteRestaurants'] as List)
            .map((e) => GetAllRestaurantModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(balanceData);
      },
    );
  }
}
