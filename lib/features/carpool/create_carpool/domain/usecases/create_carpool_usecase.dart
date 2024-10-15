import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/data/models/create_carpool_model.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/domain/entities/create_carpool.dart';
import 'package:fourtyninehub/features/carpool/create_carpool/domain/repo/create_carpool_repo.dart';

class CreateCarpoolUsecase {
  final CreateCarpoolRepo createCarpoolRepo;
  CreateCarpoolUsecase({required this.createCarpoolRepo});

  Future<Either<Failure, CreateCarPoolModel>> call({
    required CreateCarpoolParam createCarpoolParam,
  }) {
    return createCarpoolRepo.createCarpool(
      createCarpoolParam: createCarpoolParam,
    );
  }
}
