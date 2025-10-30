import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/shared/data/models/city_model.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import 'package:fourtyninehub/features/health_feature/shared/data/models/governorate_model.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/governorate_entity.dart';

abstract class SharedAddressRemoteDataSource {
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();

  Future<Either<Failure, List<CityEntity>>> getCities(String governorateId);
}

class SharedAddressRemoteDataSourceImpl
    implements SharedAddressRemoteDataSource {
  final ApiConsumer _apiConsumer;

  SharedAddressRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<CityEntity>>> getCities(
      String governorateId) async {
    final response = await _apiConsumer.get(
        '${EndPoints.getCities(governorateId: governorateId)}?page=1&limit=10');
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(((data['data']?['cities'] ?? data['data']) as List)
          .map((e) => CityModel.fromJson(e))
          .cast<CityEntity>()
          .toList()),
    );
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() async {
    final response =
        await _apiConsumer.get('${EndPoints.getGovernorates}?page=1&limit=10');
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(
        ((data['data']?['governorate'] ?? data['data']) as List)
            .map((e) => GovernorateModel.fromJson(e))
            .toList(),
      ),
    );
  }
}
