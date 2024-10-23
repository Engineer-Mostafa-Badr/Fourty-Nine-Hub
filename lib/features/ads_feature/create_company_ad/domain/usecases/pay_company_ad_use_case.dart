import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/repositories/company_advertise_repository.dart';

class PayCompanyAdUseCase extends UseCase<bool, PayCompanyAdParams> {
  final CompanyAdvertiseRepository _advertiseRepository;

  PayCompanyAdUseCase(this._advertiseRepository);

  @override
  Future<Either<Failure, bool>> call(PayCompanyAdParams params) async {
    return await _advertiseRepository.payCompanyAd(params);
  }
}

class PayCompanyAdParams {
  final num amount;

  PayCompanyAdParams({
    required this.amount,
  });

  Map<String,dynamic> toJson()=>{
    'amount':amount,
  };
}
