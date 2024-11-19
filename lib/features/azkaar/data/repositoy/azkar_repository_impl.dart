import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/azkaar/data/data_source/azkar_remote_data_source.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_details_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_entity.dart';
import 'package:fourtyninehub/features/azkaar/domain/repository/azkar_repository.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_azkar_use_case.dart';
import 'package:fourtyninehub/features/azkaar/domain/use_case/fetch_details_azkar_use_case.dart';

 class AzkarRepositoryImpl extends AzkarRepository{
   final AzkarRemoteDataSource _remoteDataSource;

  AzkarRepositoryImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<AzkarEntity>>> fetchAzkar(AzkarParams params) {
    return _remoteDataSource.fetchAzkar(params);
  }

  @override
  Future<Either<Failure, List<AzkarDetailsEntity>>> fetchAzkarDetail(AzkarDetailsParams params) {
   return _remoteDataSource.fetchAzkarDetail(params);
  }
}