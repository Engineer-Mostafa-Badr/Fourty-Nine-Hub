import '../../domain/entities/currency_rates_entity.dart';

class CurrencyRatesModel extends CurrencyRatesEntity {
  CurrencyRatesModel({
    required super.baseCode,
    required super.timeLastUpdateUnix,
    required super.timeLastUpdateUtc,
    required super.conversionRates,
  });

  factory CurrencyRatesModel.fromJson(Map<String, dynamic> json) {
    final ratesData = json['conversionRates'] as Map<String, dynamic>? ?? {};
    final conversionRates = <String, double>{};
    
    ratesData.forEach((key, value) {
      conversionRates[key] = (value ?? 0.0).toDouble();
    });

    return CurrencyRatesModel(
      baseCode: json['baseCode'] ?? '',
      timeLastUpdateUnix: json['timeLastUpdateUnix'] ?? 0,
      timeLastUpdateUtc: json['timeLastUpdateUtc'] ?? '',
      conversionRates: conversionRates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseCode': baseCode,
      'timeLastUpdateUnix': timeLastUpdateUnix,
      'timeLastUpdateUtc': timeLastUpdateUtc,
      'conversionRates': conversionRates,
    };
  }
}