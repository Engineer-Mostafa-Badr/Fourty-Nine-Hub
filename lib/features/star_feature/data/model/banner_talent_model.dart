import '../../domain/entity/banner_talent_entity.dart';

class BannerTalentModel extends BannerTalentEntity {
  BannerTalentModel(
      {required super.banner,
      required super.titleAr,
      required super.titleEn,
      required super.subTitleAr,
      required super.subTitleEn});

  factory BannerTalentModel.fromJson(Map<String, dynamic> json) {
    return BannerTalentModel(
      banner: json['Banner'] ?? '',
      titleAr: json['title'] != null ? json['title']['ar'] : '',
      titleEn: json['title'] != null ? json['title']['en'] : '',
      subTitleAr: json['subTitle'] != null ? json['subTitle']['ar'] : '',
      subTitleEn: json['subTitle'] != null ? json['subTitle']['en'] : '',
    );
  }
}
