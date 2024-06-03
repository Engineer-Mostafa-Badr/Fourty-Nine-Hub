import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/enums/wheel.dart';

class WheelItemEntity extends Equatable {
  final String name;
  final double value;
  final double percentage;
  final WheelItemTypes type;

  const WheelItemEntity({
    required this.name,
    required this.value,
    required this.percentage,
    required this.type,
  });

  @override
  List<Object?> get props => [
        name,
        value,
        percentage,
        type,
      ];
}
