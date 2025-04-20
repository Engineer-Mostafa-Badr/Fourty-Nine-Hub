import '../../domain/entities/gift_message_entity.dart';

class GiftMessageModel extends GiftMessageEntity {
  const GiftMessageModel({required super.ar, required super.en});

  factory GiftMessageModel.fromJson(Map<String, dynamic> json) {
    return GiftMessageModel(
      ar: json['ar'],
      en: json['en'],
    );
  }
}
