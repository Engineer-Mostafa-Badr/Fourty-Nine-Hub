import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/data/models/create_carpool_model.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/domain/entities/create_carpool.dart';
import 'package:fourtyninehub/features/trip_join/helpers/print_helper.dart';

abstract class CreateCarpoolRemoteDatasource {
  Future<Either<Failure, CreateCarPoolModel>> createCarPool({
    required CreateCarpoolParam createCarpoolParam,
  });
}

class CreateCarpoolRemoteDatasourceImp extends CreateCarpoolRemoteDatasource {
  final ApiConsumer apiConsumer;

  CreateCarpoolRemoteDatasourceImp({required this.apiConsumer});

  @override
  Future<Either<Failure, CreateCarPoolModel>> createCarPool(
      {required CreateCarpoolParam createCarpoolParam}) async {
    final response = await apiConsumer.post(
      EndPoints.createCarPool,
      data: createCarpoolParam.toMap(),
    );
    // print("this is response1 ===============================\n");
    // print(response);
    const trip = 'createCarPool - createCarpoolRemoteDataSourceImp ';

    return response.fold((failure) => Left(pr(failure, trip)), (data) {
      // print("this is response 2 ===============================\n");
      CreateCarPoolModel createCarPoolModel = CreateCarPoolModel.fromJson(data);
      print("this is response 3===============================\n");

      return right(createCarPoolModel);
    });
  }
}
