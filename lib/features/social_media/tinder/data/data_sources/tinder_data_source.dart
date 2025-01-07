import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/last_seen_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/user_data_tinder_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/domain/last_seen_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/domain/user_data_tinder_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_user_data_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/send_geft_use_case.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../domain/use_case/upload_tinder_picture_use_case.dart';

abstract class TinderRemoteDataSource {
  Future<Either<Failure, GiftApi>> getGifts(PaginationParams params);

  Future<Either<Failure, List<UserDataTinderEntity>>> getUsers(
      GetUsersParams params);

  Future<Either<Failure, ProfileUserModel>> getUserProfile(String params);

  Future<Either<Failure, SubFavoritesResponse>> fetchFavourites();

  Future<Either<Failure, CategoryFavoritesResponse>>
      fetchFavouritesCategories();

  Future<Either<Failure, bool>> addFavouriteCategories(String id);

  Future<Either<Failure, LastSeenEntity>> fetchLastSeen(String id);

  Future<Either<Failure, SendGiftResponse>> sendGift(SendGiftParams params);

  Future<Either<Failure, GiftApi>> fetchGifts();

  Future<Either<Failure, NearByModel>> checkUserNearby(String id);

  Future<Either<Failure, List<SubCategoryEntity>>> fetchSubCategoryData();

  Future<Either<Failure, bool>> uploadPictures(AddImagesParams params);
  Future<Either<Failure, bool>> deletePictures(String id);
}

class TinderRemoteDataSourceImpl implements TinderRemoteDataSource {
  final ApiConsumer _apiConsumer;

  TinderRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, GiftApi>> getGifts(PaginationParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getGifts(params),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        GiftApi.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, List<UserDataTinderEntity>>> getUsers(
      GetUsersParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getUsers,
      queryParameters: params.toJson(),
    );
    return response.fold((failure) {
      //  print('object :$failure');
      return Left(failure);
    }, (response) {
      // print(')))))))))))))))))))))))))))))))))))))))))))))');
      return Right((response['data'] as List)
          .map((e) => UserDataTinderModel.fromJson(e))
          .toList());
    });
  }

  @override
  Future<Either<Failure, ProfileUserModel>> getUserProfile(
      String params) async {
    final response = await _apiConsumer.get(
      EndPoints.getTinderUserProfile(params),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        ProfileUserModel.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, SubFavoritesResponse>> fetchFavourites() async {
    final response = await _apiConsumer.get(
      EndPoints.fetchFavourites,
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        SubFavoritesResponse.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, CategoryFavoritesResponse>>
      fetchFavouritesCategories() async {
    final response = await _apiConsumer.get(
      EndPoints.fetchFavouritesCategory,
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        CategoryFavoritesResponse.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> addFavouriteCategories(String id) async {
    final response = await _apiConsumer.get(
      EndPoints.addFavouriteCategories(id),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, LastSeenEntity>> fetchLastSeen(String id) async {
    final response = await _apiConsumer.get(
      EndPoints.fetchLastSeen(id),
    );
    return response.fold(
      (failure) {
        return Left(failure);
      },
      (response) => Right(LastSeenModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, SendGiftResponse>> sendGift(SendGiftParams params) async {
    final response =
        await _apiConsumer.post(EndPoints.sendGift, data: params.toJson());
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, GiftApi>> fetchGifts() async {
    final response = await _apiConsumer.get(
      EndPoints.fetchGifts,
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(GiftApi.fromJson(response)),
    );
  }

  @override
  Future<Either<Failure, NearByModel>> checkUserNearby(String id) {
    // TODO: implement checkUserNearby
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SubCategoryEntity>>>
      fetchSubCategoryData() async {
    final response = await _apiConsumer.get(
      EndPoints.fetchSubCategoryData,
    );
    return response.fold(
        (failure) => Left(failure),
        (response) => Right((response['data'] as List)
            .map((e) => SubCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> uploadPictures(AddImagesParams params) async {
    final response = await _apiConsumer.post(EndPoints.tinderUploadPicture,
        data: params.toJson());
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, bool>> deletePictures(String id) async {
    final response = await _apiConsumer.delete(
      EndPoints.tinderDeletePicture(id),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

//
// @override
// Future<Either<Failure, bool>> makeViews(String id) async {

// }
}
