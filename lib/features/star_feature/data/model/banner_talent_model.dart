import 'package:fourtyninehub/features/star_feature/domain/entity/banner_talent_entity.dart';

class BannerTalentModel extends BannerTalentEntity{
  BannerTalentModel({required super.banner, required super.title, required super.subTitle});

  
  factory BannerTalentModel.fromJson(Map<String,dynamic> json){
    return BannerTalentModel(banner: json['Banner'] ??'', title: json['title'] ??'', subTitle: json['subTitle'] ??'');
  }
}