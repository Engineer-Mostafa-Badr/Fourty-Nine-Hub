class CurrencyEntity {
  final String code;
  final String name;
  final String nameAr;
  final String flag;
  final String? countryName;
  final String? countryNameAr;

  CurrencyEntity({
    required this.code,
    required this.name,
    required this.nameAr,
    required this.flag,
    this.countryName,
    this.countryNameAr,
  });
}
