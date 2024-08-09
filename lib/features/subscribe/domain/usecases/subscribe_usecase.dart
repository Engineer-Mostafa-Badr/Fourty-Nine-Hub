import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../core/enums/wallet_types_enums.dart';
import '../repositories/subscribtion_plans_repo.dart';

class SubscribeUseCase extends UseCase<bool, SubscribeParams> {
  final SubscribtionPlansRepo _repo;
  SubscribeUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(SubscribeParams params) {
    return _repo.subscribe(data: params);
  }
}

class SubscribeParams {
  final String subCategoryId;
  final WalletTypes paymentMenthod;
  final int days;
  SubscribeParams({
    required this. subCategoryId, 
    required this.paymentMenthod, 
    required this.days
  });
  Map<String, dynamic> toJson() => {
        "subCategoryId": "62c8ba9f8e28a58a3edf57eb",
        "paymentMethod": paymentMenthod.value(),
        "days": days
      };
}
