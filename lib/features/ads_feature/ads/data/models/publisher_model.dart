import '../../domain/entities/publisher_entity.dart';

class PublisherModel extends PublisherEntity {
  PublisherModel(
      {required super.id,
      required super.name,
      required super.phone,
      required super.type,
      required super.adsCount,
      required super.email,
      required super.image});
  factory PublisherModel.fromJson(Map<String, dynamic> json) {
    return PublisherModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      type: json['type'],
      adsCount: json['ads_count'],
      email: json['email'],
      image: json['image'],
    );
  }
}
