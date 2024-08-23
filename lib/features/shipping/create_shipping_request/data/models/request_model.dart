import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:image_picker/image_picker.dart';

class RequestModel {
  String? receiptPoint;
  String? deliveryPoint;
  String? time;
  String? date;
  List? mediaIds;
  List<XFile>? tripImages;
  String? description;
  String? offerPrice;
  String? phone;
  SubCategoryEntity? subcategoryEntity;
  RequestModel({
    this.deliveryPoint,
    this.description,
    this.mediaIds,
    this.offerPrice,
    this.tripImages,
    this.phone,
    this.date,
    this.subcategoryEntity,
    this.receiptPoint,
    this.time,
  });
  Map<String, dynamic> create() {
    return {
      "categoryId": subcategoryEntity?.id,
      "startLocation": receiptPoint,
      "targetLocation": deliveryPoint,
      "price": offerPrice,
      "time": "$date:$time",
      "desc": description,
      "phone": phone,
      "goodsPicture": mediaIds
    };
  }
}
