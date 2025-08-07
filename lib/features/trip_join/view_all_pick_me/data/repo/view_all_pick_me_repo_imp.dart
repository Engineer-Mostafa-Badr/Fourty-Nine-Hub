import "package:dartz/dartz.dart";
import "../../../../../core/error/failure.dart";
import "../data_source/view_all_pick_me_remote_datasource.dart";
import "../../domain/entities/pickme_entity.dart";
import "../../domain/repo/view_all_pick_me_repo.dart";

class ViewAllPickMeRepoImp implements ViewAllPickMeRepo {
  final ViewAllPickMeRemoteDataSource viewAllPickMeRemoteDataSource;

  ViewAllPickMeRepoImp({required this.viewAllPickMeRemoteDataSource});

  @override
  Future<Either<Failure, List<PickMeCardEntity>>> getAllPickMe(
      {required int page}) {
    return viewAllPickMeRemoteDataSource.getAllPickMe(page: page);
  }

  // @override
  // Future<Either<Failure, bool>> requestTripJoin(
  //     {required String addId,
  //     required String mobile,
  //     bool premuimRequest = false}) {
  //   return viewripJoinRemoteDataSource.requestTripJoin(
  //     addId: addId,
  //     mobile: mobile,
  //     premuimRequest: premuimRequest,
  //   );
  // }
}
