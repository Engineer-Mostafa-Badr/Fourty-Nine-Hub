import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/ride_thumbnail_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/ride_request_repo.dart';

class GetRideThumbnailsUseCase
    extends UseCase<List<RideThumbnailEntity>, NoParams> {
  final RideRequestRepo _repo;
  GetRideThumbnailsUseCase(this._repo);

  @override
  Future<Either<Failure, List<RideThumbnailEntity>>> call(NoParams params) {
    throw 'Un implemented get ride thumbnail useCase';
  }
}
