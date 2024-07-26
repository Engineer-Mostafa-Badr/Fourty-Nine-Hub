import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/domain/entities/bidding_entity.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/duration_helper.dart';

class AuctionEntity {
  final String id;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final num minPrice;
  final num currentPrice;
  final num rate;
  final AdEntity ad;
  final List<BiddingEntity>? biddings;


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
