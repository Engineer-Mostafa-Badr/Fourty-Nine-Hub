// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'government_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GovernmentModel _$GovernmentModelFromJson(Map<String, dynamic> json) =>
    GovernmentModel(
      governorateNameAr: json['governorate_name_ar'] as String?,
      governorateNameEn: json['governorate_name_en'] as String?,
    );

Map<String, dynamic> _$GovernmentModelToJson(GovernmentModel instance) =>
    <String, dynamic>{
      'governorate_name_ar': instance.governorateNameAr,
      'governorate_name_en': instance.governorateNameEn,
    };
