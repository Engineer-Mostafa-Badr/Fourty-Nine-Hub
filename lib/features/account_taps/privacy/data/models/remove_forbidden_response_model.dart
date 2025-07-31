


import '../../domain/entities/remove_response_forbidden_entity.dart';

class RemoveForbiddenDataModel extends RemoveForbiddenDataEntity {
  RemoveForbiddenDataModel({
    super.feature,
    super.privacyOption,
    super.forbiddenUsers,
    super.removedUsers,
  });

  factory RemoveForbiddenDataModel.fromJson(Map<String, dynamic> json) {
    return RemoveForbiddenDataModel(
      feature: json['feature'] as String?,
      privacyOption: json['privacyOption'] as String?,
      forbiddenUsers: (json['forbiddenUsers'] as List<dynamic>?)?.map((e) => e as String).toList(),
      removedUsers: (json['removedUsers'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

}
