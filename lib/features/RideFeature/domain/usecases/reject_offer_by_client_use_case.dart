import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/ride_repository.dart';

class RejectOfferByClientUseCase {
  final RideRepository repository;
  RejectOfferByClientUseCase({required this.repository});
  Future<Either<Failure, void>> call({required String offerId}) async => await repository.rejectOfferByClient(offerId: offerId);
}