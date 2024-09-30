import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/custom_page/data/model/navigate_bar_model.dart';
import 'package:fourtyninehub/features/custom_page/data/model/social_page_model.dart';
import 'package:fourtyninehub/features/custom_page/data/model/sub_tab_model.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entity/favourite_categ_entity.dart';
import '../../domain/entity/navigate_bar_entity.dart';
import '../../domain/entity/social_page_entity.dart';
import '../../domain/entity/sub_tab_entity.dart';
import '../../domain/use_case/update_favourite_cat_use_case.dart';
import '../../domain/use_case/update_navigate_bar_use_case.dart';
import '../../domain/use_case/update_social_page_use_case.dart';
import '../../domain/use_case/update_sub_tab_use_case.dart';
import '../model/favourite_cat_model.dart';

abstract class CustomPageRemoteDataSource {
  Future<Either<Failure, SocialPageEntity>> fetchSocialPage();
  Future<Either<Failure,bool>>updateSocialPage(SocialPageParams params);
  Future<Either<Failure,SubTabEntity>>fetchSubTab();
  Future<Either<Failure,bool>>updateSubTab(SubTabParams params);
  Future<Either<Failure,NavigateBarEntity>>fetchNavigateBar();
  Future<Either<Failure,bool>>updateNavigateBar(NavigateBarParams params);
  Future<Either<Failure,FavouriteCatEntity>>fetchFavouriteCat();
  Future<Either<Failure,bool>>updateFavouriteCat(FavouriteCatParams params);
}

class CustomPageRemoteDataSourceImpl extends CustomPageRemoteDataSource {
  final ApiConsumer _apiConsumer;

  CustomPageRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, SocialPageEntity>> fetchSocialPage() async {
    var response = await _apiConsumer.get(EndPoints.socialPage);

    return response.fold(
      (failure)=>Left(failure),
      (response)=>Right(SocialPageModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, bool>> updateSocialPage(SocialPageParams params)async {
    var response = await _apiConsumer.put(EndPoints.socialPage,
    data: params.toJson()
    );

    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, SubTabEntity>> fetchSubTab() async {
    var response = await _apiConsumer.get(EndPoints.subTab);

    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right(SubTabModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, bool>> updateSubTab(SubTabParams params) async {
    var response = await _apiConsumer.put(EndPoints.subTab,
        data: params.toJson()
    );

    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, NavigateBarEntity>> fetchNavigateBar() async {
    var response = await _apiConsumer.get(EndPoints.navigateBar);

    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right(NavigateBarModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, bool>> updateNavigateBar(NavigateBarParams params) async {
    var response = await _apiConsumer.put(EndPoints.navigateBar,
        data: params.toJson()
    );

    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, FavouriteCatEntity>> fetchFavouriteCat() async {
    var response = await _apiConsumer.get(EndPoints.favouriteCat);

    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right(FavouriteCatModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, bool>> updateFavouriteCat(FavouriteCatParams params) async {
    var response = await _apiConsumer.put(EndPoints.favouriteCat,
        data: params.toJson()
    );

    return response.fold(
          (failure)=>Left(failure),
          (response)=>Right(response['status']),
    );
  }
}
