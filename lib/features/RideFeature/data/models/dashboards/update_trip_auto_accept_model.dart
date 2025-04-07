import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_auto_accept_entity.dart';

class UpdateTripAutoAcceptModel extends UpdateTripAutoAcceptEntity {
  UpdateTripAutoAcceptModel({required super.id, required super.isAutoAccept});

  factory UpdateTripAutoAcceptModel.fromJson(Map<String, dynamic> json) {
    return UpdateTripAutoAcceptModel(
      id: json['id'] ?? '',
      isAutoAccept: json['autoAccept'] ?? false,
    );
  }
}