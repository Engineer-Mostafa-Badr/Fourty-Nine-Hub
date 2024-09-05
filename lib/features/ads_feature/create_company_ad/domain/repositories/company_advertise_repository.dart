import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/price_entity.dart';

abstract class CompanyAdvertiseRepository{
  Future<Either<Failure,PriceEntity>>getPrice();
}