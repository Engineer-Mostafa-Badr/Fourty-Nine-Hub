import '../../domain/entities/except_from_entity.dart';

class ExceptFromModel extends ExceptFromEntity {
  ExceptFromModel({
    required String feature,
    required String privacyOption,
    required List<String> allowedUsers,
  }) : super(
    feature: feature,
    privacyOption: privacyOption,
    allowedUsers: allowedUsers,
  );

  // Factory method to create an instance from JSON
  factory ExceptFromModel.fromJson(Map<String, dynamic> json) {
    return ExceptFromModel(
      feature: json['feature'],
      privacyOption: json['privacyOption'],
      allowedUsers: List<String>.from(json['forbiddenUsers']),
    );
  }
}