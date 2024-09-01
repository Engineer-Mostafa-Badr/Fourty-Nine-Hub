import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../models/company_advertise_model.dart';
import '../../models/company_price_model.dart';

abstract class CompanyAdvertiseRepo{
  Future<Either<Failure,AdvertisePriceModel>>fetchPrice();
  Future<Either<Failure,void>>addPostCompanyAdvertise({
    List<String>? mediaIds,
    String? post,
    required String type,
    String? description,
    required int totalPrice,
});

  Future<Either<Failure,AdvertiseCompanyModel>>fetchPostCompanyAdvertise(String filter);
  Future<Either<Failure,void>>deletePosts(String id);
}