import 'package:dartz/dartz.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../models/add_new_pick_me_model.dart';
import '../../domain/entities/add_new_pick_me_param.dart';
import '../../../helpers/print_helper.dart';

abstract class AddNewPickMeRemoteDatasource {
  Future<Either<Failure, AddNewPickMeModel>> addNewPickMeTrip({
    required AddNewPickMeParam addNewPickMeParam,
  });
}

class AddNewPickMeRemoteDatasourceImp extends AddNewPickMeRemoteDatasource {
  final ApiConsumer apiConsumer;
  AddNewPickMeRemoteDatasourceImp({required this.apiConsumer});

  @override
  Future<Either<Failure, AddNewPickMeModel>> addNewPickMeTrip(
      {required AddNewPickMeParam addNewPickMeParam}) async {
    const trip = 'AddNewPickMe - AddNewPickMeRemoteDataSourceImp ';
    final response = await apiConsumer.post(
      EndPoints.addNewPickMeTrip,
      data: addNewPickMeParam.toMap(),
    );
    print(
        "this is response1 addNewPickMeTrip===============================\n");
    // print(response);
    return response.fold((failure) => Left(pr(failure, trip)), (data) {
      print(
          "this is response 2 addNewPickMeTrip===============================\n");

      AddNewPickMeModel addNewPickMeModel = AddNewPickMeModel.fromJson(data);
      print(
          "this is response 3 addNewPickMeTrip===============================\n");

      pr(addNewPickMeModel.toString(), trip);
      return right(addNewPickMeModel);
    });
  }
}
