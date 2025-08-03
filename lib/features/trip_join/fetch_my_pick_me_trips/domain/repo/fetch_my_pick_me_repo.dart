import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/fetch_my_pick_me_model.dart';

abstract class FetchMyPickMeRepo {
  Future<Either<Failure, List<TripData>>> fetchMyPickMeTrips(
      {required int page});
}
