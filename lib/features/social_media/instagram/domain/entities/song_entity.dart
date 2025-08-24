class SongEntity {
  final String id;
  final String name;
  final String songUrl;
  final String songThumbnailUrl;
  bool isSaved = false;
  final String? artistName;

  SongEntity({
    required this.id,
    required this.name,
    required this.songUrl,
    required this.songThumbnailUrl,
    required this.isSaved,
    required this.artistName,
  });
}