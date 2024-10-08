import 'package:fourtyninehub/features/chance_feature/domain/entity/Props_Entity_p.dart';

class PostDataEntity {
  String? title;
  int? price;
  List<String>? images;
  String? description;
  String? subCategoryId;
  String? mainCategoryId;
  List<PropsEntity>? props;

  PostDataEntity({
    required this.title,
    required this.price,
    required this.images,
    required  this.description,
    required  this.subCategoryId,
    required  this.mainCategoryId,
    required this.props,
  });
}
