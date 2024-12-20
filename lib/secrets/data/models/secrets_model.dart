import '../../domain/entities/secrets.dart';

class SecretsModel extends Secrets {
  const SecretsModel(super.googleApiKey, super.zegoAppId, super.zegoAppSign,
      {required super.mapBoxKey,
      required super.hereMapKey,
      required super.openRouteServiceKey,
      required super.tomtomMapKey});

  factory SecretsModel.fromJson(Map<String, dynamic> json) {
    return SecretsModel(
      hereMapKey: json['hereApiKey'],
      mapBoxKey: json['mapBoxApiKey'],
      openRouteServiceKey: json['openRouteServiceApiKey'],
      tomtomMapKey: json['googleMapsApiKey'],
      json['googleMapsApiKey'],
      int.parse(json['zegoAppId']),
      json['zegoAppSign'],
    );
  }
}
