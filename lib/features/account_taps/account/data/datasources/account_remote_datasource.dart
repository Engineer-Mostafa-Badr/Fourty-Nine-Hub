import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/account/data/models/favourite_ad_drawer_model.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_drawer_entity.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/data/models/main_category_model.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import '../models/favourite_ad_model.dart';

abstract class AccountRemoteDataSource {
  Future<Either<Failure, List<MainCategoryEntity>>>
  getFavouriteCategories();

  Future<Either<Failure, List<SubCategoryEntity>>>
  getFavouriteSubcategories();

  Future<Either<Failure, List<FavouriteAdEntity>>> getFavouriteAds();
  Future<Either<Failure, List<FavouriteAdDrawerEntity>>> getDrawerFavouriteAds();
  Future<Either<Failure, bool>> deleteFavouriteAds({required String id});
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ApiConsumer _apiConsumer;
  AccountRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<MainCategoryEntity>>>
  getFavouriteCategories() async {
    final response = await _apiConsumer.get(EndPoints.favouriteCategories);
    return response.fold(
            (failure) => Left(failure),
            (data) => Right((data['data']['favorites'] as List)
            .map((e) => MainCategoryModel.fromJson(e))
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
  Future<Either<Failure, List<SubCategoryEntity>>>
  getFavouriteSubcategories() async {
    final response = await _apiConsumer.get(EndPoints.favouriteSubCategories);
    return response.fold(
            (failure) => Left(failure),
            (data) => Right((data['data'] as List)
            .map((e) => SubCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<FavouriteAdDrawerEntity>>> getDrawerFavouriteAds() async {
    final response = await _apiConsumer.get(EndPoints.favouriteAds);
    return response.fold(
            (failure) => Left(failure),
            (data) => Right((data['data'] as List)
            .map((e) => FavouriteAdDrawerModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> deleteFavouriteAds({required String id}) async {
    final response = await _apiConsumer.delete(EndPoints.deleteFavouriteAds(id));
    return response.fold(
            (failure) => Left(failure),
            (data) => Right(data['status']));
  }
}