import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';

class CheckUserNearbyUseCase extends UseCase<NearByModel, String> {
  final TinderRepository _repository;

  CheckUserNearbyUseCase(this._repository);

  @override
  Future<Either<Failure, NearByModel>> call(String params) {
    return _repository.checkUserNearby(params);
  }
}
