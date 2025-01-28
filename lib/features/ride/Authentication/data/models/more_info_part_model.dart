import 'package:fourtyninehub/features/ride/Authentication/data/models/base_part_model.dart';

class MoreInfoPartModel implements BasePartModel {
  String? suscription;
  String? city;
  String? pricing;
  MoreInfoPartModel({this.city, this.pricing, this.suscription});
  factory MoreInfoPartModel.fromJson(Map<String, dynamic>? json) {
    return MoreInfoPartModel(
      city: json?['city'],
      pricing: json?['pricing'],
      suscription: json?['suscription']
    );
  }
  @override
  toJson() {
    return {
      "suscription": suscription,
      "city": city,
      "pricing": pricing,
    };
  }
}
