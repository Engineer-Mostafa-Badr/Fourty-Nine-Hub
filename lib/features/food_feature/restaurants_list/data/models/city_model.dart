import '../../domain/entities/city.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel extends City {
  const CityModel({
    super.cityNameAr,
    super.cityNameEn,
  });
  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}
