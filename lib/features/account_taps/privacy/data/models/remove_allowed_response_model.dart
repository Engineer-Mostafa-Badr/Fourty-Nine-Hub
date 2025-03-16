import '../../domain/entities/remove_response_allowed_entity.dart';



class RemoveDataModel extends RemoveDataEntity {
  RemoveDataModel({
    String? feature,
    String? privacyOption,
    List<String>? allowedUsers,
    List<String>? removedUsers,
  }) : super(
    feature: feature,
    privacyOption: privacyOption,
    allowedUsers: allowedUsers,
    removedUsers: removedUsers,
  );

  factory RemoveDataModel.fromJson(Map<String, dynamic> json) {
    return RemoveDataModel(
      feature: json['feature'] as String?,
      privacyOption: json['privacyOption'] as String?,
      allowedUsers: (json['allowedUsers'] as List<dynamic>?)?.map((e) => e as String).toList(),
      removedUsers: (json['removedUsers'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

}
