import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/add_new_pick_me_model.dart';
import '../entities/add_new_pick_me_param.dart';
import '../repo/add_new_pick_me_repo.dart';

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
