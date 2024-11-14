import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/data/models/get_requests_pick_me_model.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/domain/repo/get_requests_pick_me_repo.dart';

class GetRequestsPickMeUseCase {
  final GetRequestsPickMeRepo getRequestsPickMeRepo;

  GetRequestsPickMeUseCase({required this.getRequestsPickMeRepo});

  Future<Either<Failure, List<TripDataWithRequests>>> call() async {
    return await getRequestsPickMeRepo.getRequestsPickMe();
  }
}
