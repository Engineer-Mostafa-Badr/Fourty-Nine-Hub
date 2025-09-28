import '../../domain/entities/auction_participants_entity.dart';

class AuctionParticipantsModel extends AuctionParticipantsEntity {
  const AuctionParticipantsModel({
    super.userId,
    super.username,
    super.newPrice,
    super.profilePicture,
    super.createdAt,
  });

  factory AuctionParticipantsModel.fromJson(Map<String, dynamic> json) {
    return AuctionParticipantsModel(
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      newPrice: json['newPrice'] as int?,
      profilePicture: json['profilePictureKey'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
