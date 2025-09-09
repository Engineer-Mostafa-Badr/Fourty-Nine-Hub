// auction_entity.dart
class GetAvailableAuctionEntity {
  final String? id;
  final String? title;
  final String? description;
  final int? currentPrice;
  final int? startPrice;
  final DateTime? startAt;
  final DateTime? endAt;
  final List<AuctionMediaEntity>? media;
  final String? status;
  final DateTime? createdAt;

  const GetAvailableAuctionEntity({
    this.id,
    this.title,
    this.description,
    this.currentPrice,
    this.startPrice,
    this.startAt,
    this.endAt,
    this.media,
    this.status,
    this.createdAt,
  });
}

class AuctionMediaEntity {
  final String? id;
  final String? mediaKey;

  const AuctionMediaEntity({
    this.id,
    this.mediaKey,
  });
}
