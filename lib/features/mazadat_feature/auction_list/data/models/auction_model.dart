import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_details/data/models/bidding_model.dart';

import '../../../../authentication/data/models/user_model.dart';
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
      required super.isFinished,
      super.biddings,
      super.user,
      required super.ad});
  factory AuctionModel.fromJson(Map<String, dynamic> json) {
    return AuctionModel(
      id: json['_id'],
      startDate: json['start_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endDate: json['end_date'] ?? '',
      endTime: json['end_time'] ?? '',
      minPrice: json['small_price'],
      isFinished: json['is_finished'] ?? false,
      currentPrice: json['current_price'] ?? json['start_price'],
      rate: json['small_price'] ?? 0,
      biddings: json['biddings'] == null
          ? null
          : (json['biddings'] as List)
              .map((e) => BiddingModel.fromJson(e))
              .toList(),
      user: json['user'] == null ? null : UserModel.fromJson(json['user']),
      ad: AdModel.fromJson(json['ads']),
    );
  }
}
