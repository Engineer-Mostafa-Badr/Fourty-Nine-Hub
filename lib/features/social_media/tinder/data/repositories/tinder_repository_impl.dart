

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/data_sources/tinder_data_source.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/last_seen_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_user_data_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/send_geft_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../models/tinder_person_model.dart';

class TinderRepositoryImpl extends TinderRepository {
  final TinderRemoteDataSource _storiesRemoteDataSource;

  TinderRepositoryImpl(this._storiesRemoteDataSource);

  @override
  Future<Either<Failure, GiftApi>> getGifts(PaginationParams params) {
  return _storiesRemoteDataSource.getGifts(params);
  }

  @override
  Future<Either<Failure, List<UserData>>> getUsers(GetUsersParams params) {
    return _storiesRemoteDataSource.getUsers(params);
  }

  @override
  Future<Either<Failure, ProfileUserModel>> getUserProfile(String params) {
    return _storiesRemoteDataSource.getUserProfile(params);
  }

  @override
  Future<Either<Failure, SubFavoritesResponse>> fetchFavourites() {
    return _storiesRemoteDataSource.fetchFavourites();
  }

  @override
  Future<Either<Failure, CategoryFavoritesResponse>> fetchFavouritesCategories() {
    return _storiesRemoteDataSource.fetchFavouritesCategories();
  }

  @override
  Future<Either<Failure, bool>> addFavouriteCategories(String id) {
    return _storiesRemoteDataSource.addFavouriteCategories(id);
  }

  @override
  Future<Either<Failure, LastSeenModel>> fetchLastSeen(String id) {
    return _storiesRemoteDataSource.fetchLastSeen(id);
  }

  @override
  Future<Either<Failure, dynamic>> sendGift(SendGiftParams params) {
    return _storiesRemoteDataSource.sendGift(params);
  }

  @override
  Future<Either<Failure, GiftApi>> fetchGifts() {
    return _storiesRemoteDataSource.fetchGifts();
  }

  @override
  Future<Either<Failure, NearByModel>> checkUserNearby(String id) {
    return _storiesRemoteDataSource.checkUserNearby(id);
  }

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> fetchSubCategoryData() {
    return _storiesRemoteDataSource.fetchSubCategoryData();
  }

  @override
  Future<Either<Failure, bool>> uploadPictures(List<String> params) {
    return _storiesRemoteDataSource.uploadPictures(params);
  }

// @override
// Future<Either<Failure, bool>> makeViews(String id) {
//   return _storiesRemoteDataSource.makeViews(id);
// }


}