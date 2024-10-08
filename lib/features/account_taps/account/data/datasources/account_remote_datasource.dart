import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_entity.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_subcategory_entity.dart';
import '../../domain/entities/favourite_category_entity.dart';
import '../models/favourite_ad_model.dart';
import '../models/favourite_category_model.dart';
import '../models/favourite_subcategory_model.dart';

abstract class AccountRemoteDataSource {
  Future<Either<Failure, List<FavouriteCategoryEntity>>>
      getFavouriteCategories();

  Future<Either<Failure, List<FavouriteSubcategoryEntity>>>
      getFavouriteSubcategories();

  Future<Either<Failure, List<FavouriteAdEntity>>> getFavouriteAds();
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ApiConsumer _apiConsumer;
  AccountRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<FavouriteCategoryEntity>>>
      getFavouriteCategories() async {
    final response = await _apiConsumer.get(EndPoints.favouriteCategories);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['favorites'] as List)
            .map((e) => FavouriteCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<FavouriteAdEntity>>> getFavouriteAds() async {
    final response = await _apiConsumer.get(EndPoints.favouriteAds);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => FavouriteAdModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<FavouriteSubcategoryEntity>>>
      getFavouriteSubcategories() async {
    final response = await _apiConsumer.get(EndPoints.favouriteSubCategories);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => FavouriteSubcategoryModel.fromJson(e))
            .toList()));
  }
}
