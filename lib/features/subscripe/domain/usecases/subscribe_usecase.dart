import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../core/enums/wallet_types_enums.dart';
import '../repositories/subscription_plans_repo.dart';

class SubscribeUseCase extends UseCase<bool, SubscribeParams> {
  final SubscriptionPlansRepo _repo;
  SubscribeUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(SubscribeParams params) {
    return _repo.subscribe(data: params);
  }
}

class SubscribeParams {
  final String subCategoryId;
  final WalletTypes walletType;
  final bool isPremium;
  final int days;
  SubscribeParams(
      {required this.subCategoryId,
      required this.isPremium,
      required this.walletType,
      required this.days});
  Map<String, dynamic> toJson() => {
        "subCategoryId": subCategoryId,
        "paymentMethod": walletType.value(),
        "isPremium": isPremium,
        "days": days
      };
}
