import 'package:fourtyninehub/features/health_feature/emergency/domain/entities/emergency_entity.dart';
import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class EmergencyModel extends EmergencyEntity {
  EmergencyModel({required super.id, required super.userId, required super.subCategory, required super.name, required super.phone, required super.address, required super.createdAt, required super.gender});

  //fromJson
  factory EmergencyModel.fromJson(Map<String, dynamic> json) {
    return EmergencyModel(
      id: json['_id']??'',
      userId: json['userId']['_id']??'',
      subCategory: json['subCategory']!=null?SubCategoryModel.fromJson(json['subCategory']):SubCategoryEntity(
        id: '',
        nameAr: '',
        nameEn: '',
        image: '',
        isFavorite: false,
      ),
      name: json['name']??'',
      phone: json['phone']??'',
      address: json['address']??'',
      createdAt: json['createdAt']??'',
      gender: json['userId']['gender']??'male',
    );
  }

}