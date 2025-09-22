class CreateChanceAdModel {
  final String mainCategoryId;
  final String subCategoryId;
  final String title;
  final double price;
  final String description;
  final List<String> mediaIds;

  CreateChanceAdModel({
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.title,
    required this.price,
    required this.description,
    required this.mediaIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'mainCategoryId': mainCategoryId,
      'subCategoryId': subCategoryId,
      'title': title,
      'price': price,
      'description': description,
      'mediaIds': mediaIds,
    };
  }

  factory CreateChanceAdModel.fromJson(Map<String, dynamic> json) {
    return CreateChanceAdModel(
      mainCategoryId: json['mainCategoryId'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      mediaIds: List<String>.from(json['mediaIds'] ?? []),
    );
  }
}