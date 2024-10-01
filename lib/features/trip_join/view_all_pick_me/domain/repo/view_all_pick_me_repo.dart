import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/entities/pickme_entity.dart';

abstract class ViewAllPickMeRepo {
  Future<Either<Failure, List<PickMeCardEntity>>> getAllPickMe({required int page});
}
