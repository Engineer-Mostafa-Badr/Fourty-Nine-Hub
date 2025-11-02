// auction_banner_model.dart

import '../../domain/entities/auction_banner_entity.dart';

class AuctionBannerModel extends AuctionBannerEntity {
  const AuctionBannerModel({
    super.status,
    super.data,
  });

  factory AuctionBannerModel.fromJson(Map<String, dynamic> json) {
    return AuctionBannerModel(
      status: json['status'] as bool?,
      data: json['data'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data,
    };
  }
}
