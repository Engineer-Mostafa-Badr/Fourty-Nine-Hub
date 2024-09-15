import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/wallet_repo.dart';

class DeleteSubscriptionUseCase
    extends UseCase<bool, DeleteSubscriptionParams> {
  final WalletRepo _walletRepo;

  DeleteSubscriptionUseCase(this._walletRepo);
  @override
  Future<Either<Failure, bool>> call(DeleteSubscriptionParams params) async {
    return await _walletRepo.deleteSubscription(params);
  }
}

class DeleteSubscriptionParams {
  String? subscriptionId;

  DeleteSubscriptionParams({
    this.subscriptionId,
  });
}
