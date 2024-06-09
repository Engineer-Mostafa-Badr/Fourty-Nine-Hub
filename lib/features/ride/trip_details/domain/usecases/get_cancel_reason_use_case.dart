import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/trip_details/data/models/cancel_reason_model.dart';
import '../repositories/trip_details_repo.dart';

class GetCancelReasonUseCase extends UseCase<List<CancelReasonModel>,NoParams> {
  final TripDetailsRepo _repository;

  const GetCancelReasonUseCase(this._repository);

  @override
  Future<Either<Failure, List<CancelReasonModel>>> call(NoParams params) {
    return _repository.getCancelReasons();
  }
}
