
import 'package:fourtyninehub/features/auction/domain/entities/listen_winner_bid_entity.dart';

class BidWinnerModel extends BidWinnerEntity {
  const BidWinnerModel({
    super.winnerId,
    super.username,
    super.price,
    super.gender,
    super.auctionTitle,
    super.auctionId,
  });

  factory BidWinnerModel.fromJson(Map<String, dynamic> json) {
    return BidWinnerModel(
      winnerId: json['winnerId'] as String?,
      username: json['username'] as String?,
      price: json['price'] is int ? json['price'] : int.tryParse(json['price'].toString()),
      gender: json['gender'] as String?,
      auctionTitle: json['auctionTitle'] as String?,
      auctionId: json['auctionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'winnerId': winnerId,
      'username': username,
      'price': price,
      'gender': gender,
      'auctionTitle': auctionTitle,
      'auctionId': auctionId,
    };
  }
}
