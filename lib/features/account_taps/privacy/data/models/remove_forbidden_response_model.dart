


import '../../domain/entities/remove_response_forbidden_entity.dart';

class RemoveForbiddenDataModel extends RemoveForbiddenDataEntity {
  RemoveForbiddenDataModel({
    String? feature,
    String? privacyOption,
    List<String>? forbiddenUsers,
    List<String>? removedUsers,
  }) : super(
    feature: feature,
    privacyOption: privacyOption,
    forbiddenUsers: forbiddenUsers,
    removedUsers: removedUsers,
  );

  factory RemoveForbiddenDataModel.fromJson(Map<String, dynamic> json) {
    return RemoveForbiddenDataModel(
      feature: json['feature'] as String?,
      privacyOption: json['privacyOption'] as String?,
      forbiddenUsers: (json['forbiddenUsers'] as List<dynamic>?)?.map((e) => e as String).toList(),
      removedUsers: (json['removedUsers'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

}
