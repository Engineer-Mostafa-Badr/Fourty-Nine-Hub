import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class RequestModel {
  String? receiptPoint;
  String? deliveryPoint;
  String? time;
  String? description;
  String? offerPrice;
  String? phone;
  SubCategoryEntity? subcategoryEntity;
  RequestModel({
    this.deliveryPoint,
    this.description,
    this.offerPrice,
    this.phone,
    this.receiptPoint,
    this.time,
  });
}
