import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_history_entity.dart';

import 'user_id.dart';

class TripjoinRequestHistoryModel extends TripJoinRequestHistoryEntity {
  @override
  String? id;
  UserId? userId;
  @override
  String? allowStatus;

  TripjoinRequestHistoryModel({
    this.id,
    this.userId,
    this.allowStatus,
  }) : super(
          id: id,
          userIdStr: userId?.id,
          firstName: userId?.firstName,
          gender: userId?.gender,
          allowStatus: allowStatus,
          //! phone:,
          //! paymentType:,
        );

  @override
  String toString() {
    return 'TripjoinRequestHistoryModel(id: $id, userId: $userId, allowStatus: $allowStatus)';
  }

  factory TripjoinRequestHistoryModel.fromJson(Map<String, dynamic> json) {
    return TripjoinRequestHistoryModel(
      id: json['_id'] as String?,
      userId: json['userId'] == null ? null : UserId.fromJson(json['userId'] as Map<String, dynamic>),
      allowStatus: json['allowStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId?.toJson(),
        'allowStatus': allowStatus,
      };
}
