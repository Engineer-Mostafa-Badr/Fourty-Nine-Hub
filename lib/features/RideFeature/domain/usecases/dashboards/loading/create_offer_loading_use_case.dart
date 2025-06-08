import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/shipping_repository.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../../../entities/dashboards/create_non_track_offer_entity.dart';
import '../../../repositories/ride_repository.dart';
import '../../../repositories/trip_repository.dart';
import '../create_non_track_offer_use_case.dart';




class CreateOfferLoadingUseCase
    extends UseCase<CreateNonTrackOfferEntity, CreateNonTrackOfferParams> {
  final TripRepository _repo;

  CreateOfferLoadingUseCase(this._repo);

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> call(CreateNonTrackOfferParams params) {
    return _repo.createOfferLoading(params);
  }
}


