
import '../../domain/entities/get_all_auction_entity.dart';
/*
class GetAvailableAuctionModel extends GetAvailableAuctionEntity {
  const GetAvailableAuctionModel({
    super.id,
    super.title,
    super.description,
    super.minBiddingPrice,
    super.price,
    super.lastPrice,
    super.numberOfParticipants,
    super.startAt,
    super.endAt,
    super.media,
    super.status,
    super.views,
    super.isFavorite,
    super.createdAt,
    super.isWinner,
    super.winnerData,
  });

  factory GetAvailableAuctionModel.fromJson(Map<String, dynamic> json) {
    return GetAvailableAuctionModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      minBiddingPrice: json['minBiddingPrice'] as int?,
      price: json['price'] as int?,
      lastPrice: json['lastPrice'] as int?,
      numberOfParticipants: json['numberOfParticipants'] as int?,
      startAt: json['startAt'] != null ? DateTime.parse(json['startAt']) : null,
      endAt: json['endAt'] != null ? DateTime.parse(json['endAt']) : null,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => AuctionMediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      views: json['views'] as int?,
      isFavorite: json['isFavorite'] as bool?,
      createdAt:
      json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      isWinner: json['isWinner'] as bool?,
      winnerData: json['winnerData'], // handle null or object later
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
*/
import '../../domain/entities/get_all_auction_entity.dart';

class GetAvailableAuctionModel extends GetAvailableAuctionEntity {
  const GetAvailableAuctionModel({
    super.id,
    super.title,
    super.description,
    super.minBiddingPrice,
    super.price,
    super.lastPrice,
    super.numberOfParticipants,
    super.startAt,
    super.endAt,
    super.media,
    super.status,
    super.views,
    super.isFavorite,
    super.createdAt,
    super.isWinner,
    super.winnerData,
  });

  factory GetAvailableAuctionModel.fromJson(Map<String, dynamic> json) {
    return GetAvailableAuctionModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      minBiddingPrice: json['minBiddingPrice'] as num?,
      price: json['price'] as num?,
      lastPrice: json['lastPrice'] as num?,
      numberOfParticipants: json['numberOfParticipants'] as num?,
      startAt: json['startAt'] != null ? DateTime.parse(json['startAt']) : null,
      endAt: json['endAt'] != null ? DateTime.parse(json['endAt']) : null,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => AuctionMediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      views: json['views'] as num?,
      isFavorite: json['isFavorite'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      // ✅ Ensure type-safe boolean parsing
      isWinner: json['isWinner'] == true || json['isWinner'] == 'true',
      // ✅ Properly map winnerData object if exists
      winnerData: json['winnerData'] != null
          ? WinnerDataModel.fromJson(json['winnerData'])
          : null,
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

class WinnerDataModel extends WinnerDataEntity {
  const WinnerDataModel({
    super.userId,
    super.firstName,
    super.lastName,
    super.profilePictureKey,
    super.gender,
    super.price,
    super.title,
    super.time,
  });

  factory WinnerDataModel.fromJson(Map<String, dynamic> json) {
    return WinnerDataModel(
      userId: json['userId'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profilePictureKey: json['profilePictureKey'] as String?, // ✅ added
      gender: json['gender'] as String?,
      price: json['price'] as num?,
      title: json['title'] as String?,
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'profilePictureKey': profilePictureKey,
      'gender': gender,
      'price': price,
      'title': title,
      'time': time?.toIso8601String(),
    };
  }
}
