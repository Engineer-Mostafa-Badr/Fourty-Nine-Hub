
import '../../domain/entities/my_bidders_entity.dart';

class MyBiddersModel extends MyBiddersEntity {
  const MyBiddersModel({
    super.winnerId,
    super.username,
    super.price,
    super.gender,
    super.email,
    super.phone,
    super.auctionTitle,
    super.auctionId,
    super.subscriptionType,
    super.views,
  });

  factory MyBiddersModel.fromJson(Map<String, dynamic> json) {
    return MyBiddersModel(
      winnerId: json['winnerId'] as String?,
      username: json['username'] as String?,
      price: json['price'] as num?,
      gender: json['gender'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      auctionTitle: json['auctionTitle'] as String?,
      auctionId: json['auctionId'] as String?,
      subscriptionType: json['subscriptionType'] as String?,
      views: json['views'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'winnerId': winnerId,
      'username': username,
      'price': price,
      'gender': gender,
      'email': email,
      'phone': phone,
      'auctionTitle': auctionTitle,
      'auctionId': auctionId,
      'subscriptionType': subscriptionType,
      'views': views,
    };
  }
}
