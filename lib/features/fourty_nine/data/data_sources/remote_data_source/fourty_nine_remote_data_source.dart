import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/data/models/main_category_model.dart';
import 'package:fourtyninehub/features/fourty_nine/data/models/parent_main_category_model.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/parent_main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/slider_item_entity.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../res/assets/jsons.dart';
import '../../models/slider_item_model.dart';

abstract class FourtyNineRemoteDataSource {
  Future<Either<Failure, List<ParentMainCategoryEntity>>>
      getParentMainCategories();

  Future<Either<Failure, List<MainCategoryModel>>> getMainCategories(
      {required PaginationParams params});
  Future<Either<Failure, List<SliderItemEntity>>> getSliderItems();
}

class FourtyNineRemoteDataSourceImpl implements FourtyNineRemoteDataSource {
  final JsonParser _jsonParser;
  final ApiConsumer _apiConsumer;

  FourtyNineRemoteDataSourceImpl(this._apiConsumer, this._jsonParser);

  @override
  Future<Either<Failure, List<ParentMainCategoryEntity>>>
      getParentMainCategories() async {
    final response = await _apiConsumer.get(EndPoints.getParentMainCategories);
    return response.fold(
        (failure) => Left(failure),
        (response) => Right((response['data']['categories'] as List)
            .map((e) => ParentMainCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<MainCategoryModel>>> getMainCategories(
      {required PaginationParams params}) async {
    final result = await _apiConsumer.get(EndPoints.getMainCategories,
        queryParameters: params.toJson());
    return result.fold(
      (failure) => Left(failure),
      (response) => Right((response['data']['categories'] as List)
          .map((e) => MainCategoryModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<SliderItemEntity>>> getSliderItems() async {
    final result = await _jsonParser.get(Jsons.sliderItems);
    return result.fold(
      (failure) => Left(failure),
      (response) => Right((response['data']['items'] as List)
          .map((e) => SliderItemModel.fromJson(e))
          .toList()),
    );
  }
}
