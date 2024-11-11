import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/data/models/add_new_pick_me_model.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/domain/entities/add_new_pick_me_param.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/domain/repo/add_new_pick_me_repo.dart';

class AddNewPickMeUsecase {
  final AddNewPickMeRepo addNewPickMeRepo;

  AddNewPickMeUsecase({required this.addNewPickMeRepo});

  Future<Either<Failure, AddNewPickMeModel>> call({
    required AddNewPickMeParam addNewPickMeParam,
  }) {
    return addNewPickMeRepo.addNewPickMeTrip(
      addNewPickMeParam: addNewPickMeParam,
    );
  }
}
