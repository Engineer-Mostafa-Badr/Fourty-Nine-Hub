class SelectionEntity {
  final String nameAr;
  final String nameEn;
  final String? type;

  SelectionEntity({required this.nameAr, required this.nameEn,this.type});

  Map<String, dynamic> toJson() {
    return {
      'ar': nameAr,
      'en': nameEn,
      'type': type,
    };
  }
}
