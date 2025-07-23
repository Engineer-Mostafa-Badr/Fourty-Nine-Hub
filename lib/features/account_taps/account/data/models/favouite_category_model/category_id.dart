class CategoryId {
  String? id;
  String? banner;
  String? cover;
  String? nameAr;
  String? nameEn;

  CategoryId({this.id, this.banner, this.cover, this.nameAr, this.nameEn});

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        id: json['_id'] as String?,
        banner: json['bannerUrl'] as String?,
        cover: json['coverUrl'] as String?,
        nameAr: json['nameAr'] as String?,
        nameEn: json['nameEn'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'banner': banner,
        'cover': cover,
        'nameAr': nameAr,
        'nameEn': nameEn,
      };
}
