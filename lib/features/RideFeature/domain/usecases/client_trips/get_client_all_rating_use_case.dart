import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../data/models/client/driver_all_rating_model.dart';
import '../../entities/client/client_all_rating_entity.dart';
import '../../entities/client/driver_all_rating_entity.dart';
import 'get_driver_all_rating_use_case.dart';



class GetClientAllRatingUseCase extends UseCase<ClientAllRatingEntity , DriverAllRatingParams> {
  final RideRepository _repo;

  GetClientAllRatingUseCase(this._repo);

  @override
  Future<Either<Failure, ClientAllRatingEntity>> call(DriverAllRatingParams params) async {
    return await _repo.getClientAllRating(params);
  }
}

