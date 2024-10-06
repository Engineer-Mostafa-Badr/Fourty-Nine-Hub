import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../entities/instapay_cache_out_entity.dart';
import '../../repositories/cache_out/payment_cache_out_repository.dart';

class InstapayCacheOutUseCase
    extends UseCase<InstapayCacheOutEntity, InstapayParams> {
  final PaymentCacheOutRepository _repo;

  InstapayCacheOutUseCase(this._repo);

  @override
  Future<Either<Failure, InstapayCacheOutEntity>> call(
      InstapayParams params) async {
    return await _repo.instapayCacheOut(params);
  }
}

class InstapayParams {
   String? instaPay;
   String? accountNumber;
   String? accountName;
   String? iban;
   String? bankId;

  InstapayParams(
  {this.instaPay, this.accountNumber, this.accountName, this.iban,
      this.bankId});

   Map<String, dynamic> toJson() => {
     'instaPay': instaPay,
     'bankAccount': {
       'accountNumber': accountNumber,
       'accountName': accountName,
       'iban': iban,
       'bankId': bankId,
     },
   };

}
