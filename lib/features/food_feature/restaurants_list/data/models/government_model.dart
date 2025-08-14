import '../../domain/entities/government.dart';
import 'package:json_annotation/json_annotation.dart';

part 'government_model.g.dart';

@JsonSerializable()
class GovernmentModel extends Government {
  const GovernmentModel({
    super.governorateNameAr,
    super.governorateNameEn,
  });
  factory GovernmentModel.fromJson(Map<String, dynamic> json) =>
      _$GovernmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$GovernmentModelToJson(this);
}
