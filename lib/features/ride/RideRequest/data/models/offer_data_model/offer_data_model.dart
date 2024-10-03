import 'data.dart';

class OfferDataModel {
  Data? data;

  OfferDataModel({this.data});

  factory OfferDataModel.fromJson(Map<String, dynamic> json) {
    return OfferDataModel(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
      };
}
