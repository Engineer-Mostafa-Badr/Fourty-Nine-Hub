import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/client/unread_offers_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/ride_repository.dart';

class GetUnreadOffersUseCase extends UseCase<UnreadOffersEntity, NoParams> {
  final RideRepository _repo;
  GetUnreadOffersUseCase(this._repo);

  @override
  Future<Either<Failure, UnreadOffersEntity>> call(NoParams params) {
    return _repo.getUnreadOffers();
  }
}
