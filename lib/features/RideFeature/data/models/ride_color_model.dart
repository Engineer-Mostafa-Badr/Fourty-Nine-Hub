import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';

class RideColorModel extends RideColorEntity{
  RideColorModel({required super.id, required super.nameEn, required super.nameAr, required super.code});

  //from json
  factory RideColorModel.fromJson(Map<String, dynamic> json) {
    return RideColorModel(
      id: json['_id']??'',
      nameEn: json['name_english']??'',
      nameAr: json['name_arabic']??'',
      code: json['code']??'',
    );
  }
}