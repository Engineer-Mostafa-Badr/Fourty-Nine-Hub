class MainCategory {
  String? mainCategoryId;
  String? nameAr;
  String? nameEn;
  String? banner;
  String? cover;
  int? driverLength;
  String? registeredSubcategory;
  bool? isDriver;
  bool? isFavorite;
  bool? isDriverApproved;
  bool? haveTrip;
  MainCategory({
    this.mainCategoryId,
    this.nameAr,
    this.nameEn,
    this.banner,
    this.cover,
    this.haveTrip,
    this.driverLength,
    this.isDriver,
    this.isDriverApproved,
    this.registeredSubcategory,
    this.isFavorite,
  });

  factory MainCategory.fromJson(Map<String, dynamic> json) => MainCategory(
        mainCategoryId: json['mainCategoryId'] as String?,
        nameAr: json['nameAr'] as String?,
        nameEn: json['nameEn'] as String?,
        banner: json['banner'] as String?,
        cover: json['cover'] as String?,
        haveTrip: (json['haveTrip'] as bool?) ?? false,
        driverLength: json['driverLength'] as int?,
        isDriver: (json['isDriver'] as bool?) ?? false,
        isFavorite: (json['isFavorite'] as bool?) ?? false,
        isDriverApproved: (json['isDriverApproved'] as bool?) ?? false,
        registeredSubcategory: json[''] as String?,
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
