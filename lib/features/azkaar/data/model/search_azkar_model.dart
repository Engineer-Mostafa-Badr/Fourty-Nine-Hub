import '../../domain/entity/azkar_search_entity.dart';

class SearchAzkarModel extends AzkarSearchEntity {
  SearchAzkarModel({
    required super.id,
    required super.category,
    required super.zekr,
    required super.search,
  });

  factory SearchAzkarModel.fromJson(Map<String, dynamic> json) {
    return SearchAzkarModel(
      id: json['_id'] ?? '',
      category: json['category'] ?? '',
      zekr: json['zekr'] ?? '',
      search:json['search']?? '',
    );
  }
}
