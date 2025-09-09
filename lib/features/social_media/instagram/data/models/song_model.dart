import '../../domain/entities/song_entity.dart';

class SongModel extends SongEntity {
  SongModel({required super.id, required super.name, required super.songUrl, required super.songThumbnailUrl, required super.isSaved, required super.artistName,});

  factory SongModel.fromJson(Map<String, dynamic> json, {bool? isSaved}) {
    return SongModel(
      id: json['id'],
      name: json['name'] ?? '',
      songUrl: json['mediaKey'] ?? '',
      songThumbnailUrl: json['thumbnail'] ?? '',
      isSaved: isSaved ?? json['isSaved'] ?? false,
      artistName: json['singerName'],
    );
  }
}