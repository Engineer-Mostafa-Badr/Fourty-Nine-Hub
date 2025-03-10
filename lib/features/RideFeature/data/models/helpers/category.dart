class Category {
  final String? id;
  final String? nameAr;
  final String? nameEn;

  Category({this.id, this.nameAr, this.nameEn});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }
}