class GetAvailableAuctionEntity {
  final String? id;
  final String? title;
  final String? description;
  final num? minBiddingPrice;
  final num? price;
  final num? lastPrice;
  final num? numberOfParticipants;
  final DateTime? startAt;
  final DateTime? endAt;
  final List<AuctionMediaEntity>? media;
  final String? status;
  final num? views;
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
  GetAvailableAuctionEntity copyWith({
    String? id,
    String? title,
    String? description,
    num? minBiddingPrice,
    num? price,
    num? lastPrice,
    num? numberOfParticipants,
    DateTime? startAt,
    DateTime? endAt,
    List<AuctionMediaEntity>? media,
    String? status,
    num? views,
    bool? isFavorite,
    DateTime? createdAt,
    bool? isWinner,
    dynamic winnerData,
  }) {
    return GetAvailableAuctionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      minBiddingPrice: minBiddingPrice ?? this.minBiddingPrice,
      price: price ?? this.price,
      lastPrice: lastPrice ?? this.lastPrice,
      numberOfParticipants: numberOfParticipants ?? this.numberOfParticipants,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      media: media ?? this.media,
      status: status ?? this.status,
      views: views ?? this.views,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      isWinner: isWinner ?? this.isWinner,
      winnerData: winnerData ?? this.winnerData,
    );
  }
}

class AuctionMediaEntity {
  final String? id;
  final String? mediaKey;

  const AuctionMediaEntity({
    this.id,
    this.mediaKey,
  });
}
