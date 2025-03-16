import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/gift_repository.dart';

class RequestWithdrawWalletUseCase extends UseCase<bool, RequestWithdrawParams> {
  final GiftRepository _repository;

  RequestWithdrawWalletUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(RequestWithdrawParams params) async {
    return _repository.requestWithdrawWallet(params);
  }
}

class RequestWithdrawParams {
  final String amount;
  final String phone;

  RequestWithdrawParams({required this.amount, required this.phone});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'phone': phone,
    };
  }
}