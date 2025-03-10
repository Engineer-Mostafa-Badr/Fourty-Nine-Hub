class Currency {
  final String? currencyEn;
  final String? currencyAr;

  Currency({this.currencyEn, this.currencyAr});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      currencyEn: json['currencyEn'],
      currencyAr: json['currencyAr'],
    );
  }
}