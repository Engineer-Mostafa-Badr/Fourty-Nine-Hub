import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../data_source/add_new_pick_me_remote_datasource.dart';
import '../models/add_new_pick_me_model.dart';
import '../../domain/entities/add_new_pick_me_param.dart';
import '../../domain/repo/add_new_pick_me_repo.dart';

class AddNewPickMeRepoImp extends AddNewPickMeRepo {
  final AddNewPickMeRemoteDatasource addNewPickMeRemoteDatasource;

  AddNewPickMeRepoImp({required this.addNewPickMeRemoteDatasource});
  @override
  Future<Either<Failure, AddNewPickMeModel>> addNewPickMeTrip(
      {required AddNewPickMeParam addNewPickMeParam}) {
    return addNewPickMeRemoteDatasource.addNewPickMeTrip(
      addNewPickMeParam: addNewPickMeParam,
    );
  }
}
