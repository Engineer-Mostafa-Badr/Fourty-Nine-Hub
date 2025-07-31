import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class ListenToPartialPaymentDriverUseCase
    extends NormalUseCase<void, Function(num)> {
  final TripRepository _repo;
  ListenToPartialPaymentDriverUseCase(this._repo);

  @override
  void call(Function(num amountPaidCash) params) {
    return _repo.listenToPartialPaymentDriver(params);
  }
}
