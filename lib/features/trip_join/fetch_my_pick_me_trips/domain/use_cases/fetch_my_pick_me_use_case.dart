import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/fetch_my_pick_me_model.dart';
import '../repo/fetch_my_pick_me_repo.dart';

class FetchMyPickMeUseCase {
  final FetchMyPickMeRepo fetchMyPickMeRepo;

  FetchMyPickMeUseCase({required this.fetchMyPickMeRepo});

  Future<Either<Failure, List<TripData>>> call({required int page}) async {
    return await fetchMyPickMeRepo.fetchMyPickMeTrips(page: page);
  }
}
