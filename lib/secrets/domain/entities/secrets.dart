import 'package:equatable/equatable.dart';

class Secrets extends Equatable {
  final String googleApiKey;
  final int zegoAppId;
  final String zegoAppSign;

  const Secrets(this.googleApiKey, this.zegoAppId, this.zegoAppSign);

  @override
  List<Object> get props {
    return [googleApiKey, zegoAppId, zegoAppSign];
  }
}
