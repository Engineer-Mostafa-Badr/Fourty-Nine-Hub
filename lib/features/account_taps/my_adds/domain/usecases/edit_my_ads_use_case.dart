import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../../core/utils/duration_helper.dart';
import '../../../../ads_feature/ads/domain/entities/ad_statistics_entity.dart';
import '../../../../ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../../../requests_history/domain/entities/address_entity.dart';
import '../entity/my_auction_image_entity.dart';
import '../repositories/my_ads_repo.dart';

class EditMyAdsUseCase extends UseCase<bool,EditParams>{
  final MyAdsRepo _adsRepo;

  EditMyAdsUseCase(this._adsRepo);
  @override
  Future<Either<Failure, bool>> call(EditParams params) async{
   return await _adsRepo.editMyAds(params);
  }
}



class EditParams{
  final String id;
  final String? title;
  String? type;
  bool? hasAuction;
  bool? isFavourite;
  final String? description;
  final List<dynamic> images;
  final num? price;
  final bool? active;
  final bool? approved;
  final AdStatisticsEntity? statistics;
  final AddressEntity? address;
  final UserEntity? user;
  List<dynamic>? details;
  DateTime? createdAt;
  final String? phone;
  final String? subCategoryId;
  final String? mainCategoryId;
  final String? userId;
  String? city;
  String? governorate;
  String get formatedDate => DateFormat('yyyy-MM-dd').format(createdAt!);
  Duration get restTimeDuration => DateTime.now().difference(createdAt!);

  String get formattedRestTime =>
      DurationHelper().sinceTime(duration: restTimeDuration);

  EditParams(
      {required this.id,
         this.title,
         this.description,
         required this.images,
        this.price,
        this.type,
        this.city,
        this.governorate,
        this.isFavourite = false,
        this.hasAuction = false,
         this.address,
        this.phone,
        this.statistics,
         this.user,
        this.subCategoryId,
        this.mainCategoryId,
        this.userId,
         this.active,
         this.approved,
         this.details,
         this.createdAt});

  Map<String, dynamic> toJson() => {
    "desc": description,
    "phone": phone,
    "title": title,
    "type": type,
    // "type": (hasAuction==false&&isUser==false)?"provider":(hasAuction==false&&isUser==true)?"user":(hasAuction==true&&isUser==false)?'rent':'sale',
    "subCategoryId": subCategoryId,
    "mainCategoryId": mainCategoryId,
    if (price != null) "price": price,
    // "userId": userId,
    "searchText": "testPropsAndAds",
    "address": {
      "government": governorate,
      "city": city
    },
    "images": images,
    "props": details,
  };
}