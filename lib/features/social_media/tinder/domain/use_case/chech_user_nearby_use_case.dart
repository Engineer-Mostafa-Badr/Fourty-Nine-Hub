import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/near_by_model.dart';
import '../repositories/tinder_repository.dart';

class CheckUserNearbyUseCase extends UseCase<NearByModel, String> {
  final TinderRepository _repository;

  CheckUserNearbyUseCase(this._repository);

  @override
  Future<Either<Failure, NearByModel>> call(String params) {
    return _repository.checkUserNearby(params);
  }
}
