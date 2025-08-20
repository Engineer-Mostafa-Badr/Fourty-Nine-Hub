import 'package:dartz/dartz.dart';
import '../repositories/ten_percent_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class SentBillRequestUseCase extends UseCase<bool, SentBillRequestParams> {
  final TenPercentRepo _repo;
  SentBillRequestUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(SentBillRequestParams params) {
    return _repo.sendBillRequest(params: params);
  }
}

class SentBillRequestParams {
  final String? trafficId;
  final String? trafficAmount;
  final String? electricityId;
  final String? electricityAmount;
  final String? mobileId;
  final String? mobileAmount;

  SentBillRequestParams(
      {this.trafficId,
      this.trafficAmount,
      this.electricityId,
      this.electricityAmount,
      this.mobileId,
      this.mobileAmount});

  Map<String, dynamic> toJson() => {
        if (trafficId != null && trafficId!.isNotEmpty)
          "trafficViolation": trafficId,
        if (trafficAmount != null && trafficAmount!.isNotEmpty)
          "trafficViolationAmount": trafficAmount,
        if (electricityId != null && electricityId!.isNotEmpty)
          "electricityBill": electricityId,
        if (electricityAmount != null && electricityAmount!.isNotEmpty)
          "electricityBillAmount": electricityAmount,
        if (mobileId != null && mobileId!.isNotEmpty) "mobileBill": mobileId,
        if (mobileAmount != null && mobileAmount!.isNotEmpty)
          "mobileBillAmount": mobileAmount
      };
}
