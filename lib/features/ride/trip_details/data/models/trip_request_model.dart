import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';

import '../../domain/entities/trip_request_entity.dart';

class TripRequestModel extends TripRequestEntity {
  TripRequestModel(
      {required super.id,
      required super.trip,
      required super.createdAt,
      required super.isAccepted,
      required super.isRejected,
      required super.phone,
      required super.user});
  factory TripRequestModel.fromJson(Map<String, dynamic> json) {
    return TripRequestModel(
        id: json['id'] ?? json['_id'],
        trip: json['trip'],
        createdAt: DateTime.parse(json['createdAt']),
        isAccepted: json['isAccepted'],
        isRejected: json['isRejected'],
        phone: json['phone'],
        user:
            json['userId'] == null ? null : UserModel.fromJson(json['userId']));
  }
}
