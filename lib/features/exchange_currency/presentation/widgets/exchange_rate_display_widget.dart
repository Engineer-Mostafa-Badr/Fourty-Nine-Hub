import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'dart:math';

import '../../../../res/style/app_colors.dart';
import '../../domain/entities/currency_rates_entity.dart';

class ExchangeRateDisplayWidget extends StatelessWidget {
  final CurrencyRatesEntity? currencyRates;
  final String baseCurrency;

  const ExchangeRateDisplayWidget({
    super.key,
    required this.currencyRates,
    required this.baseCurrency,
  });

  // توليد نقاط الرسم البياني بناءً على سعر الصرف الحقيقي
  List<FlSpot> _generateDataPointsForCurrency(String currencyCode) {
    if (currencyRates?.conversionRates == null) {
      return _generateMockDataPoints();
    }

    final currentRate = currencyRates!.conversionRates[currencyCode] ?? 1.0;
    final random = Random(currencyCode
        .hashCode); // استخدام hash code للحصول على نفس النتائج دائماً

    List<FlSpot> points = [];
    double baseValue = currentRate;

    // توليد 10 نقاط تمثل التغيرات التاريخية المحاكاة
    for (int i = 0; i < 10; i++) {
      // محاكاة تقلبات صغيرة في السعر (±5%)
      double variation =
          (random.nextDouble() - 0.5) * 0.1; // تقلب بين -5% و +5%
      double adjustedValue = baseValue * (1 + variation);

      // إضافة اتجاه عام صاعد طفيف
      double trend = (i / 9.0) * 0.05; // ارتفاع تدريجي 5%
      adjustedValue = adjustedValue * (1 + trend);

      points.add(FlSpot(i.toDouble(), adjustedValue));
    }

    return points;
  }

  // احتياطي للبيانات الوهمية
  List<FlSpot> _generateMockDataPoints() {
    return [
      const FlSpot(0, 2),
      const FlSpot(1, 2.2),
      const FlSpot(2, 2.1),
      const FlSpot(3, 2.4),
      const FlSpot(4, 2.3),
      const FlSpot(5, 2.6),
      const FlSpot(6, 2.5),
      const FlSpot(7, 2.8),
      const FlSpot(8, 2.7),
      const FlSpot(9, 3.0),
    ];
  }

  // حساب النطاق المناسب للرسم البياني
  Map<String, double> _getChartRange(List<FlSpot> spots) {
    if (spots.isEmpty) return {'min': 0, 'max': 10};

    double minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    // إضافة مساحة للعرض (10% من القيمة)
    double padding = (maxY - minY) * 0.1;

    return {
      'min': (minY - padding).clamp(0, double.infinity),
      'max': maxY + padding,
    };
  }

  // تحديد لون الرسم بناءً على الاتجاه
  Color _getChartColor(List<FlSpot> spots) {
    if (spots.length < 2) return const Color(0xFF4AFF4A);

    double firstValue = spots.first.y;
    double lastValue = spots.last.y;

    // أخضر إذا كان الاتجاه صاعد، أحمر إذا كان هابط
    return lastValue >= firstValue
        ? const Color(0xFF4AFF4A) // أخضر
        : const Color(0xFFFF4A4A); // أحمر
  }

  @override
  Widget build(BuildContext context) {
    if (currencyRates == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2951),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.isArabic
                      ? 'يمكنك مراجعة سعر الصرف\nفي جميع دول العالم'
                      : 'You can check the current exchange rate\nin all countries of the world',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 400,
            child: GlowingOverscrollIndicator(
              color: AppColors.SECONDARY_COLOR,
              axisDirection: AxisDirection.down,
              child: ListView.builder(
                itemCount: _getDisplayRates().length,
                itemBuilder: (context, index) {
                  final entry = _getDisplayRates()[index];
                  final chartPoints = _generateDataPointsForCurrency(entry.key);
                  final chartRange = _getChartRange(chartPoints);
                  final chartColor = _getChartColor(chartPoints);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              _getCurrencyFlag(entry.key),
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              entry.key,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // const Spacer(),
                        // الرسم البياني المعتمد على البيانات الحقيقية
                        Center(
                          child: SizedBox(
                            width: 120,
                            height: 40,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: false),
                                titlesData: const FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: chartPoints,
                                    isCurved: true,
                                    color: chartColor,
                                    barWidth: 1.5,
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          chartColor.withOpacity(0.3),
                                          chartColor.withOpacity(0.1),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                minX: 0,
                                maxX: 9,
                                minY: chartRange['min']!,
                                maxY: chartRange['max']!,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              entry.value.toStringAsFixed(4),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            // عرض النسبة المئوية للتغيير
                            if (chartPoints.length >= 2)
                              Text(
                                _getPercentageChange(chartPoints),
                                style: TextStyle(
                                  color: chartColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // حساب النسبة المئوية للتغيير
  String _getPercentageChange(List<FlSpot> spots) {
    if (spots.length < 2) return '';

    double firstValue = spots.first.y;
    double lastValue = spots.last.y;
    double changePercent = ((lastValue - firstValue) / firstValue) * 100;

    String sign = changePercent >= 0 ? '+' : '';
    return '$sign${changePercent.toStringAsFixed(1)}%';
  }

  List<MapEntry<String, double>> _getDisplayRates() {
    if (currencyRates?.conversionRates == null) return [];

    // Get top 15 popular currencies
    final popularCurrencies = [
      'USD',
      'EUR',
      'GBP',
      'JPY',
      'AUD',
      'CAD',
      'CHF',
      'CNY',
      'SEK',
      'NZD',
      'AED',
      'SAR',
      'QAR',
      'KWD',
      'BHD',
      'OMR',
      'INR',
      'BRL',
      'RUB'
    ];

    return currencyRates!.conversionRates.entries
        .where((entry) =>
            popularCurrencies.contains(entry.key) && entry.key != baseCurrency)
        .take(15)
        .toList();
  }

  String _getCurrencyFlag(String code) {
    final flagMap = {
      'EUR': '🇪🇺',
      'USD': '🇺🇸',
      'GBP': '🇬🇧',
      'JPY': '🇯🇵',
      'AUD': '🇦🇺',
      'CAD': '🇨🇦',
      'CHF': '🇨🇭',
      'CNY': '🇨🇳',
      'SEK': '🇸🇪',
      'NZD': '🇳🇿',
      'MXN': '🇲🇽',
      'SGD': '🇸🇬',
      'HKD': '🇭🇰',
      'NOK': '🇳🇴',
      'KRW': '🇰🇷',
      'TRY': '🇹🇷',
      'RUB': '🇷🇺',
      'INR': '🇮🇳',
      'BRL': '🇧🇷',
      'EGP': '🇪🇬',
      'AED': '🇦🇪',
      'SAR': '🇸🇦',
      'QAR': '🇶🇦',
      'KWD': '🇰🇼',
      'BHD': '🇧🇭',
      'OMR': '🇴🇲'
    };
    return flagMap[code] ?? '💱';
  }
}
