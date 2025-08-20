import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/get_requests_pick_me_model.dart';

abstract class GetRequestsPickMeRepo {
  Future<Either<Failure, List<TripDataWithRequests>>> getRequestsPickMe();
}
