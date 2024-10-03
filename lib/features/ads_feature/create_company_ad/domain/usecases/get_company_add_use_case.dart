import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/repositories/company_advertise_repository.dart';

import '../entities/company_ad_option_entity.dart';

class GetCompanyAddUseCases
    extends UseCase<CompanyAdOptionEntity, CompanyAddParams> {
  final CompanyAdvertiseRepository _advertiseRepository;

  GetCompanyAddUseCases(this._advertiseRepository);

  @override
  Future<Either<Failure, CompanyAdOptionEntity>> call(
      CompanyAddParams params) async {
    return await _advertiseRepository.addCompanyAd(params);
  }

//   @override
//   Future<Either<Failure, CompanyAdOptionEntity>>> call(
//       CompanyAddParams params) async {
//     return await _advertiseRepository.addCompanyAd(params);
//   }
}

class CompanyAddParams {
  String? post;
  final String advertisementType;
  String? description;
  final num totalPrice;
  List<String>? media;

  CompanyAddParams({
    required this.advertisementType,
    required this.totalPrice,
    this.media,
    this.description,
    this.post,
  });

  Map<String, dynamic> toJson() => {
        'post': post,
        'advertisement_type': advertisementType,
        'description': description,
        'totalPrice': totalPrice,
        'media': media,
      };
}
