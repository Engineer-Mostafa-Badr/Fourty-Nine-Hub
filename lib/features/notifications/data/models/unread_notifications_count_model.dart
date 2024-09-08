import 'package:fourtyninehub/features/notifications/domain/entities/unread_notifications_count_entity.dart';

class UnreadNotificationsCountModel extends UnreadNotificationsCountEntity {
  UnreadNotificationsCountModel({
    super.appCount,
    super.servicesCount,
    super.socialCount,
    super.total,
  });

  @override
  String toString() {
    return 'UnreadNotificationsCountModel(appCount: $appCount, servicesCount: $servicesCount, socialCount: $socialCount, total: $total)';
  }

  factory UnreadNotificationsCountModel.fromJson(Map<String, dynamic> json) {
    return UnreadNotificationsCountModel(
      appCount: json['appCount'] as int?,
      servicesCount: json['servicesCount'] as int?,
      socialCount: json['socialCount'] as int?,
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'appCount': appCount,
        'servicesCount': servicesCount,
        'socialCount': socialCount,
        'total': total,
      };
}
