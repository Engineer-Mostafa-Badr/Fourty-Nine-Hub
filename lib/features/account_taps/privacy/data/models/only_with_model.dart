import '../../domain/entities/only_with_entity.dart';

class OnlyWithModel extends OnlyWithEntity {
  OnlyWithModel({
    required super.feature,
    required super.privacyOption,
    required super.allowedUsers,
  });

  // Factory method to create an instance from JSON
  factory OnlyWithModel.fromJson(Map<String, dynamic> json) {
    return OnlyWithModel(
      feature: json['feature'],
      privacyOption: json['privacyOption'],
      allowedUsers: List<String>.from(json['allowedUsers']),
    );
  }
}