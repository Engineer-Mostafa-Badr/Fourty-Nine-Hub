import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';

class CreateAdEntity {
  final SelectionEntity value;
  final String propId;
  final String? type;

  CreateAdEntity({required this.value, required this.propId,this.type});

  Map<String, dynamic> toJson() {
    return {
      "propId": propId,
      "type": type,
      "value": value.toJson(),
    };
  }
}
