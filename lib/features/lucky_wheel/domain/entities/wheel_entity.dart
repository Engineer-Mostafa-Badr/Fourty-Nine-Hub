import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_item_entity.dart';

class WheelEntity extends Equatable {
  final String id;
  final List<WheelItemEntity> items;

  const WheelEntity({
    required this.id,
    required this.items,
  });

  @override
  List<Object?> get props => [
        id,
        items,
      ];
}
