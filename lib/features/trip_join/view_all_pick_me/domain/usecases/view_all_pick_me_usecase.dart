import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/entities/pickme_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/repo/view_all_pick_me_repo.dart';

class ViewAllPickMeUseCase {
  final ViewAllPickMeRepo viewAllPickMeRepo;

  ViewAllPickMeUseCase({required this.viewAllPickMeRepo});
  Future<Either<Failure, List<PickMeCardEntity>>> call({required int page}) {
    return viewAllPickMeRepo.getAllPickMe(page: page);
  }
}
