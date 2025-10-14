// auction_all_winner_model.dart


import '../../domain/entities/all_winner_auction_entity.dart';

class AuctionAllWinnerModel extends AuctionAllWinnerEntity {
  const AuctionAllWinnerModel({
    String? id,
    String? auctionOwner,
    String? mainCategoryId,
    String? subCategoryId,
    String? title,
    String? description,
    num? minBiddingPrice,
    num? price,
    num? lastPrice,
    String? startAt,
    String? endAt,
    List<String>? media,
    int? numberOfParticipants,
    List<String>? views,
    int? viewsCount,
    String? status,
    bool? isPremium,
    String? adminApprovalStatus,
    WinnerModel? winner,
    String? createdAt,
    String? updatedAt,
  }) : super(
    id: id,
    auctionOwner: auctionOwner,
    mainCategoryId: mainCategoryId,
    subCategoryId: subCategoryId,
    title: title,
    description: description,
    minBiddingPrice: minBiddingPrice,
    price: price,
    lastPrice: lastPrice,
    startAt: startAt,
    endAt: endAt,
    media: media,
    numberOfParticipants: numberOfParticipants,
    views: views,
    viewsCount: viewsCount,
    status: status,
    isPremium: isPremium,
    adminApprovalStatus: adminApprovalStatus,
    winner: winner,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory AuctionAllWinnerModel.fromJson(Map<String, dynamic> json) {
    return AuctionAllWinnerModel(
      id: json['_id'] as String?,
      auctionOwner: json['auctionOwner'] as String?,
      mainCategoryId: json['mainCategoryId'] as String?,
      subCategoryId: json['subCategoryId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      minBiddingPrice: json['minBiddingPrice'],
      price: json['price'],
      lastPrice: json['lastPrice'],
      startAt: json['startAt'] as String?,
      endAt: json['endAt'] as String?,
      media: (json['media'] as List?)?.map((e) => e.toString()).toList(),
      numberOfParticipants: json['numberOfParticipants'] as int?,
      views: (json['views'] as List?)?.map((e) => e.toString()).toList(),
      viewsCount: json['viewsCount'] as int?,
      status: json['status'] as String?,
      isPremium: json['isPremium'] as bool?,
      adminApprovalStatus: json['adminApprovalStatus'] as String?,
      winner: json['winnerId'] != null
          ? WinnerModel.fromJson(json['winnerId'])
          : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'auctionOwner': auctionOwner,
      'mainCategoryId': mainCategoryId,
      'subCategoryId': subCategoryId,
      'title': title,
      'description': description,
      'minBiddingPrice': minBiddingPrice,
      'price': price,
      'lastPrice': lastPrice,
      'startAt': startAt,
      'endAt': endAt,
      'media': media,
      'numberOfParticipants': numberOfParticipants,
      'views': views,
      'viewsCount': viewsCount,
      'status': status,
      'isPremium': isPremium,
      'adminApprovalStatus': adminApprovalStatus,
      'winnerId': (winner as WinnerModel?)?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class WinnerModel extends WinnerEntity {
  const WinnerModel({
    String? id,
    String? firstName,
    String? lastName,
    UserProfileModel? userProfile,
  }) : super(id: id, firstName: firstName, lastName: lastName, userProfile: userProfile);

  factory WinnerModel.fromJson(Map<String, dynamic> json) {
    return WinnerModel(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      userProfile: json['USER_PROFILE'] != null
          ? UserProfileModel.fromJson(json['USER_PROFILE'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'USER_PROFILE': (userProfile as UserProfileModel?)?.toJson(),
    };
  }
}

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    String? id,
    String? userId,
    ProfilePictureModel? profilePicture,
  }) : super(id: id, userId: userId, profilePicture: profilePicture);

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      profilePicture: json['profilePictureKey'] != null
          ? ProfilePictureModel.fromJson(json['profilePictureKey'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'profilePictureKey': (profilePicture as ProfilePictureModel?)?.toJson(),
    };
  }
}

class ProfilePictureModel extends ProfilePictureEntity {
  const ProfilePictureModel({
    String? id,
    String? mediaKey,
  }) : super(id: id, mediaKey: mediaKey);

  factory ProfilePictureModel.fromJson(Map<String, dynamic> json) {
    return ProfilePictureModel(
      id: json['_id'] as String?,
      mediaKey: json['mediaKey'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mediaKey': mediaKey,
    };
  }
}
