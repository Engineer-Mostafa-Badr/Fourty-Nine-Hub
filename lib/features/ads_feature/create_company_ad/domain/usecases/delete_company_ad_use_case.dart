import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/repositories/company_advertise_repository.dart';


class DeleteCompanyAddUseCases extends UseCase<bool,DeleteCompanyAdParams>{
  final CompanyAdvertiseRepository _advertiseRepository;

  DeleteCompanyAddUseCases(this._advertiseRepository);

  @override
  Future<Either<Failure, bool>> call(DeleteCompanyAdParams params)async {
   return await _advertiseRepository.deleteCompanyAd(params);
  }


}

class DeleteCompanyAdParams {
  final String id;

  DeleteCompanyAdParams({
    required this.id,
  });
}
