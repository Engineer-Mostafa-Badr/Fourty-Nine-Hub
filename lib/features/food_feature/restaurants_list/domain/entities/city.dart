import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class City extends Equatable {
  @JsonKey(name: "city_name_ar")
  final String? cityNameAr;
  @JsonKey(name: "city_name_en")
  final String? cityNameEn;
  const City({
    this.cityNameAr,
    this.cityNameEn,
  });
  @override
  List<Object?> get props => [
        cityNameAr,
        cityNameEn,
      ];
}
