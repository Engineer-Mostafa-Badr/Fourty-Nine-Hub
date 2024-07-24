import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/data/models/bidding_model.dart';

import '../../domain/entities/auction_entity.dart';

class AuctionModel extends AuctionEntity {
  AuctionModel(
      {required super.id,
      required super.startDate,
      required super.startTime,
      required super.endDate,
      required super.endTime,
      required super.minPrice,
      required super.currentPrice,
      required super.rate,
      super.biddings,
      required super.ad});
  factory AuctionModel.fromJson(Map<String, dynamic> json) {
    return AuctionModel(
      id: json['_id'],
      startDate: json['start_date'],
      startTime: json['start_time'] ?? '',
      endDate: json['end_date'] ?? '',
      endTime: json['end_time'] ?? '',
      minPrice: json['small_price'],
      currentPrice: json['current_price'] ?? json['start_price'],
      rate: json['rate'] ?? 0,
      biddings: json['biddings'] == null
          ? null
          : (json['biddings'] as List)
              .map((e) => BiddingModel.fromJson(e))
              .toList(),
      ad: AdModel.fromJson(json['ads']),
    );
  }
}
