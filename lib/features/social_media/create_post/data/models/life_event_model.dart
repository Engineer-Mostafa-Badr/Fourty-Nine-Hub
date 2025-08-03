import '../../domain/entities/life_event_entity.dart';

class LifeEventModel extends LifeEventEntity {
  LifeEventModel({required super.id, required super.titleAr, required super.titleEn, required super.image, required super.media, required super.liveEventMainCategoryId});
  factory LifeEventModel.fromJson(Map<String, dynamic> json) {
    return LifeEventModel(
      id: json['_id'] ?? '',
      titleAr: json['titleAr'] ?? '',
      titleEn: json['titleEn'] ?? '',
      image: json['mediaIcon'] ?? '',
      media: json['media'] ?? [],
      liveEventMainCategoryId: json['liveEventMainCategoryId'] ?? '',
    );
  }
}
