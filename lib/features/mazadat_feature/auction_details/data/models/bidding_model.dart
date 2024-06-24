import 'package:fourtyninehub/features/ads_feature/ads/data/models/publisher_model.dart';

import '../../domain/entities/bidding_entity.dart';

class BiddingModel extends BiddingEntity {
  BiddingModel(
      {required super.id,
      required super.user,
      required super.bidding,
      required super.createdAt});
  factory BiddingModel.fromJson(Map<String, dynamic> json) {
    return BiddingModel(
      id: json['id'],
      user: PublisherModel.fromJson(json['user']),
      bidding: json['bidding'],
      createdAt: DateTime.parse(json['created_at'])
    );
  }
}
