import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/get_requests_pick_me_model.dart';
import '../repo/get_requests_pick_me_repo.dart';

class GetRequestsPickMeUseCase {
  final GetRequestsPickMeRepo getRequestsPickMeRepo;

  GetRequestsPickMeUseCase({required this.getRequestsPickMeRepo});

  Future<Either<Failure, List<TripDataWithRequests>>> call() async {
    return await getRequestsPickMeRepo.getRequestsPickMe();
  }
}
