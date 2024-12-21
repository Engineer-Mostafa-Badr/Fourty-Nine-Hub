import 'package:fourtyninehub/features/star_feature/data/model/user_star_model.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

class StarModel extends StarEntity {
  StarModel({
    required super.id,
    required super.user,
    required super.mediaUrl,
    required super.title,
    required super.description,
    required super.isApproved,
    required super.totalViews,
    required super.averageRating,
    super.createdAt,
    super.createAt,
  });

  factory StarModel.fromJson(Map<String, dynamic> json) {
    return StarModel(
      id: json['_id'],
      mediaUrl: (json['mediaUrl'] as List)
          .map((e) => MediaUrlModel.fromJson(e))
          .toList(),
      user: UserStarModel.fromJson(json['userId']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isApproved: json['isApprove'] ?? false,
      totalViews: json['viewNumber'] ?? 0,
      averageRating: json['avgRating'] ?? 0,
      createAt: json['createAt'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

class MediaUrlModel extends MediaUrlEntity {
  MediaUrlModel({required super.id, required super.mediaKey});

  factory MediaUrlModel.fromJson(Map<String, dynamic> json) {
    return MediaUrlModel(
      id: json['_id'] ?? '',
      mediaKey: json['mediaKey'] ?? '',
    );
  }
}
