class CategoryId {
  String? id;
  String? picture;
  String? nameAr;
  String? nameEn;

  CategoryId({this.id, this.picture, this.nameAr, this.nameEn});

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        id: json['_id'] as String?,
        picture: json['picture'] as String?,
        nameAr: json['nameAr'] as String?,
        nameEn: json['nameEn'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'picture': picture,
        'nameAr': nameAr,
        'nameEn': nameEn,
      };
}
