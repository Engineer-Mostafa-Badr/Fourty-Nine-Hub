import '../../domain/entities/secrets.dart';

class SecretsModel extends Secrets {
  const SecretsModel(super.googleApiKey, super.zegoAppId, super.zegoAppSign);

  factory SecretsModel.fromJson(Map<String, dynamic> json) {
    return SecretsModel(
      json['googleMapsApiKey'],
      int.parse(json['zegoAppId']),
      json['zegoAppSign'],
    );
  }
}
