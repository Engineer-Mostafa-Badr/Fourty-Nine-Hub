import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/repositories/create_company_ad_repo.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/company_ad_option_entity.dart';

class GetCompanyAdsOptionsUseCase
    extends UseCase<List<CompanyAdOptionEntity>, NoParams> {
  final CreateCompanyAdRepo _repo;
  GetCompanyAdsOptionsUseCase(this._repo);
  @override
  Future<Either<Failure, List<CompanyAdOptionEntity>>> call(NoParams params) {
    return _repo.getCompanyAdsOptions();
  }
}
