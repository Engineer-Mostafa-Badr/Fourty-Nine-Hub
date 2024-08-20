import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class Government extends Equatable {
  @JsonKey(name: "governorate_name_ar")
  final String? governorateNameAr;
  @JsonKey(name: "governorate_name_en")
  final String? governorateNameEn;
  const Government({
    this.governorateNameAr,
    this.governorateNameEn,
  });

  @override
  List<Object?> get props => [
        governorateNameAr,
        governorateNameEn,
      ];
}
