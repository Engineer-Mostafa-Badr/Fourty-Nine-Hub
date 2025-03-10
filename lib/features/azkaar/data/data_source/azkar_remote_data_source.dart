import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/azkaar/data/model/azkar_details_model.dart';
import 'package:fourtyninehub/features/azkaar/data/model/azkar_model.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_details_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_azkar_use_case.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_details_azkar_use_case.dart';

import '../../domain/entity/azkar_search_entity.dart';
import '../../domain/use_case/search_azkar_usecase.dart';
import '../model/search_azkar_model.dart';

abstract class AzkarRemoteDataSource {
  Future<Either<Failure, List<AzkarEntity>>> fetchAzkar(AzkarParams params);

  Future<Either<Failure, List<AzkarDetailsEntity>>> fetchAzkarDetail(
      AzkarDetailsParams params);
  Future<Either<Failure, List<AzkarSearchEntity>>> searchAzkar(
      SearchAzkarParams parmas);
}

class AzkarRemoteDataSourceImpl extends AzkarRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AzkarRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<AzkarEntity>>> fetchAzkar(
      AzkarParams params) async {
    final response = await _apiConsumer.get(EndPoints.azkar(params));

    return response.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data'] as List)
            .map((e) => AzkarModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, List<AzkarDetailsEntity>>> fetchAzkarDetail(
      AzkarDetailsParams params) async {
    final response = await _apiConsumer.get(EndPoints.azkarDetails(params),
        data: {'category': params.category});

    return response.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data'] as List)
            .map((e) => AzkarDetailsModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, List<AzkarSearchEntity>>> searchAzkar(SearchAzkarParams params) async {
    final response =await _apiConsumer.get(EndPoints.searchAzkar(params),data: {
      'search': params.search
    });
    return response.fold(
        (failure)=> Left(failure),
        (response){
          final list = (response['data'] as List)
              .map((e) => SearchAzkarModel.fromJson(e))
              .toList();
          return Right(list);
        }
    );
  }
}
