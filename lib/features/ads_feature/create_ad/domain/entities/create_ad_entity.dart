import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';

class CreateAdEntity {
  final SelectionEntity value;
  final String propId;
  final String? type;
  final String? nameAr;
  final String? nameEn;

  CreateAdEntity({required this.value, required this.propId, this.type,this.nameAr,this.nameEn});

  Map<String, dynamic> toJson() {
    return {
      "propertyId": propId,
      "type": type,
      "value": value.toJson(),
      "nameAr": nameAr,
      "nameEn": nameEn
    };
  }
}
