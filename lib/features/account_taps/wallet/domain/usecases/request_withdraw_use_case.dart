import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/gift_repository.dart';

class RequestWithdrawUseCase extends UseCase<bool, String> {
  final GiftRepository _repository;

  RequestWithdrawUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return _repository.requestWithdrawCompetition(params);
  }
}
