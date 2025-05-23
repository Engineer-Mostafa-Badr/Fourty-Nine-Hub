import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/domain/entities/filter_entity.dart';

class FilterModel extends FilterEntity {
  FilterModel(
      {super.price,
      super.props,
      super.cityId,
      super.governorateId,
      super.limit,
      super.page,
      super.subCategoryId,
      super.filter});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> filterCriteria = {};
    for (CreateAdEntity e in props ?? []) {
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
      if (filterCriteria.isNotEmpty) "filterCriteria": filterCriteria,
      if (price != null)
        "price": {
          "min": int.tryParse(price?.value.nameAr ?? '0'),
          "max": int.tryParse(price?.value.nameEn ?? '0')
        },
    };
  }
}
