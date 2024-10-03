class SelectionEntity {
  final String nameAr;
  final String nameEn;

  SelectionEntity({required this.nameAr, required this.nameEn});

  Map<String, dynamic> toJson() {
    return {
      'ar': nameAr,
      'en': nameEn,
    };
  }
}
