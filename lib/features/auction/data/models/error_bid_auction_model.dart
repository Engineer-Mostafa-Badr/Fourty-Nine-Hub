// data/models/bid_error_model.dart

import '../../domain/entities/error_bid_auction_entity.dart';

class BidErrorModel extends BidErrorEntity {
  const BidErrorModel({required super.error});

  factory BidErrorModel.fromJson(Map<String, dynamic> json) {
    return BidErrorModel(
      error: json['error'] as String? ?? 'Unknown error',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
    };
  }
}
