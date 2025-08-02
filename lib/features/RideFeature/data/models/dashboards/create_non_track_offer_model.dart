

import '../../../domain/entities/dashboards/create_non_track_offer_entity.dart';

class CreateNonTrackOfferModel extends CreateNonTrackOfferEntity {
  CreateNonTrackOfferModel({
    required super.status,
    required super.message,
  });

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
