class SubCategory {
  String? subCategoryId;
  String? subCategoryNameAr;
  String? subCategoryNameEn;
  String? picture;
  int? driverCount;
  bool? isFavorite;

  SubCategory({
    this.subCategoryId,
    this.subCategoryNameAr,
    this.subCategoryNameEn,
    this.isFavorite,
    this.picture,
    this.driverCount,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        subCategoryId: json['subCategoryId'] as String?,
        subCategoryNameAr: json['subCategoryNameAr'] as String?,
        subCategoryNameEn: json['subCategoryNameEn'] as String?,
        picture: json['picture'] as String?,
        isFavorite: json['isFavorite'] as bool?,
        driverCount: json['driverCount'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'subCategoryId': subCategoryId,
        'subCategoryNameAr': subCategoryNameAr,
        'subCategoryNameEn': subCategoryNameEn,
        'picture': picture,
        'driverCount': driverCount,
      };
}
