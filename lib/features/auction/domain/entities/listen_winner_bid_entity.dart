class BidWinnerEntity {
  final String? winnerId;
  final String? username;
  final int? price;
  final String? gender;
  final String? auctionTitle;
  final String? auctionId;
  final String? profilePictureKey;
  final String? updatedAt;

  const BidWinnerEntity({
    this.winnerId,
    this.username,
    this.price,
    this.gender,
    this.auctionTitle,
    this.auctionId,
    this.updatedAt,
    this.profilePictureKey,
  });
}
