

import '../../../domain/entities/dashboards/create_non_track_offer_entity.dart';

class CreateNonTrackOfferModel extends CreateNonTrackOfferEntity {
  CreateNonTrackOfferModel({
    required bool status,
    required String message,
  }) : super(
    status: status,
    message: message,
  );

  factory CreateNonTrackOfferModel.fromJson(Map<String, dynamic> json) {
    return CreateNonTrackOfferModel(
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
