import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/domain/tinder_like_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/add_like_tinder_use_case.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/error/failure.dart';
import '../data_sources/tinder_data_source.dart';
import '../models/get_fav_category_model.dart';
import '../models/get_fav_sub_category_model.dart';
import '../models/gift_model.dart';
import '../models/near_by_model.dart';
import '../models/profile_user_model.dart';
import '../../domain/domain/last_seen_entity.dart';
import '../../domain/domain/user_data_tinder_entity.dart';
import '../../domain/repositories/tinder_repository.dart';
import '../../domain/use_case/get_user_data_use_case.dart';
import '../../domain/use_case/send_geft_use_case.dart';
import '../../domain/use_case/upload_tinder_picture_use_case.dart';
import '../../../../subcategories/domain/entities/sub_category_entity.dart';

class TinderRepositoryImpl extends TinderRepository {
  final TinderRemoteDataSource _storiesRemoteDataSource;

  TinderRepositoryImpl(this._storiesRemoteDataSource);

  @override
  Future<Either<Failure, GiftApi>> getGifts(PaginationParams params) {
    return _storiesRemoteDataSource.getGifts(params);
  }

  @override
  Future<Either<Failure, List<UserDataTinderEntity>>> getUsers(
      GetUsersParams params) {
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
  Future<Either<Failure, CategoryFavoritesResponse>>
      fetchFavouritesCategories() {
    return _storiesRemoteDataSource.fetchFavouritesCategories();
  }

  @override
  Future<Either<Failure, bool>> addFavouriteCategories(String id) {
    return _storiesRemoteDataSource.addFavouriteCategories(id);
  }

  @override
  Future<Either<Failure, LastSeenEntity>> fetchLastSeen(String id) {
    return _storiesRemoteDataSource.fetchLastSeen(id);
  }

  @override
  Future<Either<Failure, SendGiftResponse>> sendGift(SendGiftParams params) {
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
  Future<Either<Failure, bool>> uploadPictures(AddImagesParams params) {
    return _storiesRemoteDataSource.uploadPictures(params);
  }

  @override
  Future<Either<Failure, bool>> deletePictures(String id) {
    return _storiesRemoteDataSource.deletePictures(id);
  }

  // @override
  // Future<Either<Failure, TinderLikeEntity>> addTinderLike({required AddLikeParams params}) {
  //   return _storiesRemoteDataSource.addTinderLike(params: params);
  // }
  //
  // @override
  // Future<Either<Failure, TinderLikeEntity>> addTinderDisLike({required AddLikeParams params}) {
  //   return _storiesRemoteDataSource.addTinderDisLike(params: params);
  // }
  //
  // @override
  // Future<Either<Failure, TinderLikeEntity>> addTinderLove({required AddLikeParams params}) {
  //   return _storiesRemoteDataSource.addTinderLove(params: params);
  // }

// @override
// Future<Either<Failure, bool>> makeViews(String id) {
//   return _storiesRemoteDataSource.makeViews(id);
// }
}
