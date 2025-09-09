class ExchangeRateEntity {
  final String baseCode;
  final String targetCode;
  final double conversionRate;
  final double conversionResult;
  final int timeLastUpdateUnix;
  final String timeLastUpdateUtc;

  ExchangeRateEntity({
    required this.baseCode,
    required this.targetCode,
    required this.conversionRate,
    required this.conversionResult,
    required this.timeLastUpdateUnix,
    required this.timeLastUpdateUtc,
  });
}