import 'package:equatable/equatable.dart';

class Secrets extends Equatable {
  final String googleApiKey;
  final int zegoAppId;
  final String zegoAppSign;
  final String mapBoxKey;
  final String hereMapKey;
  final String openRouteServiceKey;
  final String tomtomMapKey;
  const Secrets(this.googleApiKey, this.zegoAppId, this.zegoAppSign,
      {required this.mapBoxKey,
      required this.hereMapKey,
      required this.openRouteServiceKey,
      required this.tomtomMapKey});

  @override
  List<Object> get props {
    return [
      googleApiKey,
      zegoAppId,
      zegoAppSign,
      mapBoxKey,
      hereMapKey,
      openRouteServiceKey,
      tomtomMapKey
    ];
  }
}
