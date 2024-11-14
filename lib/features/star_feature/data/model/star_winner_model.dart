import 'package:fourtyninehub/features/star_feature/data/model/user_star_model.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_winner_entity.dart';

class StarWinnerModel extends StarWinnerEntity {
  StarWinnerModel({
    required super.id,
    required super.user,
    required super.numberOfWins,
    required super.profit,
    super.createdAt,
    super.createAt,
  });

  factory StarWinnerModel.fromJson(Map<String, dynamic> json) {
    return StarWinnerModel(
      id: json['_id'],
      user: UserStarModel.fromJson(json['user_id']),
      profit: json['profit'] ?? 0,
      numberOfWins: json['numberOfWins'] ?? 0,
      createAt: json['createAt'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
