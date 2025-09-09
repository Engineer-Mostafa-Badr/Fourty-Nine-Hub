// auction_model.dart

import '../../domain/entities/get_all_auction_entity.dart';

class GetAvailableAuctionModel extends GetAvailableAuctionEntity {
  const GetAvailableAuctionModel({
    super.id,
    super.title,
    super.description,
    super.currentPrice,
    super.startPrice,
    super.startAt,
    super.endAt,
    super.media,
    super.status,
    super.createdAt,
  });

  factory GetAvailableAuctionModel.fromJson(Map<String, dynamic> json) {
    return GetAvailableAuctionModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      currentPrice: json['currentPrice'] as int?,
      startPrice: json['startPrice'] as int?,
      startAt: json['startAt'] != null ? DateTime.parse(json['startAt']) : null,
      endAt: json['endAt'] != null ? DateTime.parse(json['endAt']) : null,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => AuctionMediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      createdAt:
      json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

class AuctionMediaModel extends AuctionMediaEntity {
  const AuctionMediaModel({
    super.id,
    super.mediaKey,
  });

  factory AuctionMediaModel.fromJson(Map<String, dynamic> json) {
    return AuctionMediaModel(
      id: json['_id'] as String?,
      mediaKey: json['mediaKey'] as String?,
    );
  }
}
