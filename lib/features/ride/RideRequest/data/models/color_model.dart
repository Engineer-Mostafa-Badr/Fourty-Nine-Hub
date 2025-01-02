class ColorModel {
  String? id;
  String? nameEnglish;
  String? nameArabic;
  String? code;

  ColorModel({this.id, this.nameEnglish, this.nameArabic, this.code});

  factory ColorModel.fromJson(Map<String, dynamic> json) => ColorModel(
        id: json['_id'] as String?,
        nameEnglish: json['name_english'] as String?,
        nameArabic: json['name_arabic'] as String?,
        code: json['code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name_english': nameEnglish,
        'name_arabic': nameArabic,
        'code': code,
      };
}
