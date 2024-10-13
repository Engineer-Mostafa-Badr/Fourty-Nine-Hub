import 'package:fourtyninehub/features/search/data/model/ads_search_model.dart';
import 'package:fourtyninehub/features/search/data/model/main_category_search_model.dart';
import 'package:fourtyninehub/features/search/domain/entity/search_entity.dart';

class SearchModel extends SearchEntity {
  SearchModel({
    required super.main,
    required super.sub,
    required super.ads,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      main: (json['mainCategories'] as List)
          .map((e) => MainSubCategorySearchModel.fromJson(e))
          .toList(),
      sub:  (json['subCategories'] as List)
          .map((e) => MainSubCategorySearchModel.fromJson(e))
          .toList(),
      ads:  (json['ads'] as List)
          .map((e) => AdsSearchModel.fromJson(e))
          .toList(),
    );
  }
}
