import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/domain/entities/filter_entity.dart';

class FilterModel extends FilterEntity {
  FilterModel({required super.price, required super.props,required super.cityId,required super.governorateId,required super.limit,required super.page,required super.subCategoryId});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> filterCriteria = {};
    for (var e in props) {
      if (e.value.nameEn.isNotEmpty) {
        if (e.value.type == 'number') {
          filterCriteria[e.propId] = {
            "type": "number",
            "value": {"min": e.value.nameAr, "max": e.value.nameEn}
          };
        } else {
          filterCriteria[e.propId] = {
            "type": 'string',
            "value": e.value.nameEn
          };
        }
      }
    }
    return {
        "filterCriteria": filterCriteria,
      "price":{
        "min": "number",
        "max": {"min": price.value.nameAr, "max": price.value.nameEn}
      }
      };
  }
}
