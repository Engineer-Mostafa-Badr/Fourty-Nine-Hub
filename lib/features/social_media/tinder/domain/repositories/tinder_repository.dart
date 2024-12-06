
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/domain/last_seen_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/domain/user_data_tinder_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_user_data_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/send_geft_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/upload_tinder_picture_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../../../../core/error/failure.dart';

abstract class TinderRepository {
  Future<Either<Failure, GiftApi>> getGifts(PaginationParams params);
  Future<Either<Failure, List<UserDataTinderEntity>>> getUsers(GetUsersParams params);
  Future<Either<Failure, ProfileUserModel>> getUserProfile(String params);
  Future<Either<Failure, SubFavoritesResponse>> fetchFavourites();
  Future<Either<Failure, CategoryFavoritesResponse>> fetchFavouritesCategories();
  Future<Either<Failure, bool>> addFavouriteCategories(String id);
  Future<Either<Failure, bool>> uploadPictures(AddImagesParams params);
  Future<Either<Failure, bool>> deletePictures(String id);
  Future<Either<Failure, NearByModel>> checkUserNearby(String id);
  Future<Either<Failure, LastSeenEntity>> fetchLastSeen(String id);
  Future<Either<Failure, dynamic>> sendGift(SendGiftParams params);
  Future<Either<Failure, GiftApi>> fetchGifts();
  Future<Either<Failure, List<SubCategoryEntity>>> fetchSubCategoryData();
}
