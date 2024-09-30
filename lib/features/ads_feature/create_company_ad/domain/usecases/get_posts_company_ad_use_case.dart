import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../data/models/fetch_post_company_advertise_params.dart';
import '../entities/company_ad_entity.dart';
import '../repositories/company_advertise_repository.dart';

class GetPostsCompanyAdUseCase
    extends UseCase<List<CompanyAdEntity>, FetchPostCompanyAdvertiseParams> {
  final CompanyAdvertiseRepository _advertiseRepository;

  GetPostsCompanyAdUseCase(this._advertiseRepository);
  @override
  Future<Either<Failure, List<CompanyAdEntity>>> call(
      FetchPostCompanyAdvertiseParams params) async {
    return await _advertiseRepository.getPostCompanyAd(params);
  }
}
