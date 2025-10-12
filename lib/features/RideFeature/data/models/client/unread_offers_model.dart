import 'package:fourtyninehub/features/RideFeature/domain/entities/client/unread_offers_entity.dart';

class UnreadOffersModel extends UnreadOffersEntity{
  UnreadOffersModel({required super.nonTracking, required super.loading});

  //from json
  factory UnreadOffersModel.fromJson(Map<String, dynamic> json) {
    return UnreadOffersModel(
      nonTracking: json['nonTracking']??0,
      loading: json['loading']??0,
    );
  }
}