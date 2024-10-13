import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_drawer_entity.dart';

import '../../../../../core/error/failure.dart';
import '../entities/favourite_ad_entity.dart';
import '../entities/favourite_category_entity.dart';
import '../entities/favourite_subcategory_entity.dart';

abstract class AccountRepo {
  Future<Either<Failure, List<FavouriteCategoryEntity>>>
      getFavouriteCategories();

  Future<Either<Failure, List<FavouriteSubcategoryEntity>>>
      getFavouriteSubcategories();

  Future<Either<Failure, List<FavouriteAdEntity>>> getFavouriteAds();
  Future<Either<Failure, List<FavouriteAdDrawerEntity>>> getDrawerFavouriteAds();
}
