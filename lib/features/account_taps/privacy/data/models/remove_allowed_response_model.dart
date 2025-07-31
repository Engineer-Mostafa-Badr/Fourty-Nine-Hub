import '../../domain/entities/remove_response_allowed_entity.dart';



class RemoveDataModel extends RemoveDataEntity {
  RemoveDataModel({
    super.feature,
    super.privacyOption,
    super.allowedUsers,
    super.removedUsers,
  });

  factory RemoveDataModel.fromJson(Map<String, dynamic> json) {
    return RemoveDataModel(
      feature: json['feature'] as String?,
      privacyOption: json['privacyOption'] as String?,
      allowedUsers: (json['allowedUsers'] as List<dynamic>?)?.map((e) => e as String).toList(),
      removedUsers: (json['removedUsers'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

}
