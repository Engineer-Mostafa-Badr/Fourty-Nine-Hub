import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/models/shipping_request_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/repositories/history_ride_repo.dart';

class GetShippingRequestsUseCase extends UseCase<List<ShippingRequestModel>, NoParams> {
  final RequestHistoryRepo _repository;

  const GetShippingRequestsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ShippingRequestModel>>> call(NoParams params) {
    return _repository.getShippingRequests();
  }
}
