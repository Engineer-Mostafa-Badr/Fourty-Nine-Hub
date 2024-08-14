import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/company_ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/repositories/create_company_ad_repo.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetCompanyAdsOptionsUseCase
    extends UseCase<List<CompanyAdEntity>, NoParams> {
  final CreateCompanyAdRepo _repo;
  GetCompanyAdsOptionsUseCase(this._repo);
  @override
  Future<Either<Failure, List<CompanyAdEntity>>> call(NoParams params) {
    return _repo.getCompanyAdsOptions();
  }
}
