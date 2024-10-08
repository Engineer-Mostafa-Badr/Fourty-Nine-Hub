import 'package:fourtyninehub/features/chance_feature/domain/entity/chance_post_data_entity.dart';

class PostDataMode extends PostDataEntity {
  PostDataMode(
      {required super.title,
      required super.price,
      required super.images,
      required super.description,
      required super.subCategoryId,
      required super.mainCategoryId,
      required super.props});

  factory PostDataMode.fromJson(Map<String, dynamic> json) {
    return PostDataMode(
      title: json["title"]?? '',
      price: json["price"] ??  0,
      images: json["images"] ?? [],
      description: json["description"] ?? "",
      subCategoryId: json["subCategoryId"] ?? "",
      mainCategoryId: json["mainCategoryId"]?? "",
      props: json["props"]?? [],
    );
  }
}
