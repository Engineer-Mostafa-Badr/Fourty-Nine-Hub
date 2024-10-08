import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../repositories/cache_out/payment_cache_out_repository.dart';

class RequestInstapayUseCase extends UseCase<bool, RequestInstapayParams> {
  final PaymentCacheOutRepository _repo;

  RequestInstapayUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(RequestInstapayParams params) async {
    return await _repo.requestInstapay(params);
  }
}

class RequestInstapayParams {
  final String amount;
  final String payoutMethod;
  String? phoneNumber;
  final String payoutSource;
  String? bankAccountNumber;
  String? bankName;
  String? cardNumber;
  String? instapayAccount;

  RequestInstapayParams(
      {required this.amount,
      required this.payoutMethod,
      required this.payoutSource,
        this.cardNumber,
        this.bankName,
        this.bankAccountNumber,
        this.phoneNumber,
        this.instapayAccount,
      });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'payoutMethod': payoutMethod,
        'phoneNumber': phoneNumber,
        'payoutSource': payoutSource,
        'bankAccountNumber': bankAccountNumber,
        'bankName': bankName,
        'cardNumber': cardNumber,
        'InstapayAccount': instapayAccount,
      };
}
