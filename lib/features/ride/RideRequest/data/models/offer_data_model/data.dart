import 'offer_object.dart';

class Data {
  OfferObject? offerObject;
  String? userId;

  Data({this.offerObject, this.userId});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        offerObject: json['offerObject'] == null
            ? null
            : OfferObject.fromJson(json['offerObject'] as Map<String, dynamic>),
        userId: json['userId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'offerObject': offerObject?.toJson(),
        'userId': userId,
      };
}
