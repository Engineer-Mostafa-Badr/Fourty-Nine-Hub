
import '../../domain/entities/create_no_track_trip_entity.dart';

class CreateNonTrackTripModel extends CreateNonTrackTripEntity {
  CreateNonTrackTripModel({
    required super.status,
    required super.message,
  });

  factory CreateNonTrackTripModel.fromJson(Map<String, dynamic> json) {
    return CreateNonTrackTripModel(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
