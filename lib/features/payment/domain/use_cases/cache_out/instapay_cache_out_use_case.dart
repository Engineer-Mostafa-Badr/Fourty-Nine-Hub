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
  final String instaPay;

  InstapayParams(
      {required this.instaPay,});

  Map<String,dynamic> toJson()=>{
   instaPay:"instaPay",
  };
}
