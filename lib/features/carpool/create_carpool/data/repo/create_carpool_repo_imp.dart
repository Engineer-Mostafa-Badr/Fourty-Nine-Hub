import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/data/data_source/create_carpool_remote_datasource.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/data/models/create_carpool_model.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/domain/entities/create_carpool.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/domain/repo/create_carpool_repo.dart';

class CreateCarpoolRepoImp extends CreateCarpoolRepo {
  final CreateCarpoolRemoteDatasource createCarpoolRemoteDatasource;

  CreateCarpoolRepoImp({required this.createCarpoolRemoteDatasource});

  @override
  Future<Either<Failure, CreateCarPoolModel>> createCarpool(
      {required CreateCarpoolParam createCarpoolParam}) {
    return createCarpoolRemoteDatasource.createCarPool(
        createCarpoolParam: createCarpoolParam);
  }
}
