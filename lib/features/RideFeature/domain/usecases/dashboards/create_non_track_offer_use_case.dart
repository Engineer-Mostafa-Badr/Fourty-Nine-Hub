import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/shipping_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/create_non_track_offer_entity.dart';
import '../../repositories/ride_repository.dart';



class CreateNonTrackOfferUseCase
    extends UseCase<CreateNonTrackOfferEntity, CreateNonTrackOfferParams> {
  final RideRepository _repo;

  CreateNonTrackOfferUseCase(this._repo);

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> call(CreateNonTrackOfferParams params) {
    return _repo.createNonTrackOffer(params);
  }
}
class CreateNonTrackOfferParams {
  final String tripId;
  final num priceOffer;



  CreateNonTrackOfferParams({
    required this.tripId,
    required this.priceOffer,

  });

  Map<String, dynamic> toJson() => {
    'priceOffer': priceOffer,

  };
}

