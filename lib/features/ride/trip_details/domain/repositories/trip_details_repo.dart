import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../requests_history/data/models/trip_model.dart';
import '../../data/models/cancel_reason_model.dart';

abstract class TripDetailsRepo {
  Future<Either<Failure, TripModel>> getTripDetails({required int tripId});
  Future<Either<Failure, List<CancelReasonModel>>> getCancelReasons();
}
