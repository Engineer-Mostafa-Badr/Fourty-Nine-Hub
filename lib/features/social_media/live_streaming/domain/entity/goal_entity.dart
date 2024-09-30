import 'package:equatable/equatable.dart';

class GoalEntity extends Equatable {
  final String id;
  final String giftId;
  final int goal;
  final int currentValue;

  const GoalEntity({
    required this.id,
    required this.giftId,
    required this.goal,
    required this.currentValue,
  });

  @override
  List<Object?> get props => [id, giftId, goal, currentValue];
}
