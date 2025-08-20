import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/pickme_entity.dart';

abstract class ViewAllPickMeRepo {
  Future<Either<Failure, List<PickMeCardEntity>>> getAllPickMe(
      {required int page});
}
