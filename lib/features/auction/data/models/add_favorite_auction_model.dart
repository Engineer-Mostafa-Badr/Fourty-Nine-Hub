import 'package:fourtyninehub/features/auction/domain/entities/add_favorite_auction_entity.dart';

class AddFavoriteAuctionModel extends AddFavoriteAuctionEntity {
  const AddFavoriteAuctionModel({
    bool? status,
    String? message,
  }) : super(
    status: status,
    message: message,
  );

  factory AddFavoriteAuctionModel.fromJson(Map<String, dynamic> json) {
    return AddFavoriteAuctionModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
