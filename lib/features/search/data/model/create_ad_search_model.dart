import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/selection_model.dart';
import 'package:fourtyninehub/features/search/domain/entity/create_ad_search_entity.dart';

class CreateAdSearchModel extends CreateAdSearchEntity {
  CreateAdSearchModel(
      {required super.value,
        required super.propId,
        super.nameAr,
        super.nameEn,
        super.image});

  factory CreateAdSearchModel.fromJson(Map<String, dynamic> json) {
    final prop = json['props'];
    final property = json['propertyId'];

    final isPropMap = prop is Map<String, dynamic>;
    final isPropertyMap = property is Map<String, dynamic>;

    return CreateAdSearchModel(
      value: SelectionModel.fromJson(json['value']),
      propId: !isPropMap ? prop ?? property : property['_id'] ?? '',
      nameAr: isPropertyMap ? property['name_ar']?.toString() ?? '' : '',
      nameEn: isPropertyMap ? property['name_en']?.toString() ?? '' : '',
      image: isPropertyMap ? property['image'] ?? '' : '',
    );
  }


  @override
  Map<String, dynamic> toJson() {
    return {
      'value': value.toJson(),
      'props': propId,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'image': image
    };
  }
}
