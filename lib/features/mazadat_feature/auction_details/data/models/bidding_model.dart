import '../../../../authentication/data/models/user_model.dart';
import '../../domain/entities/bidding_entity.dart';

class BiddingModel extends BiddingEntity {
  BiddingModel(
      {required super.id,
      required super.user,
      required super.bidding,
      required super.createdAt});
  factory BiddingModel.fromJson(Map<String, dynamic> json) {
    return BiddingModel(
        id: json['_id'] ?? '',
        user: UserModel.fromJson(json['user_id']),
        bidding: json['price'],
        createdAt: DateTime.parse(json['createdAt']));
  }
}
