import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../data_source/get_requests_pick_me_remote_data_source.dart';
import '../models/get_requests_pick_me_model.dart';
import '../../domain/repo/get_requests_pick_me_repo.dart';

class GetRequestsPickMeRepoImp implements GetRequestsPickMeRepo {
  final GetRequestsPickMeRemoteDataSource getRequestsPickMeRemoteDataSource;

  GetRequestsPickMeRepoImp({required this.getRequestsPickMeRemoteDataSource});
  @override
  Future<Either<Failure, List<TripDataWithRequests>>> getRequestsPickMe() {
    return getRequestsPickMeRemoteDataSource.getRequestPickMeTrips();
  }
}
