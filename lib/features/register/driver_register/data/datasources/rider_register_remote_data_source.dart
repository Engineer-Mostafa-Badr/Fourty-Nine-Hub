import 'package:dartz/dartz.dart';

import '../../../../../core/api/api_consumer.dart';
import '../../../../../core/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../../../../ride/RideRequest/data/models/car_type_model.dart';
import '../../../../subcategories/data/models/sub_category_model.dart';
import '../models/rider_info_model.dart';

abstract class RiderRegisterRemoteDataSource {
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories({
    required String mainCategory,
  });
  Future<Either<Failure, List<CarTypeModel>>> getCarTypes({
    required String subCategory,
  });

  Future<Either<Failure, bool>> postRiderInfo({required RiderInfoModel data});
}

class RiderRegisterRemoteDataSourceImpl
    implements RiderRegisterRemoteDataSource {
  final ApiConsumer _apiConsumer;

  const RiderRegisterRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<CarTypeModel>>> getCarTypes({
    required String subCategory,
    int page = 1,
    int limit = 1,
  }) async {
    final response = await _apiConsumer.get(EndPoints.carTypes,
        queryParameters: {
          "subCategoryId": subCategory,
          "page": page,
          "limit": limit
        });
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['cars'] as List)
            .map((e) => CarTypeModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories(
      {required String mainCategory}) async {
    final response = await _apiConsumer.get(
        EndPoints.subCategories(mainCategoryId: mainCategory),
        queryParameters: {
          'page': 2,
        });
    return response.fold(
        (failure) => Left(failure),
        (response) => Right((response['data']['subcategories'] as List)
            .map((e) => SubCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> postRiderInfo(
      {required RiderInfoModel data}) async {
    final response = await _apiConsumer.post(EndPoints.riderInfoRegister);
    return response.fold((failure) => Left(failure),
        (response) => Right(response['success'] as bool));
  }
}
