import '../../../domain/entities/gift_entities.dart';

class CompetitionModel extends Competition {
  const CompetitionModel({
    required super.id,
    required super.maxRequests,
    required super.nameEn,
    required super.nameAr,
    required super.descriptionEn,
    required super.descriptionAr,
  });

  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json['_id'],
      maxRequests: json['maxRequests'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      descriptionEn: json['descriptionEn'],
      descriptionAr: json['descriptionAr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'maxRequests': maxRequests,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'descriptionEn': descriptionEn,
      'descriptionAr': descriptionAr,
    };
  }
}
