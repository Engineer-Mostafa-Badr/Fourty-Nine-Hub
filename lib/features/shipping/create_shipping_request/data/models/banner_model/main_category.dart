class MainCategory {
  String? mainCategoryId;
  String? nameAr;
  String? nameEn;
  String? banner;
  String? cover;
  int? driverLength;

  MainCategory({
    this.mainCategoryId,
    this.nameAr,
    this.nameEn,
    this.banner,
    this.cover,
    this.driverLength,
  });

  factory MainCategory.fromJson(Map<String, dynamic> json) => MainCategory(
        mainCategoryId: json['mainCategoryId'] as String?,
        nameAr: json['nameAr'] as String?,
        nameEn: json['nameEn'] as String?,
        banner: json['banner'] as String?,
        cover: json['cover'] as String?,
        driverLength: json['driverLength'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'mainCategoryId': mainCategoryId,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'banner': banner,
        'cover': cover,
        'driverLength': driverLength,
      };
}
