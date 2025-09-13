class GetAvailableAuctionEntity {
  final String? id;
  final String? title;
  final String? description;
  final int? minBiddingPrice;
  final int? price;
  final int? lastPrice;
  final int? numberOfParticipants;
  final DateTime? startAt;
  final DateTime? endAt;
  final List<AuctionMediaEntity>? media;
  final String? status;
  final int? views;
  final bool? isFavorite;
  final DateTime? createdAt;
  final bool? isWinner;
  final dynamic winnerData; // keep dynamic until structure is known

  const GetAvailableAuctionEntity({
    this.id,
    this.title,
    this.description,
    this.minBiddingPrice,
    this.price,
    this.lastPrice,
    this.numberOfParticipants,
    this.startAt,
    this.endAt,
    this.media,
    this.status,
    this.views,
    this.isFavorite,
    this.createdAt,
    this.isWinner,
    this.winnerData,
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
