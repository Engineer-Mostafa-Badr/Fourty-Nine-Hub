
import '../../domain/entity/chance_ad_contributor_entity.dart';
import 'user_chance_model.dart';

class ChanceAdContributorModel extends ChanceAdContributorEntity {
  ChanceAdContributorModel({
    required super.id,
    required super.adId,
    required super.userId,
    required super.amount,
    required super.isWinner,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ChanceAdContributorModel.fromJson(Map<String, dynamic> json) {
    return ChanceAdContributorModel(
      id: json['_id'] ?? '',
      adId: json['adId'] is Map<String, dynamic>
          ? json['adId']['_id'] ?? ''
          : json['adId'] as String? ?? '',
      userId: json['userId'] is Map<String, dynamic>
          ? UserChanceModel.fromJson(json['userId'])
          : json['userId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      isWinner: json['isWinner'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'adId': adId,
      'userId': userId,
      'amount': amount,
      'isWinner': isWinner,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}