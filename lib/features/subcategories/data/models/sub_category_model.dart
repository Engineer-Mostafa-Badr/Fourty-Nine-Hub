
import '../../domain/entities/sub_category_entity.dart';

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel(
      {required super.sId,
      required super.nameAr,
      required super.nameEn,
      required super.parent,
      required super.picture});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      sId: json['_id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      parent: json['parent'],
      picture: json['picture'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name_ar'] = nameAr;
    data['name_en'] = nameEn;
    data['parent'] = parent;
    data['picture'] = picture;
    return data;
  }
}
