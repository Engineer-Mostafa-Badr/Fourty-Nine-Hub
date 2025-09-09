class CurrencyRatesEntity {
  final String baseCode;
  final int timeLastUpdateUnix;
  final String timeLastUpdateUtc;
  final Map<String, double> conversionRates;

  CurrencyRatesEntity({
    required this.baseCode,
    required this.timeLastUpdateUnix,
    required this.timeLastUpdateUtc,
    required this.conversionRates,
  });
}