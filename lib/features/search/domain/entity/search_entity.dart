import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/main_category_search_entity.dart';

class SearchEntity {
  final List<MainSubCategorySearchEntity> main;
  final List<MainSubCategorySearchEntity> sub;
  final List<AdsSearchEntity> ads;

  SearchEntity({required this.main, required this.sub, required this.ads});
}
