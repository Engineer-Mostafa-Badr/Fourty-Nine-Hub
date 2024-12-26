import 'package:fourtyninehub/core/utils/duration_helper.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';

class StarWinnerEntity {
  final String id;
  final UserStarEntity user;
  final num numberOfWins;
  final num profit;

  DateTime? createdAt;
  String? createAt;
  Duration get publishedDuration => DateTime.now().difference(createdAt!);

  String get sinceTime => DurationHelper().getTimeDifference(createdAt!);

  StarWinnerEntity({
    required this.id,
    required this.user,
    required this.numberOfWins,
    required this.profit,
    this.createdAt,
    this.createAt,
  });
}
