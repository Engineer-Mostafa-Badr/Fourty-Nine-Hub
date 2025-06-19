import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../data/models/client/driver_all_rating_model.dart';
import '../../entities/client/driver_all_rating_entity.dart';



class GetDriverAllRatingUseCase extends UseCase<DriverAllRatingEntity , DriverAllRatingParams> {
  final RideRepository _repo;

  GetDriverAllRatingUseCase(this._repo);

  @override
  Future<Either<Failure, DriverAllRatingEntity>> call(DriverAllRatingParams params) async {
    return await _repo.getDriverAllRating(params);
  }
}

class DriverAllRatingParams{
 final String id;

  DriverAllRatingParams({required this.id});
}