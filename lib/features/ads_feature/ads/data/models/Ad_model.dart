import '../../../../requests_history/data/models/address_model.dart';
import '../../domain/entities/ad_entity.dart';
import 'detail_model.dart';
import 'publisher_model.dart';

class AdModel extends AdEntity {
  AdModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.images,
      required super.price,
      required super.address,
      required super.user,
      required super.createdAt,
      required super.details});
  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        images: json['images'].cast<String>(),
        price: json['price'],
        address: AddressModel.fromJson(json['address']),
        user: PublisherModel.fromJson(json['user']),
        details: json['details'] == null
            ? []
            : (json['details'] as List)
                .map((e) => DetailModel.fromJson(e))
                .toList(),
        createdAt: DateTime.parse(json['created_at']));
  }
}
