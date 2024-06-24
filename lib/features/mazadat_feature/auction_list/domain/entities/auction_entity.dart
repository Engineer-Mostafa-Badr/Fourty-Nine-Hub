import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/entities/bidding_entity.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/duration_helper.dart';

class AuctionEntity {
  final int id;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final num minPrice;
  final num currentPrice;
  final num rate;
  final AdEntity ad;
  final List<BiddingEntity>? biddings;
  DateTime get startDateTime =>
      DateFormat('yyyy-MM-dd hh:mm:ss').parse('$startDate $startTime');
  DateTime get endDateTime =>
      DateFormat('yyyy-MM-dd hh:mm:ss').parse('$endDate $endTime');
  Duration get restTimeDuration => endDateTime.difference(DateTime.now());
  double get restTimeRatio =>
      restTimeDuration.inHours / endDateTime.difference(startDateTime).inHours;
  String get formattedRestTime =>
      DurationHelper().sinceTime(duration: restTimeDuration);
  AuctionEntity({
    required this.id,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.minPrice,
    required this.currentPrice,
    required this.rate,
    required this.ad,
    this.biddings,
  });
}
