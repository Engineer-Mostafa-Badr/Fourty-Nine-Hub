import '../../domain/entities/only_with_entity.dart';

class OnlyWithModel extends OnlyWithEntity {
  OnlyWithModel({
    required String feature,
    required String privacyOption,
    required List<String> allowedUsers,
  }) : super(
    feature: feature,
    privacyOption: privacyOption,
    allowedUsers: allowedUsers,
  );

  // Factory method to create an instance from JSON
  factory OnlyWithModel.fromJson(Map<String, dynamic> json) {
    return OnlyWithModel(
      feature: json['feature'],
      privacyOption: json['privacyOption'],
      allowedUsers: List<String>.from(json['allowedUsers']),
    );
  }
}