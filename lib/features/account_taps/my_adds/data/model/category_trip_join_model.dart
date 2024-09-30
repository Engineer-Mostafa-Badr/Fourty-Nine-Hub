import '../../domain/entity/category_trip_join_entity.dart';

class CategoryTripJoinModel extends CategoryTripJoinEntity {
  CategoryTripJoinModel(
      {required super.id,
      required super.nameAr,
      required super.nameEn,
      required super.paymentMethods});

  factory CategoryTripJoinModel.fromJson(Map<String, dynamic> json) {
    return CategoryTripJoinModel(
      id: json['_id'] ??'',
      nameAr: json['nameAr'] ??'',
      nameEn: json['nameEn'] ??'',
      paymentMethods: json['paymentMethods'] ??'',
    );
  }
}
