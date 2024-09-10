import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/wallet_repo.dart';

class AddSubscriptionUseCase extends UseCase<bool, AddSubscriptionParams> {
  final WalletRepo _walletRepo;

  AddSubscriptionUseCase(this._walletRepo);

  @override
  Future<Either<Failure, bool>> call(AddSubscriptionParams params) async {
    return _walletRepo.addSubscription(params);
  }
}

class AddSubscriptionParams {
  final String subCategoryId;
  final String paymentMethod;
  final bool isPremium;
  final int period;
  final String periodType;

  AddSubscriptionParams(
      {required this.subCategoryId,
      required this.paymentMethod,
      required this.isPremium,
      required this.period,
      required this.periodType});

  Map<String, dynamic> toJson() => {
        'subCategoryId': subCategoryId,
        'paymentMethodType': paymentMethod,
        'isPremium': isPremium,
        'period': period,
        'periodType': periodType,
      };
}
