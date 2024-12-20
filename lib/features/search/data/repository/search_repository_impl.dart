import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/search/data/data_source/search_remote_data_source.dart';
import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/reels_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/trip_come_with_you_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/user_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../domain/repository/search_repository.dart';

class SearchRepositoryImpl extends SearchRepository {
  final SearchRemoteDataSource _searchRemoteDataSource;

  SearchRepositoryImpl(this._searchRemoteDataSource);
  @override
  Future<Either<Failure, List<MainCategoryEntity>>> fetchSearch(
      SearchParams params) {
    return _searchRemoteDataSource.fetchSearch(params);
  }

  @override
  Future<Either<Failure, List<UserSearchEntity>>> fetchUserSearch(
      SearchParams params) {
    return _searchRemoteDataSource.fetchUserSearch(params);
  }

  @override
  Future<Either<Failure, List<AdsSearchEntity>>> fetchAdsSearch(
      SearchParams params) {
    return _searchRemoteDataSource.fetchAdsSearch(params);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> fetchPostsSearch(
      SearchParams params) {
    return _searchRemoteDataSource.fetchPostsSearch(params);
  }

  @override
  Future<Either<Failure, List<TripComeWithYouEntity>>> fetchTripComeSearch(
      SearchParams params) {
    return _searchRemoteDataSource.fetchTripComeSearch(params);
  }

  @override
  Future<Either<Failure, List<ReelsSearchEntity>>> fetchReelSearch(
      SearchParams params) {
    return _searchRemoteDataSource.fetchReelSearch(params);
  }

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> fetchSearchSubCategory(
      SearchParams params) {
    return _searchRemoteDataSource.fetchSearchSubCategory(params);
  }
}
