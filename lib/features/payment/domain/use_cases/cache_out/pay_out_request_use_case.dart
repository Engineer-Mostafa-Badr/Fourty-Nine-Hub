import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../repositories/cache_out/payment_cache_out_repository.dart';

class PayOutRequestUseCase extends UseCase<bool, PayoutRequestParams> {
  final PaymentCacheOutRepository _repo;

  PayOutRequestUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(PayoutRequestParams params) async {
    return await _repo.payoutRequest(params);
  }
}

class PayoutRequestParams {
  final num amount;
  final String payoutMethod;
  final String phoneNumber;
  final String payoutSource;
  String? idNumber;

  PayoutRequestParams(
      {required this.amount,
      required this.payoutMethod,
      required this.phoneNumber,
      required this.payoutSource,
        this.idNumber,
      });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'payoutMethod': payoutMethod,
        'phoneNumber': phoneNumber,
        'payoutSource': payoutSource,
        'idNumber': idNumber,
      };
}
