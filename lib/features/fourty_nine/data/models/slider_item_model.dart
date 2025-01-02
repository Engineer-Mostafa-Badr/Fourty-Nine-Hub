import '../../domain/entities/slider_item_entity.dart';

class SliderItemModel extends SliderItemEntity {
  SliderItemModel(
      {required super.id,
      required super.route,
      required super.titleAr,
      required super.titleEn,
      required super.subTitleAr,
      required super.subTitleEn,
      required super.image});
  factory SliderItemModel.fromJson(Map<String, dynamic> json) {
    return SliderItemModel(
      id: json['_id'] ??'',
      route: json['route'] ??"",
      titleAr: json['title']!=null?json['title']['ar'] :'',
      titleEn: json['title']!=null?json['title']['en'] :'',
      subTitleAr: json['subTitle']!=null?json['subTitle']['ar'] :'',
      subTitleEn: json['subTitle']!=null?json['subTitle']['en'] :'',
      image: json['image'] ??'',
    );
  }
}
