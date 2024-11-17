import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/fourty_nine/data/models/main_category_model.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/search/data/model/ads_search_model.dart';
import 'package:fourtyninehub/features/search/data/model/reels_search_model.dart';
import 'package:fourtyninehub/features/search/data/model/trip_come_with_you_model.dart';
import 'package:fourtyninehub/features/search/data/model/user_search_model.dart';
import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/reels_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/trip_come_with_you_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/user_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/post_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';

import '../../../../core/error/failure.dart';

abstract class SearchRemoteDataSource {
  Future<Either<Failure, List<MainCategoryEntity>>> fetchSearch(SearchParams params);
  Future<Either<Failure,List<UserSearchEntity>>> fetchUserSearch(SearchParams params);
  Future<Either<Failure,List<AdsSearchEntity>>> fetchAdsSearch(SearchParams params);
  Future<Either<Failure,List<PostEntity>>> fetchPostsSearch(SearchParams params);
  Future<Either<Failure,List<TripComeWithYouEntity>>> fetchTripComeSearch(SearchParams params);
  Future<Either<Failure,List<ReelsSearchEntity>>> fetchReelSearch(SearchParams params);

}

class SearchRemoteDataSourceImpl extends SearchRemoteDataSource {
  final ApiConsumer _apiConsumer;

  SearchRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<MainCategoryEntity>>> fetchSearch(SearchParams params) async {
    final response = await _apiConsumer.get(
        EndPoints.search(params),
            data: params.toJson()
    );
    return response.fold(
      (failure)=>Left(failure),
      (response)=>Right((response['data'] as List)
          .map((e) => MainCategoryModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<UserSearchEntity>>> fetchUserSearch(SearchParams params) async {
    final response = await _apiConsumer.get(
        EndPoints.search(params),
        data: params.toJson()
    );
    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right((response['data'] as List)
          .map((e) => UserSearchModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<AdsSearchEntity>>> fetchAdsSearch(SearchParams params) async {
    final response = await _apiConsumer.get(
        EndPoints.search(params),
        data: params.toJson()
    );
    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right((response['data'] as List)
          .map((e) => AdsSearchModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<PostEntity>>> fetchPostsSearch(SearchParams params) async {
    final response = await _apiConsumer.get(
        EndPoints.search(params),
        data: params.toJson()
    );
    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right((response['data'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<TripComeWithYouEntity>>> fetchTripComeSearch(SearchParams params) async {
    final response = await _apiConsumer.get(
        EndPoints.search(params),
        data: params.toJson()
    );
    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right((response['data'] as List)
          .map((e) => TripComeWithYouModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<ReelsSearchEntity>>> fetchReelSearch(SearchParams params) async {
    final response = await _apiConsumer.get(
        EndPoints.search(params),
        data: params.toJson()
    );
    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right((response['data'] as List)
          .map((e) => ReelsSearchModel.fromJson(e))
          .toList()),
    );
}
}
