import '../../domain/entities/exchange_rate_entity.dart';

class ExchangeRateModel extends ExchangeRateEntity {
  ExchangeRateModel({
    required super.baseCode,
    required super.targetCode,
    required super.conversionRate,
    required super.conversionResult,
    required super.timeLastUpdateUnix,
    required super.timeLastUpdateUtc,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      baseCode: json['baseCode'] ?? '',
      targetCode: json['targetCode'] ?? '',
      conversionRate: (json['conversionRate'] ?? 0.0).toDouble(),
      conversionResult: (json['conversionResult'] ?? 0.0).toDouble(),
      timeLastUpdateUnix: json['timeLastUpdateUnix'] ?? 0,
      timeLastUpdateUtc: json['timeLastUpdateUtc'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseCode': baseCode,
      'targetCode': targetCode,
      'conversionRate': conversionRate,
      'conversionResult': conversionResult,
      'timeLastUpdateUnix': timeLastUpdateUnix,
      'timeLastUpdateUtc': timeLastUpdateUtc,
    };
  }
}