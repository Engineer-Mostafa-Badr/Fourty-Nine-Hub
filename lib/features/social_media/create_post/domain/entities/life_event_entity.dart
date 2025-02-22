class LifeEventEntity{
  final String id;
  final String titleAr;
  final String titleEn;
  final String image;
  final List<dynamic> media;
  final String liveEventMainCategoryId;
  LifeEventEntity? mainCat;
  DateTime? date;
  String? title;
  String? desc;

  LifeEventEntity({required this.id,required this.titleAr,required this.titleEn,required this.image,required this.media,required this.liveEventMainCategoryId,this.mainCat,this.date,this.title,this.desc});
}