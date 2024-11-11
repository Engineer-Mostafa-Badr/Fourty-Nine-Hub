import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/data/data_source/add_new_pick_me_remote_datasource.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/data/models/add_new_pick_me_model.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/domain/entities/add_new_pick_me_param.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/domain/repo/add_new_pick_me_repo.dart';

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
