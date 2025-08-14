import '../../domain/entities/life_event_post_entity.dart';

class LifeEventPostModel extends LifeEventPostEntity {
  LifeEventPostModel({required super.id, required super.title, required super.desc, required super.date, required super.mainCatTitleAr, required super.mainCatTitleEn, required super.subCatTitleAr, required super.subCatTitleEn, required super.mainCatImage, required super.subCatImages});

  factory LifeEventPostModel.fromJson(Map<String, dynamic> json) {
    return LifeEventPostModel(
      id: json['_id']??'',
      title: json['title']??'',
      desc: json['description']??'',
      date: json['date']??'',
      mainCatTitleAr: json['liveEventMainCategoryId']!=null?json['liveEventMainCategoryId']['titleAr']:'',
      mainCatTitleEn: json['liveEventMainCategoryId']!=null?json['liveEventMainCategoryId']['titleEn']:'',
      subCatTitleAr: json['liveEventSubCategoryId']!=null?json['liveEventSubCategoryId']['titleAr']:'',
      subCatTitleEn: json['liveEventSubCategoryId']!=null?json['liveEventSubCategoryId']['titleEn']:'',
      mainCatImage: json['liveEventMainCategoryId']!=null?json['liveEventMainCategoryId']['mediaIcon']:'',
      subCatImages:json['mediaIds'] != null
          ? (json['mediaIds'] as List)
          .map((item) => item['mediaKey'] as String)
          .toList()
          : [],
    );
  }

}