import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_ad_drawer_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../data/models/favouite_category_model/favouite_category_model.dart';
import '../entities/favourite_ad_entity.dart';
import '../entities/favourite_subcategory_entity.dart';

abstract class AccountRepo {
  Future<Either<Failure, List<FavouriteCategoryModel>>> getFavouriteCategories();

  Future<Either<Failure, List<FavouriteSubcategoryEntity>>> getFavouriteSubcategories();

  Future<Either<Failure, List<FavouriteAdEntity>>> getFavouriteAds();
  Future<Either<Failure, List<FavouriteAdDrawerEntity>>>
      getDrawerFavouriteAds();
  Future<Either<Failure, bool>> deleteFavouriteAds({required String id});
}
