import 'package:fourtyninehub/features/lucky_wheel/data/models/wheel_item_model.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_entity.dart';

class WheelModel extends WheelEntity {
  const WheelModel({
    required super.id,
    required super.items,
  });

  factory WheelModel.fromJson(Map<String, dynamic> json) => WheelModel(
        id: json['_id'],
        items: (json['items'] as List)
            .map((item) => WheelItemModel.fromJson(item))
            .toList(),
      );
}
