import 'package:fourtyninehub/features/social_media/tinder/domain/domain/last_seen_entity.dart';

class LastSeenModel extends LastSeenEntity {
  LastSeenModel(
      {required super.id,
      required super.user,
      required super.lastSeen,
      required super.status,
      required super.createdAt,
      required super.updatedAt});

  factory LastSeenModel.fromJson(Map<String, dynamic> json) {
    return LastSeenModel(
      id: json['_id'],
      user: json['user'],
      lastSeen: json['lastSeen'] ?? '',
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
