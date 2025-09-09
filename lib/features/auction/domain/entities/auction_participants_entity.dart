class AuctionParticipantsEntity {
  final String? userId;
  final String? username;
  final int? newPrice;
  final String? profilePicture;
  final DateTime? createdAt;

  const AuctionParticipantsEntity({
    this.userId,
    this.username,
    this.newPrice,
    this.profilePicture,
    this.createdAt,
  });
}
