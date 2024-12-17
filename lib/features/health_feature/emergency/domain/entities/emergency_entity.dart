import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class EmergencyEntity{
  final String id;
  final String userId;
  final SubCategoryEntity subCategory;
  final String name;
  final String phone;
  final String address;
  final String createdAt;
  final String gender;

  EmergencyEntity({required this.id, required this.userId, required this.subCategory, required this.name, required this.phone, required this.address, required this.createdAt, required this.gender});

}