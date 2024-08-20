import 'package:equatable/equatable.dart';

class WheelWalletEntity extends Equatable {
  final String id;
  final double amount;
  final double points;
  final int playCount;
  final int maxCount;

  const WheelWalletEntity({
    required this.id,
    required this.amount,
    required this.points,
    required this.playCount,
    required this.maxCount,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        points,
        playCount,
        maxCount,
      ];
}
