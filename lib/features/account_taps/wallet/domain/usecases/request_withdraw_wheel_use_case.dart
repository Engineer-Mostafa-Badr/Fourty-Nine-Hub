import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/gift_repository.dart';

class RequestWithdrawWheelUseCase extends UseCase<bool, NoParams> {
  final GiftRepository _repository;

  RequestWithdrawWheelUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return _repository.requestWithdrawWheel();
  }
}
