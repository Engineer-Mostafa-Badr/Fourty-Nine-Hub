import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/reels_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/trip_come_with_you_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/user_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<MainCategoryEntity>>> fetchSearch(
      SearchParams params);
  Future<Either<Failure, List<SubCategoryEntity>>> fetchSearchSubCategory(
      SearchParams params);
  Future<Either<Failure, List<UserSearchEntity>>> fetchUserSearch(
      SearchParams params);
  Future<Either<Failure, List<AdsSearchEntity>>> fetchAdsSearch(
      SearchParams params);
  Future<Either<Failure, List<PostEntity>>> fetchPostsSearch(
      SearchParams params);
  Future<Either<Failure, List<TripComeWithYouEntity>>> fetchTripComeSearch(
      SearchParams params);
  Future<Either<Failure, List<ReelsSearchEntity>>> fetchReelSearch(
      SearchParams params);
}
