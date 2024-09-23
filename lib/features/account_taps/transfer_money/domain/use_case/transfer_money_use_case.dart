import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/repository/transfer_money_repository.dart';

class TransferMoneyUseCase extends UseCase<bool, TransferMoneyParams> {
  final TransferMoneyRepository _transferMoneyRepository;

  TransferMoneyUseCase(this._transferMoneyRepository);

  @override
  Future<Either<Failure, bool>> call(TransferMoneyParams params)async {
    return await _transferMoneyRepository.transferMoney(params);
  }
}

class TransferMoneyParams {
  final String receiverUsername;
  final int amount;

  TransferMoneyParams(
      {required this.receiverUsername,
      required this.amount});

  Map<String,dynamic> toJson(){
    return {
      "receiverUsername":receiverUsername,
      "amount":amount,
    };
  }
}
