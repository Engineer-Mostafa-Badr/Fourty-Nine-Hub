import '../../domain/entities/audio_entity.dart';


class AudioModel extends AudioEntity {
  AudioModel({required super.id, required super.mediaKey, required super.sound});

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      id: json['_id'] ?? '', // If _id is null, set an empty string
      mediaKey: json['mediaKey'] ?? '', // Default empty string if null
      sound: json['audios'] ?? '', // Default empty string if null
    );
  }
}
