import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/add_new_pick_me_model.dart';
import '../entities/add_new_pick_me_param.dart';

abstract class AddNewPickMeRepo {
  Future<Either<Failure, AddNewPickMeModel>> addNewPickMeTrip(
      {required AddNewPickMeParam addNewPickMeParam});
}
