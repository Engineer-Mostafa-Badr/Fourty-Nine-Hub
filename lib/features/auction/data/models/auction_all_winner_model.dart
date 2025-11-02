// models/auction_winner_data_model.dart

import '../../domain/entities/auction_all_winner_entity.dart';

class AuctionWinnerDataModel extends AuctionWinnerDataEntity {
  AuctionWinnerDataModel({
    required super.winnersCount,
    required super.allAuctionCount,
  });

  factory AuctionWinnerDataModel.fromJson(Map<String, dynamic> json) {
    return AuctionWinnerDataModel(
      winnersCount: json['winnersCount'] as num,
      allAuctionCount: json['allAuctionCount'] as num,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "winnersCount": winnersCount,
      "allAuctionCount": allAuctionCount,
    };
  }
}
