class ProfilePictureKey {
  String? id;
  String? mediaKey;

  ProfilePictureKey({this.id, this.mediaKey});

  @override
  String toString() => 'ProfilePictureKey(id: $id, mediaKey: $mediaKey)';

  factory ProfilePictureKey.fromJson(Map<String, dynamic> json) {
    return ProfilePictureKey(
      id: json['_id'] as String?,
      mediaKey: json['mediaKey'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'mediaKey': mediaKey,
      };
}
