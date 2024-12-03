import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/audio_entity.dart';

class AudioModel extends AudioEntity {
  AudioModel(
      {required super.id, required super.mediaKey, required super.sound});

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
        id: json['_id'] ?? '',
        mediaKey: json['mediaKey'] ?? '',
        sound: json['audios'] ?? '');
  }
}
