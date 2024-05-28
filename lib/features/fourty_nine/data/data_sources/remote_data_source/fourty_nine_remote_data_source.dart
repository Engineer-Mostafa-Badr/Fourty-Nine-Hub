import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/data/models/main_category_model.dart';
import 'package:fourtyninehub/features/fourty_nine/data/models/parent_main_category_model.dart';

abstract class FourtyNineRemoteDataSource {
  Future<Either<Failure, List<ParentMainCategoryModel>>>
      getParentMainCategories();

  Future<Either<Failure, List<MainCategoryModel>>> getMainCategories();
}

class FourtyNineRemoteDataSourceImpl implements FourtyNineRemoteDataSource {
  final ApiConsumer _apiConsumer;

  FourtyNineRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<ParentMainCategoryModel>>>
      getParentMainCategories() async {
    final result = await _apiConsumer.get(EndPoints.getParentMainCategories);
    return result.fold(
      (failure) => Left(failure),
      (response) => Right((response['data']['parentCategories'] as List)
          .map((e) => ParentMainCategoryModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<MainCategoryModel>>> getMainCategories() async {
    final result = await _apiConsumer.get(EndPoints.getMainCategories);
    return result.fold(
      (failure) => Left(failure),
      (response) => Right((response['data'] as List)
          .map((e) => MainCategoryModel.fromJson(e))
          .toList()),
    );
  }
}
