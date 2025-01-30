import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_item_entity.dart';

import '../../../../core/enums/wheel.dart';

class WheelItemModel extends WheelItemEntity {
  const WheelItemModel({
    required super.name,
    required super.value,
    required super.percentage,
    required super.type,
  });

  factory WheelItemModel.fromJson(Map<String, dynamic> json) => WheelItemModel(
        name: json['name']??'',
        value: double.parse(json['value'].toString()),
        percentage: double.parse(json['percentage']?.toString() ?? '0'),
        type: WheelItemTypes.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => WheelItemTypes.point,
        ),
      );
}
