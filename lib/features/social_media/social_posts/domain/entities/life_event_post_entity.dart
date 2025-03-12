class LifeEventPostEntity{
  final String id;
  final String title;
  final String desc;
  final String date;
  final String mainCatTitleAr;
  final String mainCatTitleEn;
  final String subCatTitleAr;
  final String subCatTitleEn;
  final String mainCatImage;
  final List<String> subCatImages;

  LifeEventPostEntity({required this.id, required this.title, required this.desc, required this.date, required this.mainCatTitleAr, required this.mainCatTitleEn, required this.subCatTitleAr, required this.subCatTitleEn, required this.mainCatImage, required this.subCatImages});
}