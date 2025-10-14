// auction_all_winner_entity.dart

class AuctionAllWinnerEntity {
  final String? id;
  final String? auctionOwner;
  final String? mainCategoryId;
  final String? subCategoryId;
  final String? title;
  final String? description;
  final num? minBiddingPrice;
  final num? price;
  final num? lastPrice;
  final String? startAt;
  final String? endAt;
  final List<String>? media;
  final int? numberOfParticipants;
  final List<String>? views;
  final int? viewsCount;
  final String? status;
  final bool? isPremium;
  final String? adminApprovalStatus;
  final WinnerEntity? winner;
  final String? createdAt;
  final String? updatedAt;

  const AuctionAllWinnerEntity({
    this.id,
    this.auctionOwner,
    this.mainCategoryId,
    this.subCategoryId,
    this.title,
    this.description,
    this.minBiddingPrice,
    this.price,
    this.lastPrice,
    this.startAt,
    this.endAt,
    this.media,
    this.numberOfParticipants,
    this.views,
    this.viewsCount,
    this.status,
    this.isPremium,
    this.adminApprovalStatus,
    this.winner,
    this.createdAt,
    this.updatedAt,
  });
}

class WinnerEntity {
  final String? id;
  final String? firstName;
  final String? lastName;
  final UserProfileEntity? userProfile;

  const WinnerEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.userProfile,
  });
}

class UserProfileEntity {
  final String? id;
  final String? userId;
  final ProfilePictureEntity? profilePicture;

  const UserProfileEntity({
    this.id,
    this.userId,
    this.profilePicture,
  });
}

class ProfilePictureEntity {
  final String? id;
  final String? mediaKey;

  const ProfilePictureEntity({
    this.id,
    this.mediaKey,
  });
}
