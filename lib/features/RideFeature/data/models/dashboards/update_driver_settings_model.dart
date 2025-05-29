import '../../../domain/entities/dashboards/update_driver_settings_entity.dart';

class UpdateDriverSettingsModel extends UpdateDriverSettingsEntity {
  const UpdateDriverSettingsModel({
    required bool isReady,
  }) : super(isReady: isReady);

  factory UpdateDriverSettingsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const UpdateDriverSettingsModel(isReady: false); // default if null
    }

    return UpdateDriverSettingsModel(
      isReady: json['isReady'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isReady': isReady,
    };
  }
}
