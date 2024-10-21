class SubCategoryId {
  String? id;
  String? nameAr;
  String? nameEn;

  SubCategoryId({this.id, this.nameAr, this.nameEn});

  factory SubCategoryId.fromJson(Map<String, dynamic> json) => SubCategoryId(
        id: json['_id'] as String?,
        nameAr: json['nameAr'] as String?,
        nameEn: json['nameEn'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
      };
}
