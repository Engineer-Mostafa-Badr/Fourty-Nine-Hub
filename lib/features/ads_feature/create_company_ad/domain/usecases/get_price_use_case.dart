import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/price_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/repositories/company_advertise_repository.dart';

class GetPriceUseCases extends UseCase<PriceEntity, NoParams> {
  final CompanyAdvertiseRepository _advertiseRepository;

  GetPriceUseCases(this._advertiseRepository);
  @override
  Future<Either<Failure, PriceEntity>> call(NoParams params) async {
    return await _advertiseRepository.getPrice();
  }
}
