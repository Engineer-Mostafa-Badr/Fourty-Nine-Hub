class LifeEventEntity{
  final String id;
  final String titleAr;
  final String titleEn;
  final String image;
  final List<dynamic> media;
  final String liveEventMainCategoryId;
  LifeEventEntity? mainCat;

  LifeEventEntity({required this.id,required this.titleAr,required this.titleEn,required this.image,required this.media,required this.liveEventMainCategoryId,this.mainCat});
}