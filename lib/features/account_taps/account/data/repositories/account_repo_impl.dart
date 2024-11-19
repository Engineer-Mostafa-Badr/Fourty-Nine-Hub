import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_drawer_entity.dart';

import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_entity.dart';

import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../domain/repositories/account_repo.dart';
import '../datasources/account_remote_datasource.dart';

class AccountRepoImpl implements AccountRepo {
  final AccountRemoteDataSource _remoteDataSource;
  AccountRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<FavouriteAdEntity>>> getFavouriteAds() {
    return _remoteDataSource.getFavouriteAds();
  }

  @override
  Future<Either<Failure, List<MainCategoryEntity>>>
      getFavouriteCategories() {
    return _remoteDataSource.getFavouriteCategories();
  }

  @override
  Future<Either<Failure, List<SubCategoryEntity>>>
      getFavouriteSubcategories() {
    return _remoteDataSource.getFavouriteSubcategories();
  }

  @override
  Future<Either<Failure, List<FavouriteAdDrawerEntity>>>
      getDrawerFavouriteAds() {
    return _remoteDataSource.getDrawerFavouriteAds();
  }

  @override
  Future<Either<Failure, bool>> deleteFavouriteAds({required String id}) {
    return _remoteDataSource.deleteFavouriteAds(id: id);
  }
}
