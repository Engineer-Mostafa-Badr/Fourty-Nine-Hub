import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/pickme_entity.dart';
import '../repo/view_all_pick_me_repo.dart';

class ViewAllPickMeUseCase {
  final ViewAllPickMeRepo viewAllPickMeRepo;

  ViewAllPickMeUseCase({required this.viewAllPickMeRepo});
  Future<Either<Failure, List<PickMeCardEntity>>> call({required int page}) {
    return viewAllPickMeRepo.getAllPickMe(page: page);
  }
}
